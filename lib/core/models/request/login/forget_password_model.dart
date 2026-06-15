
class ForgetPasswordModel {

  final String identity;

  ForgetPasswordModel({
    required this.identity,
  });

  Map<String, dynamic> toJson() {
    return {
      'identity': identity,
    };
  }
}
