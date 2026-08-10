part of '../home_imports.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 105.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28.r),
                bottomRight: Radius.circular(28.r),
              ),
              border: Border.all(color: AppColors.primaryRed, width: 1.2),
            ),
            child: SafeArea(
              bottom: false,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      AppLogo.asset(context),
                      width: 135.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  PositionedDirectional(
                    start: 4.w,
                    top: 18.h,
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Icon(
                            Icons.menu,
                            size: 28.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          PositionedDirectional(
            end: 2.w,
            bottom: 0,
            child: Container(
              width: 74.w,
              height: 74.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.primaryRed.withValues(alpha: 0.7),
                  width: 1.2,
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
        ],
      ),
    );
  }
}
