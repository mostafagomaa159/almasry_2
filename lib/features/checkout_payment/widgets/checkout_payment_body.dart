part of '../checkout_payment_imports.dart';

class CheckoutPaymentBody extends StatelessWidget {
  final CheckoutPaymentViewModel vm;

  const CheckoutPaymentBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._loadingCubit,
      builder: ( context, loadingState) {
        if (loadingState.data) {
          return const Center(child: CustomAppLoadingView());
        }

        return BlocBuilder<
          GenericCubit<ListPaymentMethods>,
          GenericState<ListPaymentMethods>
        >(
          bloc: vm._methodsCubit,
          builder:
              ( context, state) {
                if (state.data.isEmpty) {
                  return _PaymentPlaceholder(vm: vm);
                }

                return BlocBuilder<
                  GenericCubit<CartModel>,
                  GenericState<CartModel>
                >(
                  bloc: vm._cartCubit,
                  builder: (context, cartState) {
                    if (cartState is GenericUpdateState) {
                      final cart = cartState.data;

                      return Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.fromLTRB(
                                16.w,
                                8.h,
                                16.w,
                                24.h,
                              ),
                              itemCount: state.data.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      16.verticalSpace,
                              itemBuilder: (BuildContext context, int index) {
                                return CheckoutPaymentMethodCard(
                                  vm: vm,
                                  method: state.data[index],
                                );
                              },
                            ),
                          ),

                          CheckoutPaymentSummary(vm: vm, cart: cart),
                        ],
                      );
                    }
                    return const Center(child: CustomAppLoadingView());
                  },
                );
              },
        );
      },
    );
  }
}

class _PaymentPlaceholder extends StatelessWidget {
  const _PaymentPlaceholder({required this.vm});

  final CheckoutPaymentViewModel vm;

  @override
  Widget build(BuildContext context) {
    if (vm._errorMessage.isNotEmpty) {
      return CustomAppErrorView(
        message: vm._errorMessage,
        onRetry: vm._loadMethods,
      );
    }

    return CustomAppEmptyView(
      message: LocaleKeys.checkoutNoPaymentMethods.tr(),
    );
  }
}
