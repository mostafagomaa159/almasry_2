import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/constants/app_contact.dart';
import 'package:almasry_2/core/constants/app_graphql.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/request/contact_us_request.dart';
import 'package:almasry_2/core/services/alert_service.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:almasry_2/core/services/navigation_service.dart';
import 'package:almasry_2/core/utils/validators.dart';
import 'package:almasry_2/core/widgets/custom_app_button.dart';
import 'package:almasry_2/core/widgets/custom_app_bar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almasry_2/core/widgets/custom_app_text_field.dart';
import 'package:almasry_2/core/constants/app_durations.dart';

part '../../core/models/response/contact_us/contact_us_data_model.dart';

part 'view/contact_us_view.dart';
part 'view_model/contact_us_view_model.dart';

part 'widgets/contact_us_body.dart';
part 'widgets/contact_us_form.dart';
part 'widgets/contact_us_numbers_section.dart';
