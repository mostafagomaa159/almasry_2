import 'package:almasry_2/core/models/response/cart/cart_item_model.dart';
import 'package:almasry_2/core/models/response/cart/cart_prices_model.dart';
import 'package:almasry_2/core/models/response/checkout/shipping_method_model.dart';

/// `cart.selected_payment_method`.
class CartPaymentMethodModel {
  final String code;
  final String title;
  final String selectedOption;

  const CartPaymentMethodModel({
    this.code = '',
    this.title = '',
    this.selectedOption = '',
  });

  factory CartPaymentMethodModel.fromJson(Map<String, dynamic>? json) {
    return CartPaymentMethodModel(
      code: json?['code']?.toString() ?? '',
      title: json?['title']?.toString() ?? '',
      selectedOption: json?['selected_option']?.toString() ?? '',
    );
  }

  bool get isEmpty => code.trim().isEmpty;

  /// "installments - Souhoola" on the order review.
  ///
  /// The cart returns the option's *code* (`souhoola`), not its display name —
  /// only `available_payment_methods` carries that — so the code is title-cased
  /// rather than re-queried just for a label.
  String get displayTitle {
    final String label = title.trim().isNotEmpty ? title.trim() : code;

    if (selectedOption.trim().isEmpty) return label;

    return '$label - ${_prettify(selectedOption.trim())}';
  }

  static String _prettify(String optionCode) {
    return optionCode
        .split(RegExp('[-_]'))
        .where((String word) => word.isNotEmpty)
        .map(
          (String word) =>
              word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }
}

/// One entry of `cart.shipping_addresses`. The cart is single-shipment here,
/// so only the first is ever read.
class CartShippingAddressModel {
  final String firstName;
  final String lastName;
  final List<String> street;
  final String city;
  final String telephone;
  final ShippingMethodModel? selectedShippingMethod;

  const CartShippingAddressModel({
    this.firstName = '',
    this.lastName = '',
    this.street = const [],
    this.city = '',
    this.telephone = '',
    this.selectedShippingMethod,
  });

  factory CartShippingAddressModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? method =
        json['selected_shipping_method'] as Map<String, dynamic>?;

    return CartShippingAddressModel(
      firstName: json['firstname']?.toString() ?? '',
      lastName: json['lastname']?.toString() ?? '',
      street: (json['street'] as List<dynamic>? ?? const [])
          .map((dynamic line) => line?.toString() ?? '')
          .where((String line) => line.trim().isNotEmpty)
          .toList(),
      city: json['city']?.toString() ?? '',
      telephone: json['telephone']?.toString() ?? '',
      selectedShippingMethod: method == null
          ? null
          : ShippingMethodModel.fromJson(method),
    );
  }

  String get summaryLine => street.join(' - ');
}

/// The whole `cart` payload — what `GraphQLDocuments.cartFragment` selects, so
/// the details query and every add / remove / update mutation parse the same
/// way and each one leaves the app holding a complete cart.
class CartModel {
  final String id;
  final int totalQuantity;
  final List<CartItemModel> items;
  final CartPricesModel prices;
  final CartPaymentMethodModel selectedPaymentMethod;
  final CartShippingAddressModel? shippingAddress;

  const CartModel({
    this.id = '',
    this.totalQuantity = 0,
    this.items = const [],
    this.prices = const CartPricesModel(),
    this.selectedPaymentMethod = const CartPaymentMethodModel(),
    this.shippingAddress,
  });

  /// Digs the cart out of whichever wrapper the operation used — `cart` for the
  /// query, `<mutationName>.cart` for the mutations.
  factory CartModel.fromResponse(
    Map<String, dynamic> json, {
    String? mutationKey,
  }) {
    final Map<String, dynamic>? root = mutationKey == null
        ? json['cart'] as Map<String, dynamic>?
        : (json[mutationKey] as Map<String, dynamic>?)?['cart']
              as Map<String, dynamic>?;

    return CartModel.fromJson(root);
  }

  factory CartModel.fromJson(Map<String, dynamic>? json) {
    final Map<String, dynamic>? itemsV2 =
        json?['itemsV2'] as Map<String, dynamic>?;

    final List<CartItemModel> items =
        (itemsV2?['items'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(CartItemModel.fromJson)
            .toList();

    final List<Map<String, dynamic>> addresses =
        (json?['shipping_addresses'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();

    return CartModel(
      id: json?['id']?.toString() ?? '',
      // `total_quantity` counts units; the badge falls back to the line count
      // for the stores that leave it null.
      totalQuantity:
          (json?['total_quantity'] as num?)?.toInt() ??
          items.fold(0, (int sum, CartItemModel item) => sum + item.quantity),
      items: items,
      prices: CartPricesModel.fromJson(
        json?['prices'] as Map<String, dynamic>?,
      ),
      selectedPaymentMethod: CartPaymentMethodModel.fromJson(
        json?['selected_payment_method'] as Map<String, dynamic>?,
      ),
      shippingAddress: addresses.isEmpty
          ? null
          : CartShippingAddressModel.fromJson(addresses.first),
    );
  }

  bool get isEmpty => items.isEmpty;

  ShippingMethodModel? get selectedShippingMethod =>
      shippingAddress?.selectedShippingMethod;

  double get shippingCost => selectedShippingMethod?.price ?? 0;

  double get subtotal => prices.subtotal;

  double get discountTotal => prices.discountTotal;

  double get taxTotal => prices.taxTotal;

  /// Magento's `grand_total` only includes shipping once a method is set, so
  /// before that step the screens add the quoted cost themselves.
  double get grandTotal {
    if (!prices.grandTotal.isZero) return prices.grandTotal.value;

    return subtotal + shippingCost - discountTotal + taxTotal;
  }
}
