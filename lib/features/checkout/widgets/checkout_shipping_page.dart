part of '../checkout_imports.dart';

class CheckoutShippingPage extends StatelessWidget {
  final CheckoutViewModel vm;

  const CheckoutShippingPage({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<ListShippingMethods>,
      GenericState<ListShippingMethods>
    >(
      bloc: vm._shippingMethodsCubit,
      builder: (context, methodsState) {
        if (vm._shippingErrorMessage.isNotEmpty) {
          return CustomAppErrorView(
            message: vm._shippingErrorMessage,
            onRetry: vm._retryShipping,
          );
        }

        return BlocBuilder<GenericCubit<CartModel>, GenericState<CartModel>>(
          bloc: vm._cartCubit,
          builder: (context, state) {
            if (state is GenericUpdateState) {
              final cart = state.data;

              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                      children: <Widget>[
                        CheckoutShippingAddressSection(vm: vm),

                        28.verticalSpace,

                        CheckoutShippingMethodsSection(
                          vm: vm,
                          methods: methodsState.data,
                        ),
                      ],
                    ),
                  ),

                  CheckoutShippingSummary(vm: vm, cart: cart),
                ],
              );
            }
            return const Center(child: CustomAppLoadingView());
          },
        );
      },
    );
  }
}
