
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:almasry_2/features/profile/view_model/profile_state.dart';
import 'package:almasry_2/features/profile/view_model/profile_args.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    ProfileArgs? args,
  }) : super(
    ProfileState(
      isGuest: args?.isGuest == true,
      currentLanguageCode: args?.isGuest == true ? 'en' : 'en',
    ),
  );

  void initialize(BuildContext context) {
    emit(
      state.copyWith(
        currentLanguageCode: context.locale.languageCode,
      ),
    );
  }

  Future<void> changeLanguage(BuildContext context, String languageCode) async {
    if (state.currentLanguageCode == languageCode) return;

    await context.setLocale(Locale(languageCode));

    emit(
      state.copyWith(
        currentLanguageCode: languageCode,
      ),
    );
  }

  Future<void> toggleLanguage(BuildContext context) async {
    final String newLanguageCode =
    state.currentLanguageCode == 'ar' ? 'en' : 'ar';

    await changeLanguage(context, newLanguageCode);
  }
}
