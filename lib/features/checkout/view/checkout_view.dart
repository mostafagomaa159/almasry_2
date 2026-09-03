part of '../checkout_imports.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final CheckoutViewModel vm = CheckoutViewModel();

  late final Widget _pages = CheckoutPages(vm: vm);

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
    return BlocBuilder<GenericCubit<CheckoutStep>, GenericState<CheckoutStep>>(
      bloc: vm._stepCubit,
      builder: (context, state) {
        final CheckoutStep step = state.data;

        return PopScope(
          canPop: step == CheckoutStep.address,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (didPop) return;

            vm._back();
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Column(
              children: <Widget>[
                CustomAppBar(
                  title: LocaleKeys.checkoutTitle.tr(),
                  onBack: vm._back,
                ),

                CheckoutStepper(currentStep: step),

                Expanded(child: _pages),
              ],
            ),
          ),
        );
      },
    );
  }
}
