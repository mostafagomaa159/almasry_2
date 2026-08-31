import 'package:almasry_2/core/models/response/checkout/address_model.dart';

class AddressFormArgs {
  final AddressModel? address;

  const AddressFormArgs({this.address});
}

class OrderConfirmedArgs {
  final String orderNumber;
  final double grandTotal;

  final String status;

  const OrderConfirmedArgs({
    required this.orderNumber,
    required this.grandTotal,
    this.status = 'pending',
  });
}
