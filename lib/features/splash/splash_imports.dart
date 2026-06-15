import 'dart:async';
import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/services/pref_keys.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/shared_prefs_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:almasry_2/core/constants/app_images.dart';

part 'view/splash_view.dart';
part 'view_model/startup_view_model.dart';
part 'view/startup_gate.dart';
part '../../core/models/response/splash/startup_model.dart';
