part of '../checkout_payment_imports.dart';

/// The payment method list plus the pinned totals panel.
class CheckoutPaymentBody extends StatelessWidget {
  final CheckoutPaymentViewModel vm;

  const CheckoutPaymentBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<CheckoutPaymentData>,
      GenericState<CheckoutPaymentData>
    >(
      bloc: vm._cubit,
      builder: (BuildContext context, GenericState<CheckoutPaymentData> state) {
        final CheckoutPaymentData data = state.data;

        if (data.status == CheckoutPaymentStatus.loading) {
          return const Center(child: CustomAppLoadingView());
        }

        if (data.status == CheckoutPaymentStatus.error) {
          return CustomAppErrorView(
            message: data.errorMessage,
            onRetry: vm._loadMethods,
          );
        }

        return Column(
          children: <Widget>[
            Expanded(
              child: data.methods.isEmpty
                  ? CustomAppEmptyView(
                      message: LocaleKeys.checkoutNoPaymentMethods.tr(),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                      itemCount: data.methods.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          16.verticalSpace,
                      itemBuilder: (BuildContext context, int index) {
                        return CheckoutPaymentMethodCard(
                          vm: vm,
                          data: data,
                          method: data.methods[index],
                        );
                      },
                    ),
            ),

            CheckoutPaymentSummary(vm: vm, data: data),
          ],
        );
      },
    );
  }
}
