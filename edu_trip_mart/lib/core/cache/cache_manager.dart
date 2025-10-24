import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../error/failures.dart' as failures;
import '../error/result.dart';

/// 캐시 관리자
/// 로컬 캐시 데이터를 관리하는 중앙화된 매니저
class CacheManager {
  final SharedPreferences _preferences;
  static const String _cachePrefix = 'cache_';
  static const String _timestampPrefix = 'timestamp_';
  static const Duration _defaultExpiry = Duration(hours: 24);

  CacheManager({required SharedPreferences preferences})
      : _preferences = preferences;

  /// 데이터 캐시 저장
  Future<Result<void>> cacheData<T>(
    String key,
    T data, {
    Duration? expiry,
  }) async {
    try {
      final jsonString = jsonEncode(data);
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_timestampPrefix$key';
      final expiryDuration = expiry ?? _defaultExpiry;
      final expiryTime = DateTime.now().add(expiryDuration).millisecondsSinceEpoch;

      await _preferences.setString(cacheKey, jsonString);
      await _preferences.setInt(timestampKey, expiryTime);

      return const Success(null);
    } catch (e) {
      return FailureResult(failures.CacheFailure(
        message: '캐시 저장에 실패했습니다: $e',
      ));
    }
  }

  /// 캐시된 데이터 조회
  Future<Result<T>> getCachedData<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_timestampPrefix$key';

      // 캐시 데이터 확인
      final cachedData = _preferences.getString(cacheKey);
      if (cachedData == null) {
        return FailureResult(failures.NoDataFailure(
          message: '캐시된 데이터가 없습니다',
        ));
      }

      // 만료 시간 확인
      final expiryTime = _preferences.getInt(timestampKey);
      if (expiryTime != null && DateTime.now().millisecondsSinceEpoch > expiryTime) {
        // 만료된 데이터 삭제
        await _preferences.remove(cacheKey);
        await _preferences.remove(timestampKey);
        return FailureResult(failures.NoDataFailure(
          message: '캐시가 만료되었습니다',
        ));
      }

      // JSON 파싱
      final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
      final data = fromJson(jsonData);

      return Success(data);
    } catch (e) {
      return FailureResult(failures.CacheFailure(
        message: '캐시 조회에 실패했습니다: $e',
      ));
    }
  }

  /// 캐시된 데이터 목록 조회
  Future<Result<List<T>>> getCachedDataList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_timestampPrefix$key';

      // 캐시 데이터 확인
      final cachedData = _preferences.getString(cacheKey);
      if (cachedData == null) {
        return FailureResult(failures.NoDataFailure(
          message: '캐시된 데이터가 없습니다',
        ));
      }

      // 만료 시간 확인
      final expiryTime = _preferences.getInt(timestampKey);
      if (expiryTime != null && DateTime.now().millisecondsSinceEpoch > expiryTime) {
        // 만료된 데이터 삭제
        await _preferences.remove(cacheKey);
        await _preferences.remove(timestampKey);
        return FailureResult(failures.NoDataFailure(
          message: '캐시가 만료되었습니다',
        ));
      }

      // JSON 파싱
      final jsonData = jsonDecode(cachedData) as List<dynamic>;
      final dataList = jsonData
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();

      return Success(dataList);
    } catch (e) {
      return FailureResult(failures.CacheFailure(
        message: '캐시 조회에 실패했습니다: $e',
      ));
    }
  }

  /// 캐시 데이터 삭제
  Future<Result<void>> removeCachedData(String key) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_timestampPrefix$key';

      await _preferences.remove(cacheKey);
      await _preferences.remove(timestampKey);

      return const Success(null);
    } catch (e) {
      return FailureResult(failures.CacheFailure(
        message: '캐시 삭제에 실패했습니다: $e',
      ));
    }
  }

  /// 모든 캐시 데이터 삭제
  Future<Result<void>> clearAllCache() async {
    try {
      final keys = _preferences.getKeys();
      final cacheKeys = keys
          .where((key) => key.startsWith(_cachePrefix) || key.startsWith(_timestampPrefix))
          .toList();

      for (final key in cacheKeys) {
        await _preferences.remove(key);
      }

      return const Success(null);
    } catch (e) {
      return FailureResult(failures.CacheFailure(
        message: '캐시 전체 삭제에 실패했습니다: $e',
      ));
    }
  }

  /// 만료된 캐시 데이터 정리
  Future<Result<void>> cleanExpiredCache() async {
    try {
      final keys = _preferences.getKeys();
      final now = DateTime.now().millisecondsSinceEpoch;
      final expiredKeys = <String>[];

      for (final key in keys) {
        if (key.startsWith(_timestampPrefix)) {
          final expiryTime = _preferences.getInt(key);
          if (expiryTime != null && now > expiryTime) {
            final dataKey = key.replaceFirst(_timestampPrefix, _cachePrefix);
            expiredKeys.addAll([key, dataKey]);
          }
        }
      }

      for (final key in expiredKeys) {
        await _preferences.remove(key);
      }

      return const Success(null);
    } catch (e) {
      return FailureResult(failures.CacheFailure(
        message: '만료된 캐시 정리에 실패했습니다: $e',
      ));
    }
  }

  /// 캐시 상태 확인
  Future<Result<Map<String, dynamic>>> getCacheStatus() async {
    try {
      final keys = _preferences.getKeys();
      final cacheKeys = keys
          .where((key) => key.startsWith(_cachePrefix))
          .toList();

      final status = <String, dynamic>{
        'total_cached_items': cacheKeys.length,
        'cache_size_bytes': 0,
        'expired_items': 0,
        'valid_items': 0,
      };

      final now = DateTime.now().millisecondsSinceEpoch;

      for (final key in cacheKeys) {
        final dataKey = key;
        final timestampKey = key.replaceFirst(_cachePrefix, _timestampPrefix);
        final expiryTime = _preferences.getInt(timestampKey);

        if (expiryTime != null) {
          if (now > expiryTime) {
            status['expired_items'] = (status['expired_items'] as int) + 1;
          } else {
            status['valid_items'] = (status['valid_items'] as int) + 1;
          }
        }

        // 캐시 크기 계산 (대략적)
        final cachedData = _preferences.getString(dataKey);
        if (cachedData != null) {
          status['cache_size_bytes'] = (status['cache_size_bytes'] as int) + cachedData.length;
        }
      }

      return Success(status);
    } catch (e) {
      return FailureResult(failures.CacheFailure(
        message: '캐시 상태 조회에 실패했습니다: $e',
      ));
    }
  }

  /// 특정 키의 캐시 존재 여부 확인
  bool hasCachedData(String key) {
    final cacheKey = '$_cachePrefix$key';
    return _preferences.containsKey(cacheKey);
  }

  /// 특정 키의 캐시 만료 여부 확인
  bool isCacheExpired(String key) {
    final timestampKey = '$_timestampPrefix$key';
    final expiryTime = _preferences.getInt(timestampKey);
    
    if (expiryTime == null) return true;
    
    return DateTime.now().millisecondsSinceEpoch > expiryTime;
  }

  /// 캐시 키 생성
  String generateCacheKey(String baseKey, Map<String, dynamic>? parameters) {
    if (parameters == null || parameters.isEmpty) {
      return baseKey;
    }

    final sortedParams = Map.fromEntries(
      parameters.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    final paramString = sortedParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    return '$baseKey?$paramString';
  }
}
