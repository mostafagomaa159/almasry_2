import 'dart:async';

import 'package:almasry_2/core/core_imports.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/response/home/home_brand_response.dart';
import 'package:almasry_2/core/models/response/home/home_sub_category_response.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/features/favorites/favorites_imports.dart';
import 'package:almasry_2/features/product_list/product_list_imports.dart';
import 'package:almasry_2/features/profile/view_model/profile_args.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/response/response_favorite_product.dart';
import '../product_details/view_model/product_details_args.dart';
import 'model/home_service_model.dart';
import 'package:almasry_2/core/constants/app_images.dart';

part 'view/home_view.dart';
part 'view_model/home_cubit.dart';
part 'view_model/home_state.dart';

part 'widgets/home_banner_slider.dart';
part 'widgets/home_bottom_nav_bar.dart';
part 'widgets/home_brand_strip.dart';
part 'widgets/home_categories_section.dart';
part 'widgets/home_concerns_section.dart';
part 'widgets/home_dynamic_block_section.dart';
part 'widgets/home_goals_section.dart';
part 'widgets/home_header.dart';
part 'widgets/home_offer_tabs.dart';
part 'widgets/home_offers_section.dart';
part 'widgets/home_product_card.dart';
part 'widgets/home_products_section.dart';
part 'widgets/home_quick_action_card.dart';
part 'widgets/home_search_bar.dart';
part 'widgets/home_section_header.dart';
part 'widgets/home_service_card.dart';
part 'widgets/home_services_section.dart';
part 'widgets/home_wide_info_card.dart';


