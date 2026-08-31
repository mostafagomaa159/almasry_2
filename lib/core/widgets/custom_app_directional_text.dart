import 'package:almasry_2/core/utils/language_detector.dart';
import 'package:flutter/material.dart';

class CustomAppDirectionalText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomAppDirectionalText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final TextDirection ambient = Directionality.of(context);
    final bool? startsArabic = LanguageDetector.startsArabic(text);

    final TextDirection direction = startsArabic == null
        ? ambient
        : (startsArabic ? TextDirection.rtl : TextDirection.ltr);

    return Text(
      text,
      textDirection: direction,
      textAlign: _resolveAlign(ambient),
      maxLines: maxLines,
      overflow: overflow,
      style: style,
    );
  }

  TextAlign? _resolveAlign(TextDirection ambient) {
    final bool isRtl = ambient == TextDirection.rtl;

    switch (textAlign) {
      case TextAlign.start:
        return isRtl ? TextAlign.right : TextAlign.left;
      case TextAlign.end:
        return isRtl ? TextAlign.left : TextAlign.right;
      default:
        return textAlign;
    }
  }
}
