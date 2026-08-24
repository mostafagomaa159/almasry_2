part of '../checkout_shipping_imports.dart';

/// The "Shipping Company" radio list.
///
/// Hidden entirely until an address is chosen — Magento cannot quote a carrier
/// without one, so an empty list before that point would read as "nobody
/// delivers here".
class CheckoutShippingMethodsSection extends StatelessWidget {
  final CheckoutShippingViewModel vm;
  final CheckoutShippingData data;

  const CheckoutShippingMethodsSection({
    super.key,
    required this.vm,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (!data.hasAddress) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          LocaleKeys.checkoutShippingCompany.tr(),
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlue,
          ),
        ),

        14.verticalSpace,

        if (data.isApplyingAddress)
          const _MethodsLoader()
        else if (data.methods.isEmpty)
          CustomAppEmptyView(message: LocaleKeys.checkoutNoShippingMethods.tr())
        else
          for (final ShippingMethodModel method in data.methods)
            _MethodRow(
              method: method,
              isSelected: method.key == data.selectedMethodKey,
              isBusy: data.isSettingMethod,
              onTap: () => vm._selectMethod(method),
            ),
      ],
    );
  }
}

class _MethodsLoader extends StatelessWidget {
  const _MethodsLoader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: SizedBox(
          width: 26.w,
          height: 26.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.primaryRed,
          ),
        ),
      ),
    );
  }
}

class _MethodRow extends StatelessWidget {
  final ShippingMethodModel method;
  final bool isSelected;
  final bool isBusy;
  final VoidCallback onTap;

  const _MethodRow({
    required this.method,
    required this.isSelected,
    required this.isBusy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected
        ? AppColors.primaryRed
        : const Color(0xFF3B3B3B);

    return InkWell(
      onTap: isBusy ? null : onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: <Widget>[
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 24.sp,
              color: isSelected
                  ? AppColors.primaryRed
                  : AppColors.textSecondary,
            ),

            14.horizontalSpace,

            Expanded(
              child: Text(
                method.displayTitle,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),

            Text(
              formatPrice(method.price),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
