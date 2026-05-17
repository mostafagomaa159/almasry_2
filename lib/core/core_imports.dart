import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/favorites_db_helper.dart';
import 'package:almasry_2/features/auth/auth_imports.dart';
import 'package:almasry_2/features/edit_profile/edit_profile_imports.dart';
import 'package:almasry_2/features/edit_profile/view_model/edit_profile_args.dart';
import 'package:almasry_2/features/home/home_imports.dart';
import 'package:almasry_2/features/order_details/order_details_imports.dart';
import 'package:almasry_2/features/order_details/view_model/order_details_args.dart';
import 'package:almasry_2/features/orders/orders_imports.dart';
import 'package:almasry_2/features/product_details/product_details_imports.dart';
import 'package:almasry_2/features/product_details/view_model/product_details_args.dart';
import 'package:almasry_2/features/profile/profile_imports.dart';
import 'package:almasry_2/features/profile/view_model/profile_args.dart';
import 'package:almasry_2/features/splash/splash_imports.dart';
import 'package:almasry_2/features/wishlist/wishlist_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/app_sizes.dart';
import 'services/favorite_product_model.dart';

part 'constants/app_colors.dart';
part 'services/favorites_repository.dart';
part 'services/shared_prefs_helper.dart';
part 'localization/app_locale.dart';
part 'routing/app_router.dart';
part 'utils/app_logo.dart';
part 'utils/focus_helper.dart';
part 'utils/validators.dart';
part 'widgets/app_button.dart';
part 'widgets/app_text_field.dart';


