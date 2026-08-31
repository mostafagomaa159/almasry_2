class SetShippingMethodRequest {
  final String cartId;
  final String carrierCode;
  final String methodCode;

  const SetShippingMethodRequest({
    required this.cartId,
    required this.carrierCode,
    required this.methodCode,
  });

  Map<String, dynamic> toVariables() {
    return {
      'cartId': cartId,
      'carrierCode': carrierCode,
      'methodCode': methodCode,
    };
  }
}

class SetPaymentMethodRequest {
  final String cartId;
  final String code;
  final String selectedOption;

  const SetPaymentMethodRequest({
    required this.cartId,
    required this.code,
    this.selectedOption = '',
  });

  Map<String, dynamic> toVariables() {
    return {
      'cartId': cartId,
      'code': code,
      'selectedOption': selectedOption.trim().isEmpty
          ? null
          : selectedOption.trim(),
    };
  }
}
