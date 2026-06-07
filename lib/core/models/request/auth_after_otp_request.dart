
class AuthAfterOtpRequest {
  final String mobile;

  const AuthAfterOtpRequest({
    required this.mobile,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
    };
  }
}
