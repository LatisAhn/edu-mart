import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'failures.dart';

/// 에러 핸들러
/// 다양한 예외를 적절한 Failure 객체로 변환
class ErrorHandler {
  /// 예외를 Failure로 변환
  static Failure handleException(dynamic exception) {
    if (exception is SocketException) {
      return NetworkFailure(
        message: FailureMessages.networkError,
        code: 0,
      );
    } else if (exception is HttpException) {
      return ServerFailure(
        message: FailureMessages.serverError,
        code: 0,
      );
    } else if (exception is FormatException) {
      return ValidationFailure(
        message: FailureMessages.parseError,
        code: 0,
      );
    } else if (exception is TimeoutException) {
      return TimeoutFailure(
        message: FailureMessages.timeoutError,
        code: 0,
      );
    } else if (exception is NoSuchMethodError) {
      return ValidationFailure(
        message: FailureMessages.validationError,
        code: 0,
      );
    } else if (exception is ArgumentError) {
      return ValidationFailure(
        message: FailureMessages.validationError,
        code: 0,
      );
    } else if (exception is StateError) {
      return CacheFailure(
        message: FailureMessages.cacheError,
        code: 0,
      );
    } else {
      return UnknownFailure(
        message: FailureMessages.somethingWentWrong,
        code: 0,
      );
    }
  }

  /// HTTP 응답을 Failure로 변환
  static Failure handleHttpResponse(http.Response response) {
    final statusCode = response.statusCode;
    final message = _getErrorMessage(statusCode);

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: message,
          code: statusCode,
        );
      case 401:
        return AuthFailure(
          message: message,
          code: statusCode,
        );
      case 403:
        return PermissionFailure(
          message: message,
          code: statusCode,
        );
      case 404:
        return NoDataFailure(
          message: message,
          code: statusCode,
        );
      case 408:
        return TimeoutFailure(
          message: message,
          code: statusCode,
        );
      case 409:
        return ValidationFailure(
          message: message,
          code: statusCode,
        );
      case 429:
        return ServerFailure(
          message: message,
          code: statusCode,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: message,
          code: statusCode,
        );
      default:
        return ServerFailure(
          message: message,
          code: statusCode,
        );
    }
  }

  /// 상태 코드에 따른 에러 메시지 반환
  static String _getErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return '잘못된 요청입니다';
      case 401:
        return '인증이 필요합니다';
      case 403:
        return '접근 권한이 없습니다';
      case 404:
        return '요청한 리소스를 찾을 수 없습니다';
      case 408:
        return '요청 시간이 초과되었습니다';
      case 409:
        return '데이터 충돌이 발생했습니다';
      case 429:
        return '요청 한도를 초과했습니다';
      case 500:
        return '서버 내부 오류가 발생했습니다';
      case 502:
        return '게이트웨이 오류가 발생했습니다';
      case 503:
        return '서비스를 사용할 수 없습니다';
      case 504:
        return '게이트웨이 시간 초과가 발생했습니다';
      default:
        return '오류가 발생했습니다 (상태 코드: $statusCode)';
    }
  }

  /// 네트워크 연결 상태 확인
  static bool isNetworkAvailable() {
    try {
      // 간단한 네트워크 연결 확인
      return true; // 실제 구현에서는 네트워크 상태를 확인
    } catch (e) {
      return false;
    }
  }

  /// 에러 로깅
  static void logError(String context, dynamic error, [StackTrace? stackTrace]) {
    // 실제 구현에서는 로깅 서비스 사용
    print('Error in $context: $error');
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }
  }

  /// 사용자 친화적인 에러 메시지 생성
  static String getUserFriendlyMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return '인터넷 연결을 확인하고 다시 시도해주세요';
      case ServerFailure:
        return '서버에 일시적인 문제가 발생했습니다. 잠시 후 다시 시도해주세요';
      case TimeoutFailure:
        return '요청 시간이 초과되었습니다. 네트워크 상태를 확인하고 다시 시도해주세요';
      case AuthFailure:
        return '로그인이 필요합니다';
      case PermissionFailure:
        return '접근 권한이 없습니다';
      case ValidationFailure:
        return '입력 정보를 확인하고 다시 시도해주세요';
      case NoDataFailure:
        return '요청한 정보를 찾을 수 없습니다';
      case CacheFailure:
        return '데이터를 불러오는데 문제가 발생했습니다';
      default:
        return '알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요';
    }
  }

  /// 재시도 가능한 에러인지 확인
  static bool isRetryableError(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
      case TimeoutFailure:
      case ServerFailure:
        return true;
      case AuthFailure:
      case PermissionFailure:
      case ValidationFailure:
      case NoDataFailure:
      case CacheFailure:
      case UnknownFailure:
        return false;
      default:
        return false;
    }
  }

  /// 에러 발생 시 재시도 지연 시간 계산
  static Duration getRetryDelay(int attemptCount) {
    // 지수 백오프: 1초, 2초, 4초, 8초...
    final delay = Duration(seconds: 1 << (attemptCount - 1));
    return delay > const Duration(seconds: 30) 
        ? const Duration(seconds: 30) 
        : delay;
  }
}
