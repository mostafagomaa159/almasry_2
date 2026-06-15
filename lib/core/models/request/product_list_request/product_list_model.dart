import 'package:almasry_2/core/constants/app_api.dart';

class ProductListRequest {
  final String categoryId;
  final int page;
  final int pageSize;

  const ProductListRequest({
    required this.categoryId,
    required this.page,
    this.pageSize = 20,
  });

  String get endPoint =>
      '${ApiConstants.products}'
          '?searchCriteria[filter_groups][0][filters][0][field]=category_id'
          '&searchCriteria[filter_groups][0][filters][0][value]=$categoryId'
          '&searchCriteria[filter_groups][0][filters][0][condition_type]=eq'
          '&searchCriteria[filter_groups][1][filters][0][field]=status'
          '&searchCriteria[filter_groups][1][filters][0][value]=1'
          '&searchCriteria[filter_groups][1][filters][0][condition_type]=eq'
          '&searchCriteria[pageSize]=$pageSize'
          '&searchCriteria[currentPage]=$page';
}
