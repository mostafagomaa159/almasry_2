library;

import 'dart:async';

import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/constants/app_graphql.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/response/checkout/address_model.dart';
import 'package:almasry_2/core/models/response/checkout/checkout_args_model.dart';
import 'package:almasry_2/core/models/response/checkout/region_model.dart';
import 'package:almasry_2/core/services/address_book_service.dart';
import 'package:almasry_2/core/services/alert_service.dart';
import 'package:almasry_2/core/services/cache_manager_service.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:almasry_2/core/services/navigation_service.dart';
import 'package:almasry_2/core/utils/error_message.dart';
import 'package:almasry_2/core/utils/validators.dart';
import 'package:almasry_2/core/widgets/app_button.dart';
import 'package:almasry_2/core/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'view/address_form_view.dart';
part 'view_model/address_form_view_model.dart';

part 'widgets/address_form_body.dart';
part 'widgets/address_form_field.dart';
part 'widgets/address_form_government_field.dart';
part 'widgets/address_form_location_picker.dart';
part 'widgets/address_form_phone_row.dart';
part '../../core/models/response/checkout/address_form_data_model.dart';
