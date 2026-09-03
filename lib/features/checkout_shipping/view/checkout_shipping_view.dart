part of '../checkout_shipping_imports.dart';

class CheckoutShippingView extends StatefulWidget {
  const CheckoutShippingView({super.key});

  @override
  State<CheckoutShippingView> createState() => _CheckoutShippingViewState();
}

class _CheckoutShippingViewState extends State<CheckoutShippingView> {
  final CheckoutShippingViewModel vm = CheckoutShippingViewModel();

  @override
  void initState() {
    super.initState();
    vm._init();
  }

  @override
  Widget build(BuildContext context) {
    return CheckoutShippingBody(vm: vm);
  }
}
