import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginLanguageSwitch extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onTap;

  const LoginLanguageSwitch({
    super.key,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton(
        onPressed: onTap,
        child: Text(
          isArabic ? 'EN' : 'AR',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
