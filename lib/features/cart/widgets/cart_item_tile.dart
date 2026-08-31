part of '../cart_imports.dart';

class CartItemTile extends StatelessWidget {
  final CartViewModel vm;
  final CartItemModel item;
  final bool isBusy;

  const CartItemTile({
    super.key,
    required this.vm,
    required this.item,
    this.isBusy = false,
  });

  static const Color _titleColor = Color(0xFF18314F);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: SizedBox(
            width: 96.w,
            height: 96.w,
            child: CustomAppNetworkImage(url: item.imageUrl),
          ),
        ),

        12.horizontalSpace,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: _titleColor,
                ),
              ),

              8.verticalSpace,

              Text(
                formatPrice(item.unitPrice),
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: _titleColor,
                ),
              ),

              if (item.hasDiscount)
                Text(
                  formatPrice(item.regularUnitPrice),
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),

        8.horizontalSpace,

        _CartQuantityStepper(
          quantity: item.quantity,
          isBusy: isBusy,
          onIncrement: () => vm._increment(item),
          onDecrement: () => vm._decrement(item),
        ),
      ],
    );
  }
}

class _CartQuantityStepper extends StatelessWidget {
  final int quantity;
  final bool isBusy;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartQuantityStepper({
    required this.quantity,
    required this.isBusy,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _StepperButton(icon: Icons.add, onTap: isBusy ? null : onIncrement),

        SizedBox(
          width: 40.w,
          child: isBusy
              ? Center(
                  child: SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryRed,
                    ),
                  ),
                )
              : Text(
                  '$quantity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
        ),

        _StepperButton(icon: Icons.remove, onTap: isBusy ? null : onDecrement),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, required this.onTap});

  static const Color _outlineColor = Color(0xFF18314F);

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isEnabled ? _outlineColor : const Color(0xFFCFCFCF),
            width: 1.4,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 22.sp,
          color: isEnabled ? _outlineColor : const Color(0xFFCFCFCF),
        ),
      ),
    );
  }
}
