part of '../checkout_flow_imports.dart';

class CheckoutFlowViewModel {
  final _checkoutFlowService = sl<CheckoutFlowService>();

  final PageController _pageController = PageController();

  GenericCubit<int> get _stepCubit => _checkoutFlowService.stepCubit;

  void _init() => _checkoutFlowService.attach(_pageController);

  void _dispose() {
    _checkoutFlowService.detach(_pageController);
    _pageController.dispose();
  }

  void _onPageChanged(int index) => _checkoutFlowService.syncStep(index);

  void _back() => _checkoutFlowService.previous();

  String _title(int step) {
    return step == CheckoutFlowService.cartStep
        ? LocaleKeys.cart.tr()
        : LocaleKeys.checkoutTitle.tr();
  }

  CheckoutStep _stepperStep(int step) => switch (step) {
    CheckoutFlowService.paymentStep => CheckoutStep.payment,
    CheckoutFlowService.reviewStep => CheckoutStep.review,
    _ => CheckoutStep.address,
  };
}
