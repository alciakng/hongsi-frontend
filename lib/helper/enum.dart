/* ------------------------------------------------------------------------------------------------
이   름 : enum.dart
기   능 : 각 화면에서 쓰이는 enum 정의
참고사항 : 1) 
수정이력 : 1) 2022/05/17  [김종환]  최초 작성
--------------------------------------------------------------------------------------------------- */

/// 현재 계정 로그인 상태
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  LOGGED_IN_WITH_ABNOMAL_EXIT
}

/// 페이지 라우트 이름
enum RouteName {
  SPLASH,
  SIGNUP,
  SEARCH_FAMILY,
  EDIT_FAMILY,
  EDIT_ANNIVERSARY,
  FAMILY_NOTIFICATION
}

/// 홍시등급
enum Grade { S, A, B, C, D, E }

/// 홍시레벨
enum Level { ONE, TWO, THREE, FOUR, FIVE }

/// 가입채널
enum Channel { KAKAO, GOOGLE, NAVER, EMAIL, NONE }

/// 가족 or 유저 구분타입
enum PickerType { FAMILY_CHOOSE, USER_CHOOSE, NEIGHBOR_REQUEST, FAMILY_REQUEST }

/// 알림 타입
enum NotificationType {
  ALL('전체', 0),
  NORMAL('알람', 1),
  NEIGHBOR_REQUEST('이웃요청', 2),
  FAMILY_REQEST('가족요청', 3);

  final String type;
  final int num;
  const NotificationType(this.type, this.num);

  factory NotificationType.getByName(String name) {
    return NotificationType.values.firstWhere((value) => value.name == name,
        orElse: () => NotificationType.NORMAL);
  }

  factory NotificationType.getByNum(int num) {
    return NotificationType.values.firstWhere((value) => value.num == num,
        orElse: () => NotificationType.NORMAL);
  }
}

// 이웃신청 처리상태 구분
enum NeighborState {
  SEND_REQUEST('이웃신청 보냄'),
  RECEIVE_REQUEST('나에게 이웃신청'),
  APPROVE('이웃'),
  DISPOSAL('이웃거절'),
  NONE('NONE');

  final String state;
  const NeighborState(this.state);

  factory NeighborState.getByName(String name) {
    return NeighborState.values.firstWhere((value) => value.name == name,
        orElse: () => NeighborState.NONE);
  }
}
