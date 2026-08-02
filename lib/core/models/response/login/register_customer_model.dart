class RegisterCustomerModel {
  final String? token;
  final String? cartId;
  final String? activationCode;
  final String? mobileNumber;
  final bool? isVerified;
  final int? customerId;

  const RegisterCustomerModel({
    this.token,
    this.cartId,
    this.activationCode,
    this.mobileNumber,
    this.isVerified,
    this.customerId,
  });

  factory RegisterCustomerModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>?;

    return RegisterCustomerModel(
      token: json['token']?.toString(),
      cartId: json['cart_id']?.toString(),
      activationCode: json['activation_code']?.toString(),
      mobileNumber: json['mobile_number']?.toString(),
      isVerified: json['is_verified'] as bool?,
      customerId: customer?['id'] as int?,
    );
  }
}
