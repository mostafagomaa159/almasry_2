import 'dart:convert';

import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:flutter/foundation.dart';

/// Stores JSON-encodable lists in shared preferences so a screen can paint
/// last session's data immediately and refresh behind it, instead of showing a
/// skeleton on every cold start.
///
/// There is no expiry: callers are expected to re-fetch after reading, so the
/// cache is never more than one app-open stale.
class CacheManagerService {
  SharedPrefsServices get _prefs => sl<SharedPrefsServices>();

  Future<List<T>> getCachedData<T>({
    required String key,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final String raw = _prefs.getString(key);

    if (raw.isEmpty) return <T>[];

    try {
      final dynamic decoded = jsonDecode(raw);

      if (decoded is! List) return <T>[];

      return decoded.whereType<Map<String, dynamic>>().map(fromJson).toList();
    } catch (error) {
      debugPrint('Cache read failed for "$key": $error');

      await _prefs.remove(key);

      return <T>[];
    }
  }

  Future<void> cacheData<T>({
    required List<T> data,
    required String key,
    required Map<String, dynamic> Function(T item) toJson,
  }) async {
    try {
      await _prefs.setString(key, jsonEncode(data.map(toJson).toList()));
    } catch (error) {
      debugPrint('Cache write failed for "$key": $error');
    }
  }

  Future<void> clear(String key) => _prefs.remove(key);
}
