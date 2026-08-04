part of '../splash_imports.dart';

class SplashLogo extends StatelessWidget {
  final SplashViewModel vm;

  const SplashLogo({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: vm._fadeAnimation,
            child: SlideTransition(
              position: vm._slideAnimation,
              child: ScaleTransition(
                scale: vm._scaleAnimation,
                child: Image.asset(
                  vm._logoPath(context),
                  width: 220,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
