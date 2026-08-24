import 'package:almasry_2/core/models/response/checkout/address_model.dart';

/// `extra` for the address form. A null [address] opens it empty for a new
/// entry; passing one opens it for editing.
class AddressFormArgs {
  final AddressModel? address;

  const AddressFormArgs({this.address});
}

/// `extra` for the order-confirmed screen. Everything on it comes from the
/// `placeOrder` response and the cart that was just cleared, so the screen
/// itself makes no request.
class OrderConfirmedArgs {
  final String orderNumber;
  final double grandTotal;

  /// Magento starts a placed order in `pending`; the screen prints whatever it
  /// is handed rather than assuming.
  final String status;

  const OrderConfirmedArgs({
    required this.orderNumber,
    required this.grandTotal,
    this.status = 'pending',
  });
}
