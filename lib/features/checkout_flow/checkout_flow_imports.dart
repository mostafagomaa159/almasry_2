import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/services/checkout_flow_service.dart';
import 'package:almasry_2/core/widgets/checkout_stepper.dart';
import 'package:almasry_2/core/widgets/custom_app_bar.dart';
import 'package:almasry_2/features/cart/cart_imports.dart';
import 'package:almasry_2/features/checkout_payment/checkout_payment_imports.dart';
import 'package:almasry_2/features/checkout_review/checkout_review_imports.dart';
import 'package:almasry_2/features/checkout_shipping/checkout_shipping_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'view/checkout_flow_view.dart';
part 'view_model/checkout_flow_view_model.dart';

part 'widgets/checkout_flow_pages.dart';
