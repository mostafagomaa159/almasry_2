part of '../splash_imports.dart';

class SplashViewModel {
  /// Services

  final AppStartupService _startup = sl<AppStartupService>();
  final NavigationService _nav = sl<NavigationService>();

  /// Variables

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  /// Init

  void _init(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  void _dispose() {
    _controller.dispose();
  }

  /// Actions

  Future<void> _checkAppStart(bool Function() isMounted) async {
    final StartupStatus status = await _startup.checkAppStart();

    await _onStatusChanged(status, isMounted);
  }

  Future<void> _onStatusChanged(
    StartupStatus status,
    bool Function() isMounted,
  ) async {
    switch (status) {
      case StartupStatus.firstTime:
        await Future.delayed(const Duration(seconds: 3));
        await _startup.completeFirstTime();
        if (!isMounted()) return;
        _nav.goNamed(RouteNames.login);
        break;

      case StartupStatus.authenticated:
        await Future.delayed(const Duration(seconds: 3));
        if (!isMounted()) return;
        _nav.goNamed(RouteNames.home);
        break;

      case StartupStatus.unauthenticated:
        await Future.delayed(const Duration(seconds: 3));
        if (!isMounted()) return;
        _nav.goNamed(RouteNames.login);
        break;

      case StartupStatus.initial:
        break;
    }
  }

  String _logoPath(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    return isArabic ? AppImages.logoAr : AppImages.logoEn;
  }
}
