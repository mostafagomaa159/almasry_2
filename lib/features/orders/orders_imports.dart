import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_api.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/core_imports.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/response/order/order_response.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/features/orders/view_model/order_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:almasry_2/core/constants/app_images.dart';
import 'package:dio/dio.dart';

part 'view/orders_view.dart';
part 'view_model/orders_cubit.dart';
part 'view_model/orders_state.dart';
part 'widgets/order_card.dart';
part 'widgets/orders_header.dart';
part 'widgets/orders_item_row.dart';
part 'widgets/order_status_chip.dart';
part 'view/order_details_view.dart';

part 'view_model/order_details_cubit.dart';
part 'view_model/order_details_state.dart';

part 'widgets/order_item_tile.dart';
part 'widgets/order_summary_section.dart';
part 'widgets/order_address_section.dart';
part 'view_model/orders_args.dart';
