part of '../../core_imports.dart';

class ActivateAccountResponse {
  final bool success;
  final String? message;

  const ActivateAccountResponse({
    required this.success,
    this.message,
  });

  factory ActivateAccountResponse.fromJson(Map<String, dynamic> json) {
    return ActivateAccountResponse(
      success: json['success'] as bool? ?? true,
      message: json['message']?.toString(),
    );
  }
}
