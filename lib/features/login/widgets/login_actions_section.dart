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

        return BlocBuilder<GenericCubit<UserModel>, GenericState<UserModel>>(
          bloc: vm._authCubit,
          builder: (context, state) {
            final UserModel data = state.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppButton(
                  title: isRegularLoginSelected
                      ? LocaleKeys.signIn.tr()
                      : LocaleKeys.sendVerificationCode.tr(),
                  onPressed: isRegularLoginSelected
                      ? () => vm._submitRegularLogin(context)
                      : () => vm._submitPhoneLogin(context),
                  isLoading: isRegularLoginSelected
                      ? data.isLoading
                      : data.isPhoneAuthLoading,
                ),
                SizedBox(height: 16.h),
                AppButton(
                  title: LocaleKeys.createAccount.tr(),
                  onPressed: vm._goToRegisterScreen,
                  isPrimary: false,
                ),
                SizedBox(height: 30.h),
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
                SizedBox(height: 24.h),
              ],
            );
          },
        );
      },
    );
  }
}
