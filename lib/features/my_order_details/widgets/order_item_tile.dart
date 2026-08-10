part of '../my_order_imports.dart';

class _OrderItemTile extends StatelessWidget {
  final OrderItemModel item;

  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final hasImage = item.imagePath.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: hasImage
              ? AppNetworkImage(
                  url: item.imagePath,
                  width: 70,
                  height: 70,
                  placeholder: Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                )
              : Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis),
              6.verticalSpace,
              Text(
                '${LocaleKeys.orderQtyLabel.tr()}: ${item.qtyOrdered}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              6.verticalSpace,
              Text(
                '${LocaleKeys.orderPriceLabel.tr()}: ${item.price.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
