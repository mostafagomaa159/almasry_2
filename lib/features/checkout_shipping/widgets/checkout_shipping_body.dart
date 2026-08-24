part of '../checkout_shipping_imports.dart';

/// The scrolling half of step one, plus the pinned totals panel.
class CheckoutShippingBody extends StatelessWidget {
  final CheckoutShippingViewModel vm;

  const CheckoutShippingBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<CheckoutShippingData>,
      GenericState<CheckoutShippingData>
    >(
      bloc: vm._cubit,
      builder: (BuildContext context, GenericState<CheckoutShippingData> state) {
        final CheckoutShippingData data = state.data;

        // A failed address apply takes the whole step: there is nothing valid
        // to pick a carrier from until it succeeds.
        if (data.status == CheckoutShippingStatus.error) {
          return CustomAppErrorView(
            message: data.errorMessage,
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

                  CheckoutShippingMethodsSection(vm: vm, data: data),
                ],
              ),
            ),

            CheckoutShippingSummary(vm: vm, data: data),
          ],
        );
      },
    );
  }
}
