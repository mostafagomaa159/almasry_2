part of '../login_imports.dart';

class LoginActionsSection extends StatelessWidget {
  final LoginViewModel vm;

  const LoginActionsSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._isRegularLoginCubit,
      builder: (context, tabState) {
        final bool isRegularLoginSelected = tabState.data;

        return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
          bloc: isRegularLoginSelected
              ? vm._loadingCubit
              : vm._phoneAuthLoadingCubit,
          builder: (context, loadingState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomAppButton(
                  title: isRegularLoginSelected
                      ? LocaleKeys.signIn.tr()
                      : LocaleKeys.sendVerificationCode.tr(),
                  onPressed: isRegularLoginSelected
                      ? () => vm._submitRegularLogin(context)
                      : () => vm._submitPhoneLogin(context),
                  isLoading: loadingState.data,
                ),
                16.verticalSpace,
                CustomAppButton(
                  title: LocaleKeys.createAccount.tr(),
                  onPressed: vm._goToRegisterScreen,
                  isPrimary: false,
                ),
                30.verticalSpace,
                Center(
                  child: GestureDetector(
                    onTap: () => vm._continueAsGuest(context),
                    child: Text(
                      LocaleKeys.continueAsGuest.tr(),
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                24.verticalSpace,
              ],
            );
          },
        );
      },
    );
  }
}
