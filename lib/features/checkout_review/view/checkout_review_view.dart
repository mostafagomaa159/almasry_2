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
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: <Widget>[
          CustomAppBar(title: LocaleKeys.checkoutTitle.tr(), onBack: vm._back),
          const CheckoutStepper(currentStep: CheckoutStep.review),
          Expanded(child: CheckoutReviewBody(vm: vm)),
        ],
      ),
    );
  }
}
