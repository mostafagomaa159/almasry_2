import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/models/request/orders/orders_model.dart';
import 'package:almasry_2/core/models/response/order/order_model.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/features/my_order_details/my_order_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

part 'view/orders_view.dart';

part 'view_model/orders_view_model.dart';
part 'widgets/orders_empty_view.dart';
part 'widgets/orders_error_view.dart';
part 'widgets/orders_list_view.dart';
part 'widgets/orders_loading_view.dart';
part 'widgets/orders_app_bar.dart';
part 'widgets/orders_body.dart';
part 'widgets/orders_card.dart';