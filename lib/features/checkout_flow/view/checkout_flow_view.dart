part of '../checkout_flow_imports.dart';

class CheckoutFlowView extends StatefulWidget {
  const CheckoutFlowView({super.key});

  @override
  State<CheckoutFlowView> createState() => _CheckoutFlowViewState();
}

class _CheckoutFlowViewState extends State<CheckoutFlowView> {
  final CheckoutFlowViewModel vm = CheckoutFlowViewModel();

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
    return BlocBuilder<GenericCubit<int>, GenericState<int>>(
      bloc: vm._stepCubit,
      builder: (context, state) {
        final int step = state.data;

        final bool isCart = step == CheckoutFlowService.cartStep;

        return PopScope(
          canPop: isCart,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (didPop) return;

            vm._back();
          },
          child: Container(
            color: AppColors.white,
            child: Column(
              children: <Widget>[
                CustomAppBar(
                  title: vm._title(step),
                  onMenu: isCart
                      ? () => Scaffold.of(context).openDrawer()
                      : null,
                  onBack: isCart ? null : vm._back,
                ),

                isCart
                    ? const SizedBox.shrink()
                    : CheckoutStepper(currentStep: vm._stepperStep(step)),

                Expanded(child: CheckoutFlowPages(vm: vm)),
              ],
            ),
          ),
        );
      },
    );
  }
}
