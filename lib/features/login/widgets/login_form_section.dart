part of '../login_imports.dart';

class LoginFormSection extends StatelessWidget {
  final LoginViewModel vm;

  const LoginFormSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._isRegularLoginCubit,
      builder: (context, tabState) {
        final bool isRegularLoginSelected = tabState.data;

        return BlocBuilder<GenericCubit<UserModel>, GenericState<UserModel>>(
          bloc: vm._authCubit,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isRegularLoginSelected)
                  RegularLoginForm(vm: vm)
                else
                  PhoneLoginForm(vm: vm),
                18.verticalSpace,
                if (isRegularLoginSelected)
                  Center(
                    child: Text(
                      LocaleKeys.forgotPassword.tr(),
                      style: TextStyle(
                        color: const Color(0xFF9E9E9E),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                28.verticalSpace,
              ],
            );
          },
        );
      },
    );
  }
}
