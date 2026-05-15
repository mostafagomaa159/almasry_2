import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/database/favorite_product_model.dart';
import '../auth/auth_imports.dart';
import '../favorites/cubit/favorites_cubit.dart';
import '../favorites/cubit/favorites_state.dart';
import '../product_details/view_model/product_details_args.dart';

part 'view/wishlist_view.dart';
part 'widgets/wishlist_empty_view.dart';
part 'widgets/wishlist_item_card.dart';