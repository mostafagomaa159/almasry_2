part of '../../core_imports.dart';

class AuthAfterOtpResponse {
  final String? token;
  final String? cartId;
  final String? mobileNumber;
  final int? customerId;

  const AuthAfterOtpResponse({
    this.token,
    this.cartId,
    this.mobileNumber,
    this.customerId,
  });

  factory AuthAfterOtpResponse.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>?;

    return AuthAfterOtpResponse(
      token: json['token']?.toString(),
      cartId: json['cart_id']?.toString(),
      mobileNumber: json['mobile_number']?.toString(),
      customerId: customer?['id'] as int?,
    );
  }
}
