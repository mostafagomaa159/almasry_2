part of '../checkout_imports.dart';

class CheckoutPaymentPlaceholder extends StatelessWidget {
  final CheckoutViewModel vm;

  const CheckoutPaymentPlaceholder({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm._paymentErrorMessage.isNotEmpty) {
      return CustomAppErrorView(
        message: vm._paymentErrorMessage,
        onRetry: vm._loadPaymentMethods,
      );
    }

    return CustomAppEmptyView(
      message: LocaleKeys.checkoutNoPaymentMethods.tr(),
    );
  }
}
