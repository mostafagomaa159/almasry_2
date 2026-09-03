import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CheckoutStep { address, payment, review }

class CheckoutStepper extends StatelessWidget {
  final CheckoutStep currentStep;

  const CheckoutStepper({super.key, required this.currentStep});

  static const List<IconData> _icons = <IconData>[
    Icons.location_on,
    Icons.payment,
    Icons.assignment_turned_in_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final int current = currentStep.index;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
      child: Row(
        children: <Widget>[
          for (int index = 0; index < _icons.length; index++) ...<Widget>[
            if (index > 0)
              Expanded(child: _StepConnector(isActive: index <= current)),
            _StepCircle(icon: _icons[index], isActive: index <= current),
          ],
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _StepCircle({required this.icon, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primaryRed : AppColors.textSecondary,
        boxShadow: isActive
            ? <BoxShadow>[
                BoxShadow(
                  color: AppColors.primaryRed.withValues(alpha: 0.45),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 26.sp, color: AppColors.white),
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isActive;

  const _StepConnector({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2.h,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: isActive ? AppColors.primaryRed : AppColors.unavailableGrey,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  static const double _dashWidth = 6;
  static const double _dashGap = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.round;

    final double centerY = size.height / 2;

    for (double x = 0; x < size.width; x += _dashWidth + _dashGap) {
      final double end = (x + _dashWidth).clamp(0, size.width);

      canvas.drawLine(Offset(x, centerY), Offset(end, centerY), paint);
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
