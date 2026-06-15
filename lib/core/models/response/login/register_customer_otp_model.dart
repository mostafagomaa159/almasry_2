
class RegisterCustomerOtpModel {
  final String? token;
  final String? cartId;
  final String? mobileNumber;
  final int? customerId;

  const RegisterCustomerOtpModel({
    this.token,
    this.cartId,
    this.mobileNumber,
    this.customerId,
  });

  factory RegisterCustomerOtpModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>?;

    return RegisterCustomerOtpModel(
      token: json['token']?.toString(),
      cartId: json['cart_id']?.toString(),
      mobileNumber: json['mobile_number']?.toString(),
      customerId: customer?['id'] as int?,
    );
  }
}
