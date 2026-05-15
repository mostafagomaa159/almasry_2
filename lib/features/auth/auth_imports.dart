import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/utils/app_logo.dart';
import 'package:almasry_2/features/auth/view_model/auth_state.dart';
import 'package:almasry_2/features/auth/widgets/login_toggle_tabs.dart';
import 'package:almasry_2/features/auth/widgets/login_remember_me_row.dart';
import 'package:flutter/material.dart';
import 'package:almasry_2/core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../profile/view_model/profile_args.dart';

part 'view/login_screen.dart';
part 'view/register_screen.dart';
part 'view_model/auth_cubit.dart';
part 'widgets/login_header.dart';
part 'widgets/login_language_switch.dart';
part 'widgets/login_phone_form.dart';
part 'widgets/login_regular_form.dart';
part 'widgets/register_form.dart';
part 'widgets/login_password_rules.dart';
part 'widgets/login_underline_field.dart';