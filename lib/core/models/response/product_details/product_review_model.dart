/// One entry of `reviews.items`.
class ProductReviewModel {
  final String summary;
  final String text;
  final String nickname;
  final String createdAt;

  final double averageRating;

  final List<ProductRatingBreakdownModel> ratingsBreakdown;

  const ProductReviewModel({
    required this.summary,
    required this.text,
    required this.nickname,
    required this.createdAt,
    required this.averageRating,
    required this.ratingsBreakdown,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      summary: json['summary']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0,
      ratingsBreakdown:
          (json['ratings_breakdown'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .map(ProductRatingBreakdownModel.fromJson)
              .toList(),
    );
  }

  double get ratingOutOfFive => (averageRating / 20).clamp(0, 5).toDouble();
}

class ProductRatingBreakdownModel {
  final String name;
  final String value;

  const ProductRatingBreakdownModel({required this.name, required this.value});

  factory ProductRatingBreakdownModel.fromJson(Map<String, dynamic> json) {
    return ProductRatingBreakdownModel(
      name: json['name']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}

class ProductReviewsModel {
  final List<ProductReviewModel> items;
  final int currentPage;
  final int pageSize;
  final int totalPages;

  const ProductReviewsModel({
    this.items = const [],
    this.currentPage = 1,
    this.pageSize = 0,
    this.totalPages = 1,
  });

  factory ProductReviewsModel.fromJson(Map<String, dynamic>? json) {
    final Map<String, dynamic>? pageInfo =
        json?['page_info'] as Map<String, dynamic>?;

    return ProductReviewsModel(
      items: (json?['items'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProductReviewModel.fromJson)
          .toList(),
      currentPage: (pageInfo?['current_page'] as num?)?.toInt() ?? 1,
      pageSize: (pageInfo?['page_size'] as num?)?.toInt() ?? 0,
      totalPages: (pageInfo?['total_pages'] as num?)?.toInt() ?? 1,
    );
  }
}
