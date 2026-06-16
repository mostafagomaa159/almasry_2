import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_api.dart';
import 'package:almasry_2/core/models/response/categorie/category_model.dart';
import 'package:almasry_2/core/models/response/categorie/category_response_model.dart';
import 'package:almasry_2/core/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'view_model/categories_view_model.dart';
part 'view/categories_view.dart';
part 'widgets/categories_children_section.dart';
part 'widgets/categories_error_view.dart';
part 'widgets/categories_loading_view.dart';
part 'widgets/categories_sidebar.dart';
part 'widgets/category_grid_item.dart';