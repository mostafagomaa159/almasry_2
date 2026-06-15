import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/models/response/favorite/favorites_model.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/favorites_repository.dart';
import 'package:almasry_2/features/product_details/product_details_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:almasry_2/core/models/response/favorite/favorite_product_model.dart';

part 'view/wishlist_view.dart';
part 'widgets/wishlist_empty_view.dart';
part 'widgets/wishlist_item_card.dart';
part 'view_model/favorites_view_model.dart';
