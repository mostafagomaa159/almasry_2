part of '../checkout_review_imports.dart';

/// The three review sections over the totals panel.
///
/// Nested builders: the outer one is the cart (the source of every value on
/// screen), the inner one the section expand flags.
class CheckoutReviewBody extends StatelessWidget {
  final CheckoutReviewViewModel vm;

  const CheckoutReviewBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<CartData>, GenericState<CartData>>(
      bloc: vm._cartCubit,
      builder: (BuildContext context, GenericState<CartData> cartState) {
        final CartModel cart = cartState.data.cart;

        return BlocBuilder<
          GenericCubit<CheckoutReviewData>,
          GenericState<CheckoutReviewData>
        >(
          bloc: vm._cubit,
          builder:
              (BuildContext context, GenericState<CheckoutReviewData> state) {
                final CheckoutReviewData data = state.data;

                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 16.h),
                        children: <Widget>[
                          CheckoutReviewProductsSection(
                            vm: vm,
                            data: data,
                            cart: cart,
                          ),
                          CheckoutReviewOrderSection(vm: vm, data: data),
                          CheckoutReviewBillSection(
                            vm: vm,
                            data: data,
                            cart: cart,
                          ),
                        ],
                      ),
                    ),

                    CheckoutReviewSummary(vm: vm, data: data, cart: cart),
                  ],
                );
              },
        );
      },
    );
  }
}
