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
    final bool isDecrementEnabled = quantity >= 1;

    return Row(
      children: [
        _buildQtyButton(
          icon: Icons.add,
          onTap: onIncrementTap,
          iconColor: const Color(0xFF11385B),
        ),
        SizedBox(width: 18.w),
        Text(
          '$quantity',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        SizedBox(width: 18.w),
        _buildQtyButton(
          icon: Icons.remove,
          onTap: isDecrementEnabled ? onDecrementTap : () {},
          iconColor: isDecrementEnabled
              ? const Color(0xFF11385B)
              : const Color(0xFFB7B7B7),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: SizedBox(
            height: 56.h,
            child: ElevatedButton.icon(
              onPressed: onAddToBasketTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Icon(
                Icons.shopping_basket_outlined,
                color: Colors.white,
                size: 22.sp,
              ),
              label: Text(
                LocaleKeys.productDetailsAddToBasket.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 72.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE6E6E6)),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 30.sp, color: iconColor),
      ),
    );
  }
}
