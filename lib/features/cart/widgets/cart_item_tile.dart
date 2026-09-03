part of '../cart_imports.dart';

class CartItemTile extends StatelessWidget {
  final CartViewModel vm;
  final CartItemModel item;

  const CartItemTile({super.key, required this.vm, required this.item});

  static const double _dismissThreshold = 0.4;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<int>(item.numericId),
      direction: DismissDirection.horizontal,
      dismissThresholds: const <DismissDirection, double>{
        DismissDirection.startToEnd: _dismissThreshold,
        DismissDirection.endToStart: _dismissThreshold,
      },
      background: const _CartRemoveBackground(),
      secondaryBackground: const _CartRemoveBackground(),
      confirmDismiss: (DismissDirection direction) async {
        vm._confirmRemoveItem(item);

        return false;
      },
      child: _body(),
    );
  }

  Widget _body() {
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
                  color: AppColors.titleNavy,
                ),
              ),

              8.verticalSpace,

              Text(
                formatPrice(item.unitPrice),
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleNavy,
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
          canDecrement: item.quantity > 1,
          onIncrement: () => vm._incrementQuantity(item),
          onDecrement: () => vm._decrementQuantity(item),
        ),
      ],
    );
  }
}
