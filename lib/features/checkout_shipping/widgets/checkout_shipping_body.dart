part of '../checkout_shipping_imports.dart';

class CheckoutShippingBody extends StatelessWidget {
  final CheckoutShippingViewModel vm;

  const CheckoutShippingBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<ListShippingMethods>,
      GenericState<ListShippingMethods>
    >(
      bloc: vm._methodsCubit,
      builder: (BuildContext context, GenericState<ListShippingMethods> state) {
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
