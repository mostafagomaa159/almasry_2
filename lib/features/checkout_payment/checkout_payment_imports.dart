library;

import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/constants/app_graphql.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/request/checkout/checkout_method_request.dart';
import 'package:almasry_2/core/models/response/cart/cart_data_model.dart';
import 'package:almasry_2/core/models/response/cart/cart_model.dart';
import 'package:almasry_2/core/models/response/checkout/payment_method_model.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/alert_service.dart';
import 'package:almasry_2/core/services/cart_service.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:almasry_2/core/services/navigation_service.dart';
import 'package:almasry_2/core/utils/error_message.dart';
import 'package:almasry_2/core/widgets/custom_app_empty_view.dart';
import 'package:almasry_2/core/widgets/custom_app_error_view.dart';
import 'package:almasry_2/core/widgets/custom_app_loading_view.dart';
import 'package:almasry_2/core/widgets/custom_app_network_image.dart';
import 'package:almasry_2/core/widgets/cart_totals_card.dart';
import 'package:almasry_2/core/widgets/checkout_stepper.dart';
import 'package:almasry_2/core/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'view/checkout_payment_view.dart';
part 'view_model/checkout_payment_view_model.dart';

part 'widgets/checkout_payment_body.dart';
part 'widgets/checkout_payment_method_card.dart';
part 'widgets/checkout_payment_summary.dart';
part '../../core/models/response/checkout/checkout_payment_data_model.dart';
