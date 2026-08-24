import 'package:almasry_2/core/models/response/cart/cart_money_model.dart';
import 'package:almasry_2/core/utils/media_url.dart';

/// One line of `cart.itemsV2.items`.
///
/// [id] is the numeric handle the `removeItemFromCart` / `updateCartItems`
/// mutations take as `cart_item_id`; Magento types it as a `String` on the
/// item itself, so [numericId] does the conversion in one place.
class CartItemModel {
  final String id;
  final String uid;
  final int quantity;
  final String name;
  final String sku;
  final String imageUrl;

  /// The unit price actually charged.
  final double unitPrice;

  /// The pre-discount unit price. Equal to [unitPrice] when nothing is off,
  /// which is what tells the row whether to strike a price through.
  final double regularUnitPrice;

  final double rowTotal;

  const CartItemModel({
    required this.id,
    required this.uid,
    required this.quantity,
    required this.name,
    required this.sku,
    this.imageUrl = '',
    this.unitPrice = 0,
    this.regularUnitPrice = 0,
    this.rowTotal = 0,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> product =
        json['product'] as Map<String, dynamic>? ?? const {};

    final Map<String, dynamic> minimumPrice =
        (product['price_range'] as Map<String, dynamic>?)?['minimum_price']
            as Map<String, dynamic>? ??
        const {};

    final Map<String, dynamic> prices =
        json['prices'] as Map<String, dynamic>? ?? const {};

    final CartMoneyModel linePrice = CartMoneyModel.fromJson(
      prices['price'] as Map<String, dynamic>?,
    );

    final CartMoneyModel finalPrice = CartMoneyModel.fromJson(
      minimumPrice['final_price'] as Map<String, dynamic>?,
    );

    final CartMoneyModel regularPrice = CartMoneyModel.fromJson(
      minimumPrice['regular_price'] as Map<String, dynamic>?,
    );

    // `prices.price` is what the cart charges; the catalogue price is only a
    // fallback for the odd product whose price_range comes back empty.
    final double unitPrice = linePrice.isZero
        ? finalPrice.value
        : linePrice.value;

    return CartItemModel(
      id: json['id']?.toString() ?? '',
      uid: json['uid']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      name: product['name']?.toString() ?? '',
      sku: product['sku']?.toString() ?? '',
      imageUrl: mediaUrlFrom(
        (product['thumbnail'] as Map<String, dynamic>?)?['url']?.toString(),
      ),
      unitPrice: unitPrice,
      regularUnitPrice: regularPrice.isZero ? unitPrice : regularPrice.value,
      rowTotal: CartMoneyModel.fromJson(
        prices['row_total'] as Map<String, dynamic>?,
      ).value,
    );
  }

  /// 0 when the id is not a number — the callers treat that as "not
  /// removable" rather than firing a mutation that cannot match a line.
  int get numericId => int.tryParse(id) ?? 0;

  bool get hasDiscount => regularUnitPrice > unitPrice;
}
