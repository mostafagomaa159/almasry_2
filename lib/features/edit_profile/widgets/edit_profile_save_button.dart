part of '../edit_profile_imports.dart';


class EditProfileSaveButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final VoidCallback onTap;

  const EditProfileSaveButton({
    super.key,
    required this.title,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 206.w,
      height: 49.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF0A0A),
          disabledBackgroundColor: const Color(0xFFFF0A0A),
          elevation: 4,
          shadowColor: Colors.black.withAlpha(30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
          width: 20.w,
          height: 20.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2.4,
            color: Colors.white,
          ),
        )
            : Text(
          title,
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
