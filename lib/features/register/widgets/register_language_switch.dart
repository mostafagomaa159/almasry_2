part of '../register_imports.dart';

class RegisterLanguageSwitch extends StatelessWidget {
  final RegisterViewModel vm;

  const RegisterLanguageSwitch({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: () => vm._toggleLanguage(context),
            child: Text(
              isArabic ? 'EN' : 'AR',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        8.verticalSpace,
      ],
    );
  }
}
