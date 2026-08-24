part of '../checkout_payment_imports.dart';

class CheckoutPaymentView extends StatefulWidget {
  const CheckoutPaymentView({super.key});

  @override
  State<CheckoutPaymentView> createState() => _CheckoutPaymentViewState();
}

class _CheckoutPaymentViewState extends State<CheckoutPaymentView> {
  final CheckoutPaymentViewModel vm = CheckoutPaymentViewModel();

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
      backgroundColor: AppColors.white,
      body: Column(
        children: <Widget>[
          CustomAppBar(title: LocaleKeys.checkoutTitle.tr(), onBack: vm._back),
          const CheckoutStepper(currentStep: CheckoutStep.payment),
          Expanded(child: CheckoutPaymentBody(vm: vm)),
        ],
      ),
    );
  }
}
