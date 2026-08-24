library;

import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/response/checkout/checkout_args_model.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/navigation_service.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:almasry_2/core/utils/price_format.dart';
import 'package:almasry_2/core/widgets/app_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'view/order_confirmed_view.dart';
part 'view_model/order_confirmed_view_model.dart';

part 'widgets/order_confirmed_body.dart';
part 'widgets/order_confirmed_card.dart';
part 'widgets/order_confirmed_illustration.dart';
