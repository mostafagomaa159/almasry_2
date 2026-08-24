part of '../otp_verification_imports.dart';

class OtpPinFields extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool hasError;

  const OtpPinFields({
    super.key,
    required this.controller,
    this.onChanged,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0,
          child: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: 5,
            onChanged: onChanged,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Future.delayed(AppDurations.focusHop, () {
              if (!context.mounted) return;

              FocusScope.of(context).requestFocus(FocusNode());
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final text = controller.text;
              final char = index < text.length ? text[index] : '';

              return Container(
                width: 58,
                height: 68,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasError
                        ? Colors.red.shade300
                        : AppColors.surfaceField,
                  ),
                ),
                child: Text(
                  char,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSlate,
                  ),
                ),
              );
            }),
          ),
        ),
        Positioned.fill(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 5,
            onChanged: onChanged,
            cursorColor: Colors.transparent,
            showCursor: false,
            style: const TextStyle(color: Colors.transparent, fontSize: 1),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
