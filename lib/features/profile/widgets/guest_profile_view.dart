part of '../profile_imports.dart';


class GuestProfileView extends StatefulWidget {
  final ProfileArgs? args;

  const GuestProfileView({
    super.key,
    this.args,
  });

  @override
  State<GuestProfileView> createState() => _GuestProfileViewState();
}

class _GuestProfileViewState extends State<GuestProfileView> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version;
      // If you want version + build number:
      // appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const ProfileGuestHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/startwithpharmacy.png',
                      width: double.infinity,
                      height: 250.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      LocaleKeys.guestStartWithPharmacy.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0A3152),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          context.go(AppRoutes.login);
                        },
                        child: Text(
                          LocaleKeys.start.tr(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 56.h),
                    Row(
                      children: [
                        Expanded(
                          child: GuestActionCard(
                            icon: Icons.translate,
                            title: LocaleKeys.changeLanguage.tr(),
                            onTap: () {
                              profileCubit.toggleLanguage(context);
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: GuestActionCard(
                            icon: Icons.favorite,
                            title: LocaleKeys.wishlist.tr(),
                            onTap: () {context.push(AppRoutes.wishlist);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      '${LocaleKeys.appVersion.tr()} ${appVersion.isEmpty ? '...' : appVersion}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF8D8D8D),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            isSelected: false,
          ),
          _BottomNavItem(
            icon: Icons.search,
            label: 'Categories',
            isSelected: false,
          ),
          _BottomNavItem(
            icon: Icons.local_offer_outlined,
            label: 'Offers',
            isSelected: false,
          ),
          _BottomNavItem(
            icon: Icons.shopping_cart_outlined,
            label: 'Cart',
            isSelected: false,
          ),
          _BottomNavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            isSelected: true,
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected
        ? AppColors.primaryRed
        : const Color(0xFFB3B3B3);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 27.sp),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: color,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
