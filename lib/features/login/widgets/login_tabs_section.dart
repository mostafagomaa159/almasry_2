part of '../login_imports.dart';

class LoginTabsSection extends StatelessWidget {
  final LoginViewModel vm;

  const LoginTabsSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._isRegularLoginCubit,
      builder: (context, state) {
        final bool isRegularLoginSelected = state.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: AuthToggleTabs(
                startTitle: LocaleKeys.login.tr(),
                endTitle: LocaleKeys.loginWithPhone.tr(),
                isStartSelected: isRegularLoginSelected,
                onStartTap: () => vm._onTabChanged(context, true),
                onEndTap: () => vm._onTabChanged(context, false),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        );
      },
    );
  }
}
