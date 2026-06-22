part of '../../splash/splash_imports.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  SplashViewModel get viewModel => sl<SplashViewModel>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      viewModel.checkAppStart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    final String logoPath = isArabic ? AppImages.logoAr : AppImages.logoEn;

    return BlocListener<
        GenericCubit<SplashData>,
        GenericState<SplashData>>(
      bloc: viewModel.splashCubit,
      listener: (context, state) async {
        switch (state.data.status) {
          case StartupStatus.firstTime:
            await Future.delayed(const Duration(seconds: 3));
            await viewModel.completeFirstTime();
            if (!mounted) return;
            context.go(AppRoutes.login);
            break;

          case StartupStatus.authenticated:
            await Future.delayed(const Duration(seconds: 3));
            if (!mounted) return;
            context.go(AppRoutes.home);
            break;

          case StartupStatus.unauthenticated:
            await Future.delayed(const Duration(seconds: 3));
            if (!mounted) return;
            context.go(AppRoutes.login);
            break;

          case StartupStatus.initial:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    logoPath,
                    width: 220,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
