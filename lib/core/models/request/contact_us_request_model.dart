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

  /// `$telephone` is the only nullable variable in the mutation, so an empty
  /// field is sent as null rather than an empty string.
  Map<String, dynamic> toVariables() {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'comment': comment.trim(),
      'telephone': telephone.trim().isEmpty ? null : telephone.trim(),
    };
  }
}
