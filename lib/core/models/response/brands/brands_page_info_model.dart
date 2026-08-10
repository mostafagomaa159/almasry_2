class BrandsPageInfoModel {
  final int pageSize;
  final int currentPage;
  final int totalPages;
  final int totalCount;

  const BrandsPageInfoModel({
    required this.pageSize,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory BrandsPageInfoModel.fromJson(Map<String, dynamic> json) {
    return BrandsPageInfoModel(
      pageSize: _toInt(json['page_size']),
      currentPage: _toInt(json['current_page']),
      totalPages: _toInt(json['total_pages']),
      totalCount: _toInt(json['total_count']),
    );
  }

  static const BrandsPageInfoModel empty = BrandsPageInfoModel(
    pageSize: 0,
    currentPage: 1,
    totalPages: 1,
    totalCount: 0,
  );

  static int _toInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
