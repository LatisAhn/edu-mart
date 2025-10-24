import 'failures.dart';

/// 결과 타입 정의
/// 성공 또는 실패를 나타내는 제네릭 결과 타입
sealed class Result<T> {
  const Result();

  /// 성공 여부 확인
  bool get isSuccess => this is Success<T>;
  
  /// 실패 여부 확인
  bool get isFailure => this is FailureResult<T>;
  
  /// 성공 데이터 반환 (실패 시 null)
  T? get data => isSuccess ? (this as Success<T>).data : null;
  
  /// 실패 정보 반환 (성공 시 null)
  Failure? get failure => isFailure ? (this as FailureResult<T>).failure : null;
  
  /// 성공 시 콜백 실행
  Result<T> onSuccess(Function(T data) callback) {
    if (isSuccess) {
      callback((this as Success<T>).data);
    }
    return this;
  }
  
  /// 실패 시 콜백 실행
  Result<T> onFailure(Function(Failure failure) callback) {
    if (isFailure) {
      callback((this as FailureResult<T>).failure);
    }
    return this;
  }
  
  /// 데이터 변환
  Result<R> map<R>(R Function(T data) mapper) {
    if (isSuccess) {
      try {
        return Success(mapper((this as Success<T>).data));
      } catch (e) {
        return FailureResult(UnknownFailure(
          message: '알 수 없는 오류가 발생했습니다: $e',
        ));
      }
    } else {
      return FailureResult((this as FailureResult<T>).failure);
    }
  }
  
  /// 결과 변환
  Result<R> flatMap<R>(Result<R> Function(T data) mapper) {
    if (isSuccess) {
      return mapper((this as Success<T>).data);
    } else {
      return FailureResult((this as FailureResult<T>).failure);
    }
  }
  
  /// 기본값 반환
  T getOrElse(T defaultValue) {
    return isSuccess ? (this as Success<T>).data : defaultValue;
  }
  
  /// 예외 발생
  T getOrThrow() {
    if (isSuccess) {
      return (this as Success<T>).data;
    } else {
      throw Exception((this as FailureResult<T>).failure.message);
    }
  }
}

/// 성공 결과
class Success<T> extends Result<T> {
  @override
  final T data;
  
  const Success(this.data);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.data == data;
  }
  
  @override
  int get hashCode => data.hashCode;
  
  @override
  String toString() => 'Success($data)';
}

/// 실패 결과
class FailureResult<T> extends Result<T> {
  @override
  final Failure failure;
  
  const FailureResult(this.failure);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FailureResult<T> && other.failure == failure;
  }
  
  @override
  int get hashCode => failure.hashCode;
  
  @override
  String toString() => 'FailureResult($failure)';
  
  /// 예외로부터 FailureResult 생성
  factory FailureResult.fromException(dynamic exception) {
    if (exception is Failure) {
      return FailureResult(exception);
    } else {
      return FailureResult(UnknownFailure(
        message: '알 수 없는 오류가 발생했습니다: $exception',
      ));
    }
  }
}

/// Result 확장 메서드
extension ResultExtensions<T> on Result<T> {
  /// 성공 시 데이터 반환, 실패 시 기본값 반환
  T getOrDefault(T defaultValue) {
    return isSuccess ? data! : defaultValue;
  }
  
  /// 성공 시 데이터 반환, 실패 시 null 반환
  T? getOrNull() {
    return isSuccess ? data : null;
  }
  
  /// 성공 시 데이터 반환, 실패 시 예외 발생
  T getOrThrow() {
    if (isSuccess) {
      return data!;
    } else {
      throw Exception(failure!.message);
    }
  }
  
  /// 성공 시 데이터 반환, 실패 시 함수 실행
  T getOrElse(T Function() defaultValue) {
    return isSuccess ? data! : defaultValue();
  }
  
  /// 성공 시 데이터 반환, 실패 시 함수 실행
  T getOrElseWith(Failure failure, T Function(Failure) defaultValue) {
    return isSuccess ? data! : defaultValue(failure);
  }
}