
class RegisterCustomerRequest {
  final String mobile;
  final String password;

  const RegisterCustomerRequest({
    required this.mobile,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'password': password,
    };
  }
}
