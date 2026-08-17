part of '../product_details_imports.dart';

/// The pinned card at the bottom: quantity plus "Add to cart" when the product
/// is sellable, the availability subscription when it is not.
class ProductDetailsBottomAction extends StatelessWidget {
  final ProductDetailsViewModel vm;
  final ProductDetailModel product;

  const ProductDetailsBottomAction({
    super.key,
    required this.vm,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return _BottomActionCard(
      child: product.isInStock
          ? _AddToBasketRow(vm: vm)
          : _NotifyMeButton(vm: vm),
    );
  }
}

class _BottomActionCard extends StatelessWidget {
  final Widget child;

  const _BottomActionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppColors.surfaceGrey),
      ),
      child: child,
    );
  }
}

class _AddToBasketRow extends StatelessWidget {
  final ProductDetailsViewModel vm;

  const _AddToBasketRow({required this.vm});

  @override
  Widget build(BuildContext context) {
    final int quantity = vm._data.quantity;

    return Row(
      children: [
        _QuantityControl(
          quantity: quantity,
          onIncrementTap: vm._incrementQuantity,
          onDecrementTap: quantity > 1 ? vm._decrementQuantity : null,
        ),

        12.horizontalSpace,

        Expanded(
          child: SizedBox(
            height: 58.h,
            child: ElevatedButton(
              onPressed: vm._addToBasket,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_basket_outlined,
                    size: 22.sp,
                    color: AppColors.white,
                  ),
                  8.horizontalSpace,
                  Flexible(
                    child: Text(
                      LocaleKeys.productDetailsAddToBasket.tr(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotifyMeButton extends StatelessWidget {
  final ProductDetailsViewModel vm;

  const _NotifyMeButton({required this.vm});

  @override
  Widget build(BuildContext context) {
    final bool isSubscribed = vm._data.isNotifySubscribed;
    final bool isLoading = vm._data.isNotifyLoading;

    final bool isEnabled = !isSubscribed && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 58.h,
      child: ElevatedButton(
        onPressed: isEnabled ? vm._notifyWhenAvailable : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSubscribed
              ? AppColors.successGreen
              : AppColors.primaryRed,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: isSubscribed
              ? AppColors.successGreen
              : AppColors.unavailableGrey,
          disabledForegroundColor: AppColors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSubscribed
                        ? Icons.notifications_active
                        : Icons.notifications_none,
                    size: 22.sp,
                    color: AppColors.white,
                  ),
                  8.horizontalSpace,
                  Flexible(
                    child: Text(
                      isSubscribed
                          ? LocaleKeys.productDetailsNotifyMeSubscribed.tr()
                          : LocaleKeys.productDetailsNotifyMe.tr(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrementTap;
  final VoidCallback? onDecrementTap;

  const _QuantityControl({
    required this.quantity,
    required this.onIncrementTap,
    required this.onDecrementTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool canDecrement = onDecrementTap != null;

    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceScaffold,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderAction),
      ),
      child: Row(
        children: [
          _QtyIconButton(
            icon: Icons.add,
            onTap: onIncrementTap,
            iconColor: AppColors.navyHeading,
          ),

          6.horizontalSpace,

          SizedBox(
            width: 32.w,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textGraphite,
              ),
            ),
          ),

          6.horizontalSpace,

          _QtyIconButton(
            icon: Icons.remove,
            onTap: onDecrementTap,
            iconColor: canDecrement
                ? AppColors.navyHeading
                : AppColors.unavailableGrey,
            backgroundColor: canDecrement
                ? AppColors.white
                : AppColors.surfacePlaceholder,
          ),
        ],
      ),
    );
  }
}

class _QtyIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color? backgroundColor;

  const _QtyIconButton({
    required this.icon,
    required this.onTap,
    required this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderButton),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20.sp, color: iconColor),
      ),
    );
  }
}
