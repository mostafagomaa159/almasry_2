import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_api.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/constants/app_images.dart';

import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/response/favorite/favorites_model.dart';
import 'package:almasry_2/core/models/response/product_details/product_details_args_model.dart';
import 'package:almasry_2/core/models/response/product_list/product_model.dart';
import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/features/wishlist/wishlist_imports.dart';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/response/favorite/favorite_product_model.dart';

part 'view/product_details_view.dart';
part 'view_model/product_details_view_model.dart';
part 'widgets/product_details_bottom_action.dart';

part 'widgets/product_details_description_section.dart';
part 'widgets/product_details_header.dart';
part 'widgets/product_details_image_section.dart';
part 'widgets/product_details_rating_section.dart';
part 'widgets/product_details_summary_section.dart';
part 'widgets/product_details_info_section.dart';
part '../../core/models/response/product_details/product_details_model.dart';