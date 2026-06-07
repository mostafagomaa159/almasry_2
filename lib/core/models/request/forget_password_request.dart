
class ForgetPasswordRequest {

  final String identity;

  ForgetPasswordRequest({
    required this.identity,
  });

  Map<String, dynamic> toJson() {
    return {
      'identity': identity,
    };
  }
}
