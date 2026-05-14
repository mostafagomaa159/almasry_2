part of '../order_details_imports.dart';


class OrderDetailsInfoSection extends StatelessWidget {
  final String customerName;
  final String phoneNumber;
  final String address;

  const OrderDetailsInfoSection({
    super.key,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          customerName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF17375E),
            fontSize: 19.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          phoneNumber,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF17375E),
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          address,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF17375E),
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
