class ActivateAccountRequest {
  final String customerId;
  final int isVerified;

  const ActivateAccountRequest({required this.customerId, this.isVerified = 1});

  Map<String, dynamic> toJson() {
    return {'customerId': customerId, 'is_verified': isVerified};
  }
}
