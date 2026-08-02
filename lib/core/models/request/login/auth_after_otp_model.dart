class AuthAfterOtpModel {
  final String mobile;

  const AuthAfterOtpModel({required this.mobile});

  Map<String, dynamic> toJson() {
    return {'mobile': mobile};
  }
}
