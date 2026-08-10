class ContactUsRequest {
  final String name;
  final String email;
  final String comment;
  final String telephone;

  const ContactUsRequest({
    required this.name,
    required this.email,
    required this.comment,
    required this.telephone,
  });

  Map<String, dynamic> toVariables() {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'comment': comment.trim(),
      'telephone': telephone.trim().isEmpty ? null : telephone.trim(),
    };
  }
}
