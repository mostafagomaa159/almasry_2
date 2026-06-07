library;

import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_api.dart';
import 'package:almasry_2/core/models/response/home/product_response.dart';
import 'package:almasry_2/core/services/api_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:equatable/equatable.dart';

import '../../../core/core_imports.dart';

part 'view/product_list_view.dart';
part 'view_model/product_list_cubit.dart';
part 'view_model/product_list_state.dart';
part 'widgets/product_list_body.dart';
part 'widgets/product_list_item.dart';
part 'widgets/product_list_loading.dart';
part 'view_model/product_list_args.dart';
