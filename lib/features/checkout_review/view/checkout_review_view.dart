part of '../checkout_review_imports.dart';

class CheckoutReviewView extends StatefulWidget {
  const CheckoutReviewView({super.key});

  @override
  State<CheckoutReviewView> createState() => _CheckoutReviewViewState();
}

class _CheckoutReviewViewState extends State<CheckoutReviewView> {
  final CheckoutReviewViewModel vm = CheckoutReviewViewModel();

  @override
  void initState() {
    super.initState();
    vm._init();
  }

  @override
  Widget build(BuildContext context) {
    return CheckoutReviewBody(vm: vm);
  }
}
