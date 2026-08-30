part of '../../home/home_imports.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const Color _dividerColor = AppColors.borderSoft;
  static const Color _skinAnalysisBgColor = AppColors.redTintCard;
  static const Color _socialIconColor = AppColors.textMuted;

  NavigationService _nav() => sl<NavigationService>();

  void _close(BuildContext context) {
    Scaffold.of(context).closeDrawer();
  }

  void _openBrands(BuildContext context) {
    _close(context);
    _nav().pushNamed(RouteNames.brands);
  }

  void _openContactUs(BuildContext context) {
    _close(context);
    _nav().pushNamed(RouteNames.contactUs);
  }

  void _openComingSoon(BuildContext context, String title) {
    _close(context);
    _nav().pushNamed(RouteNames.homeComingSoon, extra: title);
  }

  void _openSocialLink(String url) {
    // TODO: open [url] once url_launcher is added to pubspec.yaml.
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      width: MediaQuery.of(context).size.width * 0.78,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeaderRow(onClose: () => _close(context)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _DrawerHighlightCard(
                title: LocaleKeys.homeSkinAnalysis.tr(),
                iconPath: AppImages.mask,
                backgroundColor: _skinAnalysisBgColor,
                onTap: () =>
                    _openComingSoon(context, LocaleKeys.homeSkinAnalysis.tr()),
              ),
            ),

            32.verticalSpace,

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _DrawerMenuItem(
                      title: LocaleKeys.drawerShopByBrands.tr(),
                      onTap: () => _openBrands(context),
                    ),
                    _DrawerMenuItem(
                      title: LocaleKeys.drawerContactUs.tr(),
                      onTap: () => _openContactUs(context),
                    ),
                  ],
                ),
              ),
            ),

            _DrawerSocialRow(onTap: _openSocialLink),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeaderRow extends StatelessWidget {
  final VoidCallback onClose;

  const _DrawerHeaderRow({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      /// Directional, not LTRB: the title sits on the start edge and the close
      /// button on the end, so the wide padding has to follow them when the
      /// locale flips.
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 24.h, 12.w, 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.drawerMenu.tr(),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBlue,
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close, size: 26.sp, color: AppColors.darkBlue),
          ),
        ],
      ),
    );
  }
}

class _DrawerHighlightCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _DrawerHighlightCard({
    required this.title,
    required this.iconPath,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 22.h),
          child: Row(
            children: [
              Image.asset(iconPath, width: 34.w, height: 34.w),
              14.horizontalSpace,
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DrawerMenuItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 1,
          thickness: 1,
          indent: 20.w,
          endIndent: 20.w,
          color: AppDrawer._dividerColor,
        ),
        Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    AppDirection.chevronForward,
                    size: 24.sp,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DrawerSocialRow extends StatelessWidget {
  final void Function(String url) onTap;

  const _DrawerSocialRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TODO: swap for the real brand icons under assets/icons.
          _SocialIcon(
            icon: Icons.camera_alt_outlined,
            onTap: () => onTap(AppSocialLinks.instagram),
          ),
          _SocialIcon(
            icon: Icons.facebook,
            onTap: () => onTap(AppSocialLinks.facebook),
          ),
          _SocialIcon(
            icon: Icons.chat_bubble_outline,
            onTap: () => onTap(AppSocialLinks.whatsapp),
          ),
          _SocialIcon(
            icon: Icons.send,
            onTap: () => onTap(AppSocialLinks.telegram),
          ),
          _SocialIcon(
            icon: Icons.mail_outline,
            onTap: () => onTap(AppSocialLinks.email),
          ),
          _SocialIcon(
            icon: Icons.music_note,
            onTap: () => onTap(AppSocialLinks.tiktok),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Icon(icon, size: 24.sp, color: AppDrawer._socialIconColor),
      ),
    );
  }
}
