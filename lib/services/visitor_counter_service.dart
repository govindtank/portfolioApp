import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'visitor_storage_io.dart' if (dart.library.html) 'visitor_storage_web.dart' as storage;

/// Service for tracking visitor counts and telemetry across Web and Mobile
/// Integrates live GoatCounter analytics API + persistent local cache
class VisitorCounterService {
  static const String _visitorCountKey = 'visitor_count';
  static const String _lastVisitKey = 'last_visit_date';
  static const String _goatCounterBase = 'https://govindtank.goatcounter.com/count';
  static const String _goatCounterApi = 'https://govindtank.goatcounter.com/counter/TOTAL.json';

  static int? _cachedLiveCount;

  /// Ping GoatCounter endpoint for analytics (fire-and-forget, non-blocking)
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

  /// Get the live verified visitor count from GoatCounter with offline fallback
  Future<int> getVisitorCount() async {
    // 1. If already cached in memory, return immediately
    if (_cachedLiveCount != null && _cachedLiveCount! > 0) {
      return _cachedLiveCount!;
    }

    // 2. Fetch live count from GoatCounter JSON API
    try {
      final res = await http.get(Uri.parse(_goatCounterApi)).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        final rawCount = data['count'] ?? data['count_unique'] ?? '0';
        final parsed = int.tryParse(rawCount.toString()) ?? 0;
        if (parsed > 0) {
          _cachedLiveCount = parsed;
          await storage.setInt(_visitorCountKey, parsed);
          return parsed;
        }
      }
    } catch (e) {
      debugPrint('[Analytics] Live counter fetch fallback to local: $e');
    }

    // 3. Fallback to persisted local storage count
    final localVal = await storage.getInt(_visitorCountKey);
    _cachedLiveCount = (localVal != null && localVal > 0) ? localVal : 220;
    return _cachedLiveCount!;
  }

  /// Increment the visitor count
  /// Records launch, increments local daily count, and pings telemetry
  Future<int> incrementVisitorCount({String path = '/home', String title = 'App Launch'}) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastVisit = await storage.getString(_lastVisitKey);

    // Send analytics ping asynchronously
    unawaited(trackPageView(path, title: title));

    // Fetch live count
    int liveCount = await getVisitorCount();

    if (lastVisit == null || lastVisit != today) {
      liveCount++;
      _cachedLiveCount = liveCount;
      await storage.setInt(_visitorCountKey, liveCount);
      await storage.setString(_lastVisitKey, today);
    }

    return liveCount;
  }

  /// Get cached count without fetching from network
  int? getCachedCount() {
    return _cachedLiveCount;
  }
}
