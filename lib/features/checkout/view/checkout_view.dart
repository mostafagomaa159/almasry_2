part of '../checkout_imports.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  late final CheckoutViewModel vm = CheckoutViewModel(onProceed: _forward);

  late final Widget _pages = PageView(
    controller: vm._pageController,
    physics: const NeverScrollableScrollPhysics(),
    onPageChanged: _onPageChanged,
    children: <Widget>[
      CheckoutShippingPage(vm: vm),
      CheckoutPaymentPage(vm: vm),
      CheckoutReviewPage(vm: vm),
    ],
  );

  CheckoutStep _step = CheckoutStep.address;

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

  void _onPageChanged(int index) {
    final CheckoutStep step = CheckoutStep.values[index];

    if (step == _step) return;

    setState(() => _step = step);
  }

  void _forward() => _goTo(_step.index + 1);

  void _back() {
    if (_step == CheckoutStep.address) return vm._exitCheckout();

    _goTo(_step.index - 1);
  }

  void _goTo(int index) {
    if (index < 0 || index >= CheckoutStep.values.length) return;

    final CheckoutStep step = CheckoutStep.values[index];

    setState(() => _step = step);

    vm._goToStep(step);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == CheckoutStep.address,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;

        _back();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: <Widget>[
            CustomAppBar(title: LocaleKeys.checkoutTitle.tr(), onBack: _back),

            CheckoutStepper(currentStep: _step),

            Expanded(child: _pages),
          ],
        ),
      ),
    );
  }
}
