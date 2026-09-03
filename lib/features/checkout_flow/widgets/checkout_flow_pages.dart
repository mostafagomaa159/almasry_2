part of '../checkout_flow_imports.dart';

class CheckoutFlowPages extends StatelessWidget {
  final CheckoutFlowViewModel vm;

  const CheckoutFlowPages({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: vm._pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: vm._onPageChanged,
      children: const <Widget>[
        CartView(),
        CheckoutShippingView(),
        CheckoutPaymentView(),
        CheckoutReviewView(),
      ],
    );
  }
}
