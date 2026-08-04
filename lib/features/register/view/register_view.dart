part of '../register_imports.dart';

class RegisterCustomerView extends StatefulWidget {
  const RegisterCustomerView({super.key});

  @override
  State<RegisterCustomerView> createState() => _RegisterCustomerViewState();
}

class _RegisterCustomerViewState extends State<RegisterCustomerView> {
  final RegisterViewModel vm = RegisterViewModel();

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
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AuthHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontalPadding.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RegisterLanguageSwitch(vm: vm),
                    RegisterForm(vm: vm),
                    RegisterLoginLink(vm: vm),
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
