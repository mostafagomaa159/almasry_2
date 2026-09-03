part of '../checkout_imports.dart';

class CheckoutShippingMethodsSection extends StatelessWidget {
  final CheckoutViewModel vm;
  final ListShippingMethods methods;

  const CheckoutShippingMethodsSection({
    super.key,
    required this.vm,
    required this.methods,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<String>, GenericState<String>>(
      bloc: vm._selectedAddressIdCubit,
      builder: (BuildContext context, GenericState<String> addressState) {
        if (addressState.data.trim().isEmpty) return const SizedBox.shrink();

        return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
          bloc: vm._applyingAddressCubit,
          builder: (BuildContext context, GenericState<bool> applyingState) {
            return _section(isApplyingAddress: applyingState.data);
          },
        );
      },
    );
  }

  Widget _section({required bool isApplyingAddress}) {
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

        if (isApplyingAddress)
          const _MethodsLoader()
        else if (methods.isEmpty)
          CustomAppEmptyView(message: LocaleKeys.checkoutNoShippingMethods.tr())
        else
          for (final ShippingMethodModel method in methods)
            _MethodRow(vm: vm, method: method),
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
  final CheckoutViewModel vm;
  final ShippingMethodModel method;

  const _MethodRow({required this.vm, required this.method});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<String>, GenericState<String>>(
      bloc: vm._selectedMethodKeyCubit,
      builder: (BuildContext context, GenericState<String> selectedState) {
        return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
          bloc: vm._settingMethodCubit,
          builder: (BuildContext context, GenericState<bool> busyState) {
            return _row(
              isSelected: method.key == selectedState.data,
              isBusy: busyState.data,
            );
          },
        );
      },
    );
  }

  Widget _row({required bool isSelected, required bool isBusy}) {
    final Color color = isSelected
        ? AppColors.primaryRed
        : const Color(0xFF3B3B3B);

    return InkWell(
      onTap: isBusy ? null : () => vm._selectShippingMethod(method),
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
