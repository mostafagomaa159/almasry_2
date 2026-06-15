
class ActivateAccountModel {
  final String? status;
  final String? message;

  ActivateAccountModel({
    this.status,
    this.message,
  });

  factory ActivateAccountModel.fromJson(Map<String, dynamic> json) {
    return ActivateAccountModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
    );
  }
}

