import 'package:almasry_2/core/constants/app_api.dart';

class OrdersRequest {
  final String email;
  final int pageSize;
  final int currentPage;

  const OrdersRequest({
    required this.email,
    this.pageSize = 20,
    this.currentPage = 1,
  });

  String get endPoint => ApiConstants.orders;

  Map<String, dynamic> get queryParameters => {
    'searchCriteria[filter_groups][0][filters][0][field]': 'customer_email',
    'searchCriteria[filter_groups][0][filters][0][value]': email,
    'searchCriteria[filter_groups][0][filters][0][condition_type]': 'eq',
    'searchCriteria[pageSize]': pageSize,
    'searchCriteria[currentPage]': currentPage,
    'searchCriteria[sortOrders][0][field]': 'created_at',
    'searchCriteria[sortOrders][0][direction]': 'DESC',
  };
}
