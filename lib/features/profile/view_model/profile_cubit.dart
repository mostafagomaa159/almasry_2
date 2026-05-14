part of '../profile_imports.dart';


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
