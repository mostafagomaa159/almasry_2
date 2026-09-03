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
  Widget build(BuildContext context) {
    return CheckoutPaymentBody(vm: vm);
  }
}
