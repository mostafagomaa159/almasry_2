part of '../splash_imports.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  final SplashViewModel vm = SplashViewModel();

  @override
  void initState() {
    super.initState();
    vm._init(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      vm._checkAppStart(() => mounted);
    });
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashLogo(vm: vm);
  }
}
