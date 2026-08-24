/// `placeOrder` answers with either an order number or a list of errors —
/// crucially it returns HTTP 200 for both, so a caller that only checks for a
/// thrown exception would report a failed order as a success.
class PlaceOrderResponse {
  final String orderNumber;
  final List<String> errors;

  const PlaceOrderResponse({this.orderNumber = '', this.errors = const []});

  factory PlaceOrderResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? placeOrder =
        json['placeOrder'] as Map<String, dynamic>?;

    return PlaceOrderResponse(
      orderNumber:
          (placeOrder?['orderV2'] as Map<String, dynamic>?)?['number']
              ?.toString() ??
          '',
      errors: (placeOrder?['errors'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(
            (Map<String, dynamic> error) => error['message']?.toString() ?? '',
          )
          .where((String message) => message.trim().isNotEmpty)
          .toList(),
    );
  }

  bool get isSuccess => orderNumber.trim().isNotEmpty && errors.isEmpty;
}
