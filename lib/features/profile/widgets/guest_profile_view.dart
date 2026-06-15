part of '../profile_imports.dart';

class GuestProfileView extends StatefulWidget {
  final ProfileArgs? args;
  final ProfileViewModel viewModel;

  const GuestProfileView({
    super.key,
    this.args,
    required this.viewModel,
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

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
                      AppImages.startWithPharmacy,
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
                              viewModel.toggleLanguage(context);
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: GuestActionCard(
                            icon: Icons.favorite,
                            title: LocaleKeys.wishlist.tr(),
                            onTap: () {
                              context.push(AppRoutes.wishlist);
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
