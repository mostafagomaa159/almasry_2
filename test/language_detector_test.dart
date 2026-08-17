import 'package:almasry_2/core/utils/language_detector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LanguageDetector.startsArabic', () {
    test('Latin copy reads left-to-right', () {
      expect(LanguageDetector.startsArabic('Panadol, Vitamins'), isFalse);
      expect(LanguageDetector.startsArabic('Weight:'), isFalse);
      expect(LanguageDetector.startsArabic('500mg'), isFalse);
    });

    test('Arabic copy reads right-to-left', () {
      expect(LanguageDetector.startsArabic('الوزن:'), isTrue);
      expect(LanguageDetector.startsArabic('فيتامينات، مكملات'), isTrue);
    });

    test('a mixed run follows its first strong character', () {
      expect(LanguageDetector.startsArabic('Panadol, فيتامين'), isFalse);
      expect(LanguageDetector.startsArabic('فيتامين, Panadol'), isTrue);
    });

    test('leading digits and punctuation do not decide direction', () {
      expect(LanguageDetector.startsArabic('500 mg'), isFalse);
      expect(LanguageDetector.startsArabic('(2) عبوات'), isTrue);
    });

    test('text with no strong character defers to the interface', () {
      expect(LanguageDetector.startsArabic('0.5'), isNull);
      expect(LanguageDetector.startsArabic('—'), isNull);
      expect(LanguageDetector.startsArabic(''), isNull);
    });
  });
}
