import 'dart:convert';

import 'package:almasry_2/core/services/network_logger_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Captures what the logger would print, by swapping the global `debugPrint`
/// the way the framework's own tests do.
List<String> _capture(void Function(NetworkLoggerService logger) body,
    {NetworkLoggerService logger = const NetworkLoggerService(enabled: true)}) {
  final List<String> lines = <String>[];
  final DebugPrintCallback original = debugPrint;

  debugPrint = (String? message, {int? wrapWidth}) {
    lines.add(message ?? '');
  };

  try {
    body(logger);
  } finally {
    debugPrint = original;
  }

  return lines;
}

void main() {
  group('line chunking', () {
    test('keeps every emitted line inside logcat\'s byte budget', () {
      // 2 bytes per character in UTF-8 — the case that used to be cut off
      // mid-character, losing the rest of the line.
      final String arabic = 'بانادول جوينت ' * 400;

      final List<String> lines = _capture((NetworkLoggerService l) => l.line(arabic));

      expect(lines.length, greaterThan(1));

      for (final String line in lines) {
        expect(utf8.encode(line).length, lessThanOrEqualTo(710));
      }
    });

    test('loses no characters and prefixes every continuation', () {
      final String arabic = 'بانادول جوينت ' * 400;

      final List<String> lines = _capture((NetworkLoggerService l) => l.line(arabic));

      expect(lines.every((String line) => line.startsWith('│ ')), isTrue);
      expect(
        lines.map((String line) => line.substring(2)).join(),
        arabic,
      );
    });

    test('splits on character boundaries, never mid-rune', () {
      // A 4-byte rune straddling the budget is the surrogate-pair case.
      final String emoji = '💊' * 400;

      final List<String> lines = _capture((NetworkLoggerService l) => l.line(emoji));

      for (final String line in lines) {
        expect(line.substring(2).runes.every((int r) => r == 0x1F48A), isTrue);
      }
      expect(lines.map((String line) => line.substring(2)).join(), emoji);
    });
  });

  group('string elision', () {
    test('shortens a long leaf string but keeps the fields after it', () {
      final Map<String, Object?> body = <String, Object?>{
        'description': 'ا' * 3000,
        'price': 67,
      };

      final String output = _capture(
        (NetworkLoggerService l) => l.section('data', body),
        logger: const NetworkLoggerService(enabled: true, maxStringChars: 50),
      ).join('\n');

      expect(output, contains('(+2950 more)'));
      expect(output, contains('"price": 67'));
      expect(output, isNot(contains('truncated')));
    });

    test('leaves short strings and numbers untouched', () {
      final String output = _capture(
        (NetworkLoggerService l) => l.section('data', <String, Object?>{
          'sku': 'ISG010419',
          'value': 67,
        }),
      ).join('\n');

      expect(output, contains('"sku": "ISG010419"'));
      expect(output, contains('"value": 67'));
    });

    test('reaches strings nested in lists', () {
      final String output = _capture(
        (NetworkLoggerService l) => l.section('data', <String, Object?>{
          'items': <Object?>[
            <String, Object?>{'html': 'x' * 500},
          ],
        }),
        logger: const NetworkLoggerService(enabled: true, maxStringChars: 20),
      ).join('\n');

      expect(output, contains('(+480 more)'));
    });
  });

  group('secrets and gating', () {
    test('masks the bearer token', () {
      final List<String> lines = _capture(
        (NetworkLoggerService l) => l.keyValue('Authorization', 'Bearer abc123'),
      );

      expect(lines.single, contains('*** (13 chars)'));
      expect(lines.single, isNot(contains('abc123')));
    });

    test('prints nothing when disabled', () {
      final List<String> lines = _capture(
        (NetworkLoggerService l) {
          l.open('REQUEST');
          l.section('body', <String, Object?>{'a': 1});
          l.close();
        },
        logger: const NetworkLoggerService(enabled: false),
      );

      expect(lines, isEmpty);
    });
  });

  test('reads the operation name off a GraphQL document', () {
    expect(
      NetworkLoggerService.operationName('query GetProductDetail(\$sku: String!) {'),
      'GetProductDetail',
    );
    expect(
      NetworkLoggerService.operationName('  mutation PlaceOrder(\$cartId: String!) {'),
      'PlaceOrder',
    );
    expect(NetworkLoggerService.operationName('{ products { sku } }'), isNull);
  });
}
