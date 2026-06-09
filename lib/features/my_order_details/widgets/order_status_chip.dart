part of '../my_order_imports.dart';

class OrderStatusChip extends StatelessWidget {
  final String status;

  const OrderStatusChip({
    super.key,
    required this.status,
  });

  Color _backgroundColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFF3CD);
      case 'processing':
        return const Color(0xFFD1ECF1);
      case 'complete':
        return const Color(0xFFD4EDDA);
      case 'canceled':
      case 'cancelled':
        return const Color(0xFFF8D7DA);
      default:
        return const Color(0xFFE9ECEF);
    }
  }

  Color _textColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFF856404);
      case 'processing':
        return const Color(0xFF0C5460);
      case 'complete':
        return const Color(0xFF155724);
      case 'canceled':
      case 'cancelled':
        return const Color(0xFF721C24);
      default:
        return const Color(0xFF495057);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: _textColor(),
        ),
      ),
    );
  }
}
