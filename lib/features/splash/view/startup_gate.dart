part of '../splash_imports.dart';

class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<StartupCubit>().checkAppStart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartupCubit, StartupState>(
      listener: (context, state) {
        switch (state.status) {
          case StartupStatus.firstTime:
            context.go(AppRoutes.splash);
            break;
          case StartupStatus.authenticated:
            context.go(AppRoutes.home);
            break;
          case StartupStatus.unauthenticated:
            context.go(AppRoutes.login);
            break;
          case StartupStatus.initial:
            break;
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
