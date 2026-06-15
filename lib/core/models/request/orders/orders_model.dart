import 'package:almasry_2/core/constants/app_api.dart';

class OrdersModel {
  final String email;
  final int pageSize;
  final int currentPage;

  const OrdersModel({
    required this.email,
    this.pageSize = 20,
    this.currentPage = 1,
  });

  String get endPoint => ApiConstants.orders;

  Map<String, dynamic> toJson() => {
    'searchCriteria[filter_groups][0][filters][0][field]': 'customer_email',
    'searchCriteria[filter_groups][0][filters][0][value]': email,
    'searchCriteria[filter_groups][0][filters][0][condition_type]': 'eq',
    'searchCriteria[pageSize]': pageSize,
    'searchCriteria[currentPage]': currentPage,
    'searchCriteria[sortOrders][0][field]': 'created_at',
    'searchCriteria[sortOrders][0][direction]': 'DESC',
  };
}
