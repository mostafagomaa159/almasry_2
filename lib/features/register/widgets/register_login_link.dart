part of '../register_imports.dart';

class RegisterLoginLink extends StatelessWidget {
  final RegisterViewModel vm;

  const RegisterLoginLink({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        28.verticalSpace,
        Center(
          child: GestureDetector(
            onTap: () => vm._goToLogin(context),
            child: Text(
              LocaleKeys.login.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.darkBlue,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.darkBlue,
              ),
            ),
          ),
        ),
        30.verticalSpace,
      ],
    );
  }
}
