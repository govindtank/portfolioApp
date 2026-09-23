import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'visitor_storage_io.dart' if (dart.library.html) 'visitor_storage_web.dart' as storage;

/// Service for tracking visitor counts and telemetry across Web and Mobile
/// Integrates privacy-first GoatCounter analytics + persistent local cache
class VisitorCounterService {
  static const String _visitorCountKey = 'visitor_count';
  static const String _lastVisitKey = 'last_visit_date';
  static const String _visitorIdKey = 'visitor_id';
  static const String _goatCounterBase = 'https://govindtank.goatcounter.com/count';

  int? _cachedCount;

  /// Ping GoatCounter endpoint for analytics (fire-and-forget, zero latency hit)
  static Future<void> trackPageView(String path, {String? title}) async {
    try {
      final normalizedPath = path.startsWith('/') ? path : '/$path';
      final uri = Uri.parse(_goatCounterBase).replace(queryParameters: {
        'p': '/app$normalizedPath',
        't': title ?? 'Portfolio App $normalizedPath',
      });

      await http.get(
        uri,
        headers: {
          'User-Agent': 'GovindTankPortfolioApp/2.0 (Mobile)',
        },
      ).timeout(const Duration(seconds: 4));
    } catch (e) {
      debugPrint('[Analytics] Telemetry ping skipped or offline: $e');
    }
  }

  /// Get the current visitor count
  Future<int> getVisitorCount() async {
    final value = await storage.getInt(_visitorCountKey);
    _cachedCount = value ?? 0;
    return _cachedCount!;
  }

  /// Increment the visitor count
  /// Tracks app launch both in local storage and sends view ping to GoatCounter
  Future<int> incrementVisitorCount({String path = '/home', String title = 'App Launch'}) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastVisit = await storage.getString(_lastVisitKey);

    int count = (await storage.getInt(_visitorCountKey)) ?? 0;

    if (lastVisit == null || lastVisit != today) {
      count++;
      await storage.setInt(_visitorCountKey, count);
      await storage.setString(_lastVisitKey, today);
    }

    _cachedCount = count;

    // Send analytics ping asynchronously
    unawaited(trackPageView(path, title: title));

    return count;
  }

  /// Force increment (for testing or manual counter management)
  Future<int> forceIncrement() async {
    int count = ((await storage.getInt(_visitorCountKey)) ?? 0) + 1;
    await storage.setInt(_visitorCountKey, count);
    _cachedCount = count;
    return count;
  }

  /// Reset the visitor count
  Future<void> resetCount() async {
    await storage.remove(_visitorCountKey);
    await storage.remove(_lastVisitKey);
    await storage.remove(_visitorIdKey);
    _cachedCount = 0;
  }

  /// Get cached count without fetching from storage
  int? getCachedCount() {
    return _cachedCount;
  }
}
