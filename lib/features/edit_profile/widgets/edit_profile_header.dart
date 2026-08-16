part of '../edit_profile_imports.dart';

class EditProfileHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const EditProfileHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 44.h,
          width: double.infinity,
          color: const Color(0xFFFF2D2D),
        ),
        Container(
          height: 72.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            border: Border.all(color: const Color(0xFFFF2D2D), width: 1.2),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28.r),
              bottomRight: Radius.circular(28.r),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              PositionedDirectional(
                start: 18.w,
                top: 16.h,
                child: Image.asset(
                  AppImages.profileLeft,
                  width: 74.w,
                  fit: BoxFit.contain,
                ),
              ),
              PositionedDirectional(
                top: -14.h,
                start: 0,
                end: 0,
                child: Center(
                  child: Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFFF2D2D),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: ClipOval(
                        child: Image.asset(
                          AppImages.profileDoctor,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                end: 18.w,
                top: 22.h,
                child: GestureDetector(
                  onTap: onBackTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocaleKeys.back.tr(),
                        style: TextStyle(
                          color: const Color(0xFF7A7A7A),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      6.horizontalSpace,
                      Icon(
                        AppDirection.back(),
                        size: 16.sp,
                        color: const Color(0xFF7A7A7A),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
