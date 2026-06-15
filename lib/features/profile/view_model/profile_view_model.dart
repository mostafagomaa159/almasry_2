part of '../profile_imports.dart';

class ProfileViewModel {
  final GenericCubit<ProfileData> profileCubit;

  ProfileViewModel({ProfileArgs? args})
      : profileCubit = GenericCubit<ProfileData>(
    ProfileData(
      isGuest: args?.isGuest == true,
      currentLanguageCode: 'en',
    ),
  );

  void initialize(BuildContext context) {
    profileCubit.onUpdateData(
      profileCubit.state.data.copyWith(
        currentLanguageCode: context.locale.languageCode,
      ),
    );
  }

  Future<void> changeLanguage(
      BuildContext context,
      String languageCode,
      ) async {
    if (profileCubit.state.data.currentLanguageCode == languageCode) return;

    await context.setLocale(Locale(languageCode));

    profileCubit.onUpdateData(
      profileCubit.state.data.copyWith(
        currentLanguageCode: languageCode,
      ),
    );
  }

  Future<void> toggleLanguage(BuildContext context) async {
    final String newLanguageCode =
    profileCubit.state.data.currentLanguageCode == 'ar' ? 'en' : 'ar';

    await changeLanguage(context, newLanguageCode);
  }

  void dispose() {
    profileCubit.close();
  }
}
