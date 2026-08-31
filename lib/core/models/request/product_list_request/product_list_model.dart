import 'package:almasry_2/core/constants/app_api.dart';

class ProductListRequest {
  final String categoryId;
  final int page;
  final int pageSize;

  final bool isBrand;

  const ProductListRequest({
    required this.categoryId,
    required this.page,
    this.pageSize = 20,
    this.isBrand = false,
  });

  String get _filterField => isBrand ? 'brand' : 'category_id';

  String get endPoint =>
      '${ApiConstants.products}'
      '?searchCriteria[filter_groups][0][filters][0][field]=$_filterField'
      '&searchCriteria[filter_groups][0][filters][0][value]=$categoryId'
      '&searchCriteria[filter_groups][0][filters][0][condition_type]=eq'
      '&searchCriteria[filter_groups][1][filters][0][field]=status'
      '&searchCriteria[filter_groups][1][filters][0][value]=1'
      '&searchCriteria[filter_groups][1][filters][0][condition_type]=eq'
      '&searchCriteria[pageSize]=$pageSize'
      '&searchCriteria[currentPage]=$page';
}
