import 'package:almasry_2/core/utils/language_detector.dart';
import 'package:flutter/material.dart';

/// A [Text] that reads in its **own** language's direction rather than the
/// interface's.
///
/// Backend copy does not always match the store view it came from — a Latin
/// brand name, a comma-joined category list, a "500mg" — and a plain [Text]
/// hands all of it to the ambient [Directionality]. In an Arabic interface that
/// turns "Panadol, Vitamins" into "Vitamins ,Panadol" and "Weight:" into
/// ":Weight": the glyphs are right, the order is not.
///
/// Two directions are in play here and they are deliberately kept apart:
///
/// * **Glyph order** comes from the text, via [LanguageDetector.startsArabic].
/// * **Box alignment** keeps following the interface — a `TextAlign.start`
///   label stays on the interface's leading edge, so a table of mixed-language
///   rows still lines up in one column. That is why `start`/`end` are resolved
///   against the ambient direction here instead of being handed to [Text],
///   which would otherwise resolve them against the *content's* direction and
///   leave the column ragged.
///
/// Text with no strong character at all — a bare weight or price — follows the
/// interface, since it has no direction to assert.
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

  /// Pins `start`/`end` to a physical side using the *interface* direction, so
  /// the content's direction can never move the column.
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
