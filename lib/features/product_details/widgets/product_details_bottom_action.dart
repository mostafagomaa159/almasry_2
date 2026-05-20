part of '../product_details_imports.dart';

class ProductDetailsBottomAction extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrementTap;
  final VoidCallback onDecrementTap;
  final VoidCallback onAddToBasketTap;

  const ProductDetailsBottomAction({
    super.key,
    required this.quantity,
    required this.onIncrementTap,
    required this.onDecrementTap,
    required this.onAddToBasketTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDecrementEnabled = quantity > 1;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFF0F0F0),
        ),
      ),
      child: Row(
        children: [
          _QuantityControl(
            quantity: quantity,
            onIncrementTap: onIncrementTap,
            onDecrementTap: isDecrementEnabled ? onDecrementTap : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SizedBox(
              height: 58.h,
              child: ElevatedButton(
                onPressed: onAddToBasketTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
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
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        LocaleKeys.productDetailsAddToBasket.tr(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE7E7E7),
        ),
      ),
      child: Row(
        children: [
          _QtyIconButton(
            icon: Icons.add,
            onTap: onIncrementTap,
            iconColor: const Color(0xFF11385B),
          ),
          SizedBox(width: 6.w),
          SizedBox(
            width: 32.w,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C2C2C),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          _QtyIconButton(
            icon: Icons.remove,
            onTap: onDecrementTap,
            iconColor: canDecrement
                ? const Color(0xFF11385B)
                : const Color(0xFFBDBDBD),
            backgroundColor:
            canDecrement ? Colors.white : const Color(0xFFF3F3F3),
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
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFE6E6E6),
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20.sp,
          color: iconColor,
        ),
      ),
    );
  }
}
