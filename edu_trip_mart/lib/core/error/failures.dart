/// 실패 타입 정의
/// 애플리케이션에서 발생할 수 있는 다양한 실패 상황을 정의
abstract class Failure {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;

  @override
  String toString() => 'Failure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// 서버 실패
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

/// 네트워크 실패
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

/// 캐시 실패
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

/// 인증 실패
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });
}

/// 권한 실패
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
  });
}

/// 유효성 검사 실패
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// 데이터 없음 실패
class NoDataFailure extends Failure {
  const NoDataFailure({
    required super.message,
    super.code,
  });
}

/// 타임아웃 실패
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.code,
  });
}

/// 알 수 없는 실패
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
  });
}

/// 실패 메시지 상수
class FailureMessages {
  // 일반적인 메시지
  static const String somethingWentWrong = '알 수 없는 오류가 발생했습니다';
  static const String networkError = '네트워크 연결을 확인해주세요';
  static const String serverError = '서버 오류가 발생했습니다';
  static const String timeoutError = '요청 시간이 초과되었습니다';
  static const String noDataError = '데이터를 찾을 수 없습니다';
  
  // 인증 관련 메시지
  static const String authError = '인증이 필요합니다';
  static const String permissionError = '접근 권한이 없습니다';
  static const String sessionExpired = '세션이 만료되었습니다';
  
  // 데이터 관련 메시지
  static const String cacheError = '캐시 오류가 발생했습니다';
  static const String validationError = '입력 데이터가 올바르지 않습니다';
  static const String parseError = '데이터 파싱 오류가 발생했습니다';
  
  // API 관련 메시지
  static const String apiError = 'API 호출 중 오류가 발생했습니다';
  static const String notFoundError = '요청한 리소스를 찾을 수 없습니다';
  static const String conflictError = '데이터 충돌이 발생했습니다';
  static const String rateLimitError = '요청 한도를 초과했습니다';
  
  // 캠프 관련 메시지
  static const String campNotFound = '캠프를 찾을 수 없습니다';
  static const String campLoadError = '캠프 정보를 불러오는데 실패했습니다';
  static const String campSearchError = '캠프 검색에 실패했습니다';
  static const String campCategoryError = '카테고리 정보를 불러오는데 실패했습니다';
  
  // 검색 관련 메시지
  static const String searchError = '검색에 실패했습니다';
  static const String searchEmpty = '검색 결과가 없습니다';
  static const String searchHistoryError = '검색 히스토리를 불러오는데 실패했습니다';
  
  // 즐겨찾기 관련 메시지
  static const String favoriteError = '즐겨찾기 설정에 실패했습니다';
  static const String favoriteLoadError = '즐겨찾기 목록을 불러오는데 실패했습니다';
  
  // 리뷰 관련 메시지
  static const String reviewError = '리뷰 처리 중 오류가 발생했습니다';
  static const String reviewLoadError = '리뷰를 불러오는데 실패했습니다';
  static const String reviewCreateError = '리뷰 작성에 실패했습니다';
  
  // 예약 관련 메시지
  static const String bookingError = '예약 처리 중 오류가 발생했습니다';
  static const String bookingLoadError = '예약 정보를 불러오는데 실패했습니다';
  static const String bookingCreateError = '예약 생성에 실패했습니다';
  static const String bookingCancelError = '예약 취소에 실패했습니다';
}
