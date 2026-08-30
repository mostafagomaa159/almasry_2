part of '../checkout_review_imports.dart';

/// The three review sections over the totals panel.
///
/// Only the cart is watched here — every section owns the builder for its own
/// expand flag, so collapsing one does not rebuild the other two.
class CheckoutReviewBody extends StatelessWidget {
  final CheckoutReviewViewModel vm;

  const CheckoutReviewBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<CartData>, GenericState<CartData>>(
      bloc: vm._cartCubit,
      builder: (BuildContext context, GenericState<CartData> cartState) {
        final CartModel cart = cartState.data.cart;

        return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: 16.h),
                children: <Widget>[
                  CheckoutReviewProductsSection(vm: vm, cart: cart),
                  CheckoutReviewOrderSection(vm: vm),
                  CheckoutReviewBillSection(vm: vm, cart: cart),
                ],
              ),
            ),

            CheckoutReviewSummary(vm: vm, cart: cart),
          ],
        );
      },
    );
  }
}
