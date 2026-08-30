class RegisterCustomerOtpModel {
  final String? token;
  final String? cartId;
  final String? mobileNumber;
  final int? customerId;

  /// The account's email, when the reply carries one. A phone-registered
  /// customer still has one in Magento, and it is the only place this app can
  /// learn it — the OTP flow never asks for an address.
  final String? email;

  const RegisterCustomerOtpModel({
    this.token,
    this.cartId,
    this.mobileNumber,
    this.customerId,
    this.email,
  });

  factory RegisterCustomerOtpModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>?;

    return RegisterCustomerOtpModel(
      token: json['token']?.toString(),
      cartId: json['cart_id']?.toString(),
      mobileNumber: json['mobile_number']?.toString(),
      customerId: customer?['id'] as int?,
      email: customer?['email']?.toString(),
    );
  }
}
