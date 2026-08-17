part of '../login_imports.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel vm = LoginViewModel();

  @override
  void initState() {
    super.initState();
    vm._init();
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const CustomAuthHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontalPadding.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LoginTabsSection(vm: vm),
                    LoginFormSection(vm: vm),
                    LoginActionsSection(vm: vm),
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
