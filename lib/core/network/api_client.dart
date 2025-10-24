import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/failures.dart';
import '../error/result.dart';

/// API 클라이언트
/// HTTP 요청을 처리하는 중앙화된 클라이언트
class ApiClient {
  final http.Client _client;
  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final Duration timeout;

  ApiClient({
    required http.Client client,
    required this.baseUrl,
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    this.timeout = const Duration(seconds: 30),
  }) : _client = client;

  /// GET 요청
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final response = await _client
          .get(uri, headers: _mergeHeaders(headers))
          .timeout(timeout);

      return _handleResponse(response, parser);
    } catch (e) {
      return FailureResult(_handleException(e));
    }
  }

  /// POST 요청
  Future<Result<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final uri = _buildUri(path);
      final response = await _client
          .post(
            uri,
            headers: _mergeHeaders(headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response, parser);
    } catch (e) {
      return FailureResult(_handleException(e));
    }
  }

  /// PUT 요청
  Future<Result<T>> put<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final uri = _buildUri(path);
      final response = await _client
          .put(
            uri,
            headers: _mergeHeaders(headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response, parser);
    } catch (e) {
      return FailureResult(_handleException(e));
    }
  }

  /// PATCH 요청
  Future<Result<T>> patch<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final uri = _buildUri(path);
      final response = await _client
          .patch(
            uri,
            headers: _mergeHeaders(headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response, parser);
    } catch (e) {
      return FailureResult(_handleException(e));
    }
  }

  /// DELETE 요청
  Future<Result<T>> delete<T>(
    String path, {
    Map<String, String>? headers,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final uri = _buildUri(path);
      final response = await _client
          .delete(uri, headers: _mergeHeaders(headers))
          .timeout(timeout);

      return _handleResponse(response, parser);
    } catch (e) {
      return FailureResult(_handleException(e));
    }
  }

  /// URI 빌드
  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final uri = Uri.parse('$baseUrl$path');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters.map(
        (key, value) => MapEntry(key, value.toString()),
      ));
    }
    return uri;
  }

  /// 헤더 병합
  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    return {...defaultHeaders, ...?headers};
  }

  /// 응답 처리
  Result<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic json) parser,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final dynamic jsonResponse = json.decode(response.body);
        return Success(parser(jsonResponse));
      } catch (e) {
        return FailureResult(ServerFailure(
          message: '응답 파싱에 실패했습니다: $e',
        ));
      }
    } else {
      return FailureResult(_handleHttpError(response));
    }
  }

  /// HTTP 오류 처리
  Failure _handleHttpError(http.Response response) {
    try {
      final errorBody = json.decode(response.body);
      final message = errorBody['message'] ?? errorBody['error'] ?? '서버 오류가 발생했습니다.';
      
      switch (response.statusCode) {
        case 400:
          return ServerFailure(message: message);
        case 401:
          return ServerFailure(message: message);
        case 403:
          return ServerFailure(message: message);
        case 404:
          return ServerFailure(message: message);
        case 500:
          return ServerFailure(message: message);
        default:
          return ServerFailure(message: message);
      }
    } catch (e) {
      return ServerFailure(
        message: '서버 오류가 발생했습니다. (${response.statusCode})',
      );
    }
  }

  /// 예외 처리
  Failure _handleException(dynamic exception) {
    if (exception is http.ClientException) {
      return NetworkFailure(message: '네트워크 연결을 확인해주세요.');
    } else if (exception is FormatException) {
      return ServerFailure(message: '응답 형식이 올바르지 않습니다.');
    } else {
      return UnknownFailure(message: '알 수 없는 오류가 발생했습니다: $exception');
    }
  }

  /// 리소스 정리
  void dispose() {
    _client.close();
  }
}