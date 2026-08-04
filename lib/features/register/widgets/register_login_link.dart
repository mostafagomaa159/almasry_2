part of '../register_imports.dart';

class RegisterLoginLink extends StatelessWidget {
  final RegisterViewModel vm;

  const RegisterLoginLink({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 28.h),
        Center(
          child: GestureDetector(
            onTap: () => vm._goToLogin(context),
            child: Text(
              LocaleKeys.login.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF173B63),
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF173B63),
              ),
            ),
          ),
        ),
        SizedBox(height: 30.h),
      ],
    );
  }
}
