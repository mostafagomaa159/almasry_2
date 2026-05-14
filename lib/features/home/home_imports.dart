import 'dart:async';

import 'package:almasry_2/features/home/view_model/home_state.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/database/favorite_product_model.dart';
import '../../core/utils/app_logo.dart';
import '../auth/auth.dart';
import '../favorites/cubit/favorites_cubit.dart';
import '../favorites/cubit/favorites_state.dart';
import '../product_details/view_model/product_details_args.dart';
import 'model/home_concern_model.dart';
import 'model/home_goal_model.dart';
import 'model/home_service_model.dart';

part 'view/home_view.dart';
part 'view_model/home_cubit.dart';
part 'widgets/home_banner_slider.dart';
part 'widgets/home_bottom_nav_bar.dart';
part 'widgets/home_brand_strip.dart';
part 'widgets/home_concerns_section.dart';
part 'widgets/home_goals_section.dart';
part 'widgets/home_header.dart';
part 'widgets/home_offer_tabs.dart';
part 'widgets/home_product_card.dart';
part 'widgets/home_products_section.dart';
part 'widgets/home_search_bar.dart';
part 'widgets/home_section_header.dart';
part 'widgets/home_service_card.dart';
part 'widgets/home_services_section.dart';
part 'widgets/home_wide_info_card.dart';
part 'data/home_mock_data.dart';