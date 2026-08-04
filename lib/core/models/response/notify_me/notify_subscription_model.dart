class NotifySubscriptionModel {
  final String sku;
  final String productName;
  final String imagePath;
  final String fcmToken;
  final int createdAt;

  const NotifySubscriptionModel({
    required this.sku,
    required this.productName,
    required this.imagePath,
    required this.fcmToken,
    required this.createdAt,
  });

  Map<String, Object?> toMap() {
    return {
      'sku': sku,
      'productName': productName,
      'imagePath': imagePath,
      'fcmToken': fcmToken,
      'createdAt': createdAt,
    };
  }

  factory NotifySubscriptionModel.fromMap(Map<String, Object?> map) {
    return NotifySubscriptionModel(
      sku: map['sku']?.toString() ?? '',
      productName: map['productName']?.toString() ?? '',
      imagePath: map['imagePath']?.toString() ?? '',
      fcmToken: map['fcmToken']?.toString() ?? '',
      createdAt: (map['createdAt'] as num?)?.toInt() ?? 0,
    );
  }
}
