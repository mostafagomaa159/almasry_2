import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/features/orders/view_model/order_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_imports.dart';
import '../order_details/view_model/order_details_args.dart';

part 'view/orders_view.dart';
part 'view_model/orders_cubit.dart';
part 'view_model/orders_state.dart';
part 'widgets/orders_card.dart';
part 'widgets/orders_header.dart';
part 'widgets/orders_item_row.dart';
part 'widgets/orders_status_badge.dart';
