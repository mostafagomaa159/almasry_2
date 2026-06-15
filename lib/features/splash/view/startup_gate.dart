part of '../splash_imports.dart';

class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  StartupViewModel get viewModel => sl<StartupViewModel>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      viewModel.checkAppStart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
        GenericCubit<StartupData>,
        GenericState<StartupData>>(
      bloc: viewModel.startupCubit,
      listener: (context, state) {
        switch (state.data.status) {
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
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
