part of '../checkout_imports.dart';

class CheckoutPages extends StatelessWidget {
  final CheckoutViewModel vm;

  const CheckoutPages({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: vm._pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: vm._onPageChanged,
      children: <Widget>[
        CheckoutShippingPage(vm: vm),
        CheckoutPaymentPage(vm: vm),
        CheckoutReviewPage(vm: vm),
      ],
    );
  }
}
