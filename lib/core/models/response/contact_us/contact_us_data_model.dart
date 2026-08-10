part of '../../../../features/contact_us/contact_us_imports.dart';

class SubmitContactFormResponse {
  final bool status;

  const SubmitContactFormResponse({required this.status});

  factory SubmitContactFormResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? contactUs =
        json['contactUs'] as Map<String, dynamic>?;

    return SubmitContactFormResponse(
      status: contactUs?['status'] as bool? ?? false,
    );
  }
}
