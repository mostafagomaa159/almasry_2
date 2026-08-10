import 'dart:async';

import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/constants/app_graphql.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/request/brands/brands_request.dart';
import 'package:almasry_2/core/models/response/brands/brand_model.dart';
import 'package:almasry_2/core/models/response/brands/get_brands_response.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:almasry_2/core/services/navigation_service.dart';
import 'package:almasry_2/core/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almasry_2/core/widgets/app_error_view.dart';
import 'package:almasry_2/core/widgets/app_empty_view.dart';
import 'package:almasry_2/core/widgets/app_loading_view.dart';
import 'package:almasry_2/core/widgets/app_search_field.dart';
import 'package:almasry_2/core/widgets/app_network_image.dart';
import 'package:almasry_2/core/utils/error_message.dart';

part 'view/brands_view.dart';
part 'view_model/brands_view_model.dart';

part 'widgets/brands_body.dart';
part 'widgets/brands_grid.dart';
part 'widgets/brands_search_field.dart';
part 'widgets/brand_grid_item.dart';
