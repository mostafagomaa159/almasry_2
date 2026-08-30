part of '../checkout_shipping_imports.dart';

/// The scrolling half of step one, plus the pinned totals panel.
class CheckoutShippingBody extends StatelessWidget {
  final CheckoutShippingViewModel vm;

  const CheckoutShippingBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    // The methods cubit is the screen-level signal: every failure emits on it,
    // so this builder is where the error view takes over.
    return BlocBuilder<
      GenericCubit<ListShippingMethods>,
      GenericState<ListShippingMethods>
    >(
      bloc: vm._methodsCubit,
      builder: (BuildContext context, GenericState<ListShippingMethods> state) {
        // A failed address apply takes the whole step: there is nothing
        // valid to pick a carrier from until it succeeds.
        if (vm._errorMessage.isNotEmpty) {
          return CustomAppErrorView(
            message: vm._errorMessage,
            onRetry: vm._retry,
          );
        }

        return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                children: <Widget>[
                  CheckoutShippingAddressSection(vm: vm),

                  28.verticalSpace,

                  CheckoutShippingMethodsSection(vm: vm, methods: state.data),
                ],
              ),
            ),

            CheckoutShippingSummary(vm: vm),
          ],
        );
      },
    );
  }
}
