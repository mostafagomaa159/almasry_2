part of '../profile_imports.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const ProfileHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFF2D2D),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              color: Colors.white,
              border: Border.all(color: const Color(0xFFFF2D2D), width: 1.2),
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(28.r),
                bottomEnd: Radius.circular(28.r),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                PositionedDirectional(
                  end: 18.w,
                  top: 12.h,
                  child: Image.asset(
                    AppLogo.asset(context),
                    width: 45.w,
                    fit: BoxFit.contain,
                  ),
                ),
                PositionedDirectional(
                  top: 4.h,
                  start: 0,
                  end: 0,
                  child: Center(
                    child: Container(
                      width: 62.w,
                      height: 62.w,
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
                  start: 18.w,
                  top: 22.h,
                  child: GestureDetector(
                    onTap: onBackTap,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          AppDirection.back(),
                          size: 16.sp,
                          color: const Color(0xFF7A7A7A),
                        ),
                        6.horizontalSpace,
                        Text(
                          LocaleKeys.back.tr(),
                          style: TextStyle(
                            color: const Color(0xFF7A7A7A),
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
