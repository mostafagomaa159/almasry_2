import 'dart:async';

import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_api.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/response/favorite/favorites_model.dart';
import 'package:almasry_2/core/models/response/home/home_brand_model.dart';
import 'package:almasry_2/core/models/response/home/home_cms_model.dart';
import 'package:almasry_2/core/models/response/home/home_mobile_block_model.dart';
import 'package:almasry_2/core/models/response/home/home_slider_item_model.dart';
import 'package:almasry_2/core/models/response/home/home_sub_category_model.dart';
import 'package:almasry_2/core/models/response/product_details/product_details_args_model.dart';
import 'package:almasry_2/core/models/response/product_list/product_list_args_model.dart';
import 'package:almasry_2/core/models/response/product_list/product_model.dart';
import 'package:almasry_2/core/models/response/profile/profile_args_model.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/core/utils/app_logo.dart';
import 'package:almasry_2/features/product_details/product_details_imports.dart';
import 'package:almasry_2/features/product_list/product_list_imports.dart';
import 'package:almasry_2/features/profile/profile_imports.dart';
import 'package:almasry_2/features/wishlist/wishlist_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/response/favorite/favorite_product_model.dart';
import 'package:almasry_2/core/constants/app_images.dart';

part 'view/home_view.dart';
part 'view_model/home_view_model.dart';

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
part 'widgets/home_wide_info_card.dart';
part '../../core/models/response/home/home_model.dart';

