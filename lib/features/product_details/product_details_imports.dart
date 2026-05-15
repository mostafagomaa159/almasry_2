import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/features/product_details/view_model/product_details_args.dart';
import 'package:almasry_2/features/product_details/view_model/product_details_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/database/favorite_product_model.dart';
import '../auth/auth_imports.dart';
import '../favorites/cubit/favorites_cubit.dart';
import '../favorites/cubit/favorites_state.dart';



part 'view/product_details_view.dart';
part 'view_model/product_details_cubit.dart';
part 'widgets/product_details_bottom_action.dart';
part 'widgets/product_details_category_chip.dart';
part 'widgets/product_details_description_section.dart';
part 'widgets/product_details_header.dart';
part 'widgets/product_details_image_section.dart';
part 'widgets/product_details_rating_section.dart';