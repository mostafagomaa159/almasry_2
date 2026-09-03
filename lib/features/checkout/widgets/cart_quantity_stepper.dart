part of '../checkout_imports.dart';

class _CartQuantityStepper extends StatelessWidget {
  final int quantity;
  final bool canDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartQuantityStepper({
    required this.quantity,
    required this.canDecrement,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _CartStepperButton(icon: Icons.add, onTap: onIncrement),

        SizedBox(
          width: 40.w,
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

        _CartStepperButton(
          icon: Icons.remove,
          onTap: canDecrement ? onDecrement : null,
        ),
      ],
    );
  }
}
