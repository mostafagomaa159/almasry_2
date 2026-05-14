part of '../order_details_imports.dart';

class OrderDetailsSummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;

  const OrderDetailsSummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final FontWeight weight = isBold ? FontWeight.w700 : FontWeight.w600;
    final double fontSize = isBold ? 20.sp : 18.sp;

    return Row(
      children: [
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF17375E),
            fontSize: fontSize,
            fontWeight: weight,
          ),
        ),
        const Spacer(),
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF17375E),
            fontSize: fontSize,
            fontWeight: weight,
          ),
        ),
      ],
    );
  }
}
