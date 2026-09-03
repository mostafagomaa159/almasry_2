part of '../checkout_imports.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final CheckoutViewModel vm = CheckoutViewModel();

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

                Expanded(
                  child: PageView(
                    controller: vm._pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: vm._onPageChanged,
                    children: <Widget>[
                      _cartPage(),
                      _shippingPage(),
                      _paymentPage(),
                      _reviewPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cartPage() {
    return BlocBuilder<GenericCubit<CartModel>, GenericState<CartModel>>(
      bloc: vm._cartCubit,
      builder: (context, state) {
        if (state is GenericUpdateState) {
          final cart = state.data;

          if (cart.isEmpty) return const CartEmptyView();

          return _CartContent(vm: vm, cart: cart);
        }
        return const CartShimmer();
      },
    );
  }

  Widget _shippingPage() {
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

  Widget _paymentPage() {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._paymentLoadingCubit,
      builder: (context, loadingState) {
        if (loadingState.data) {
          return const Center(child: CustomAppLoadingView());
        }

        return BlocBuilder<
          GenericCubit<ListPaymentMethods>,
          GenericState<ListPaymentMethods>
        >(
          bloc: vm._paymentMethodsCubit,
          builder: (context, state) {
            if (state.data.isEmpty) {
              return CheckoutPaymentPlaceholder(vm: vm);
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
                          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                          itemCount: state.data.length,
                          separatorBuilder: (BuildContext context, int index) =>
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

  Widget _reviewPage() {
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
