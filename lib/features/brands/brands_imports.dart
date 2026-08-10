import 'dart:async';

import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/constants/app_graphql.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/response/brands/brand_model.dart';
import 'package:almasry_2/core/models/response/brands/brands_page_info_model.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:almasry_2/core/services/navigation_service.dart';
import 'package:almasry_2/core/widgets/app_page_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part '../../core/models/response/brands/brands_data_model.dart';

part 'view/brands_view.dart';
part 'view_model/brands_view_model.dart';

part 'widgets/brands_body.dart';
part 'widgets/brands_error_view.dart';
part 'widgets/brands_grid.dart';
part 'widgets/brands_loading_view.dart';
part 'widgets/brands_search_field.dart';
part 'widgets/brand_grid_item.dart';
