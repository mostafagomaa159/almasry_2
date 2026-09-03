import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/constants/app_durations.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/response/cart/cart_item_model.dart';
import 'package:almasry_2/core/models/response/cart/cart_model.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/alert_service.dart';
import 'package:almasry_2/core/services/cart_service.dart';
import 'package:almasry_2/core/services/navigation_service.dart';
import 'package:almasry_2/core/utils/app_logo.dart';
import 'package:almasry_2/core/utils/price_format.dart';
import 'package:almasry_2/core/widgets/cart_totals_card.dart';
import 'package:almasry_2/core/widgets/custom_app_bar.dart';
import 'package:almasry_2/core/widgets/custom_app_network_image.dart';
import 'package:almasry_2/core/widgets/custom_app_refresh_indicator.dart';
import 'package:almasry_2/core/widgets/custom_app_shimmer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'view/cart_view.dart';

part 'view_model/cart_view_model.dart';

part 'widgets/cart_content.dart';
part 'widgets/cart_empty_view.dart';
part 'widgets/cart_item_tile.dart';
part 'widgets/cart_quantity_stepper.dart';
part 'widgets/cart_remove_background.dart';
part 'widgets/cart_shimmer.dart';
part 'widgets/cart_shimmer_row.dart';
part 'widgets/cart_stepper_button.dart';
part 'widgets/cart_summary.dart';
