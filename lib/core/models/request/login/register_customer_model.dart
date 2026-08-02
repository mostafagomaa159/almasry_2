class RegisterCustomerModel {
  final String mobile;
  final String password;

  const RegisterCustomerModel({required this.mobile, required this.password});

  Map<String, dynamic> toJson() {
    return {'mobile': mobile, 'password': password};
  }
}
