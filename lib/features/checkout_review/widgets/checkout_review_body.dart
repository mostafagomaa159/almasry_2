part of '../checkout_review_imports.dart';

class CheckoutReviewBody extends StatelessWidget {
  final CheckoutReviewViewModel vm;

  const CheckoutReviewBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<CartModel>, GenericState<CartModel>>(
      bloc: vm._cartCubit,
      builder: (context, state) {
        if (state is GenericUpdateState) {
          final cart = state.data;

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
        }
        return const Center(child: CustomAppLoadingView());
      },
    );
  }
}
