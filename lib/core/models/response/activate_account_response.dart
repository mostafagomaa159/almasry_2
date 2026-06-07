
class ActivateAccountResponse {
  final String? status;
  final String? message;

  ActivateAccountResponse({
    this.status,
    this.message,
  });

  factory ActivateAccountResponse.fromJson(Map<String, dynamic> json) {
    return ActivateAccountResponse(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
    );
  }
}

