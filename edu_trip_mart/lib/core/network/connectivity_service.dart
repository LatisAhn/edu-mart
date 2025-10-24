import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

/// 연결 상태 서비스
/// 네트워크 연결 상태를 모니터링하고 관리
class ConnectivityService {
  final Connectivity _connectivity;
  ConnectivityResult _currentStatus = ConnectivityResult.none;

  ConnectivityService({required Connectivity connectivity})
      : _connectivity = connectivity;

  /// 현재 연결 상태
  ConnectivityResult get currentStatus => _currentStatus;

  /// 연결 상태 스트림
  Stream<ConnectivityResult> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  /// 연결 상태 초기화
  Future<void> initialize() async {
    _currentStatus = await _connectivity.checkConnectivity();
  }

  /// 현재 연결 상태 확인
  Future<ConnectivityResult> checkConnectivity() async {
    _currentStatus = await _connectivity.checkConnectivity();
    return _currentStatus;
  }

  /// 인터넷 연결 여부 확인
  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// WiFi 연결 여부 확인
  bool get isWifiConnected => _currentStatus == ConnectivityResult.wifi;

  /// 모바일 데이터 연결 여부 확인
  bool get isMobileConnected => _currentStatus == ConnectivityResult.mobile;

  /// 이더넷 연결 여부 확인
  bool get isEthernetConnected => _currentStatus == ConnectivityResult.ethernet;

  /// 연결됨 여부 확인
  bool get isConnected => _currentStatus != ConnectivityResult.none;

  /// 연결 안됨 여부 확인
  bool get isDisconnected => _currentStatus == ConnectivityResult.none;

  /// 연결 상태 문자열 반환
  String get connectionStatusString {
    switch (_currentStatus) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return '모바일 데이터';
      case ConnectivityResult.ethernet:
        return '이더넷';
      case ConnectivityResult.bluetooth:
        return '블루투스';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return '기타';
      case ConnectivityResult.none:
        return '연결 없음';
    }
  }

  /// 연결 상태에 따른 메시지 반환
  String get connectionMessage {
    if (isConnected) {
      return '인터넷에 연결되어 있습니다 ($connectionStatusString)';
    } else {
      return '인터넷 연결을 확인해주세요';
    }
  }

  /// 연결 상태에 따른 색상 반환
  String get connectionColor {
    if (isConnected) {
      return '#4CAF50'; // 녹색
    } else {
      return '#F44336'; // 빨간색
    }
  }

  /// 연결 상태에 따른 아이콘 반환
  String get connectionIcon {
    switch (_currentStatus) {
      case ConnectivityResult.wifi:
        return 'wifi';
      case ConnectivityResult.mobile:
        return 'signal_cellular_4_bar';
      case ConnectivityResult.ethernet:
        return 'ethernet';
      case ConnectivityResult.bluetooth:
        return 'bluetooth';
      case ConnectivityResult.vpn:
        return 'vpn_key';
      case ConnectivityResult.other:
        return 'network_check';
      case ConnectivityResult.none:
        return 'wifi_off';
    }
  }

  /// 연결 상태 변경 리스너 등록
  void addConnectivityListener(Function(ConnectivityResult) listener) {
    _connectivity.onConnectivityChanged.listen(listener);
  }

  /// 연결 상태 변경 리스너 제거
  void removeConnectivityListener() {
    // StreamSubscription을 저장하고 취소하는 방식으로 구현
    // 실제 구현에서는 StreamSubscription을 관리해야 함
  }

  /// 연결 상태 디버그 정보
  Map<String, dynamic> get debugInfo {
    return {
      'current_status': _currentStatus.toString(),
      'is_connected': isConnected,
      'is_wifi': isWifiConnected,
      'is_mobile': isMobileConnected,
      'is_ethernet': isEthernetConnected,
      'connection_string': connectionStatusString,
      'connection_message': connectionMessage,
      'connection_color': connectionColor,
      'connection_icon': connectionIcon,
    };
  }
}
