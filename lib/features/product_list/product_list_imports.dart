library;

import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/models/request/product_list_request/product_list_model.dart';
import 'package:almasry_2/core/models/response/product_details/product_details_args_model.dart';
import 'package:almasry_2/core/models/response/product_list/product_model.dart';
import 'package:almasry_2/core/models/response/product_list/product_list_model.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/features/product_details/product_details_imports.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';


part 'view/product_list_view.dart';
part 'widgets/product_list_body.dart';
part 'widgets/product_list_item.dart';
part 'widgets/product_list_loading.dart';
part '../../core/models/response/product_list/product_list_view_model.dart';
part 'view_model/product_list_view_model.dart';