import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/features/profile/view_model/profile_args.dart';
import 'package:almasry_2/features/profile/view_model/profile_state.dart';
import 'package:almasry_2/features/profile/widgets/profile_menu_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/constants/app_colors.dart';
import '../auth/auth_imports.dart';
import '../edit_profile/view_model/edit_profile_args.dart';
import 'package:almasry_2/core/constants/app_images.dart';



part 'view/profile_view.dart';
part 'widgets/profile_account_view.dart';
part 'widgets/guest_action_card.dart';
part 'widgets/guest_profile_view.dart';
part 'widgets/profile_guest_header.dart';
part 'widgets/profile_header.dart';
part 'widgets/profile_info_card.dart';
part 'view_model/profile_cubit.dart';
