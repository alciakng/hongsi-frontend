import 'dart:async';
import 'dart:convert';

// [firebase 플러그인]
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as db;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

// [cloud function]
import 'package:cloud_functions/cloud_functions.dart';

// [기본  state 관리]
import 'package:hongsi_project/state/app_state.dart';

// [소셜 로그인 플러그인]
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao_sdk;

// [기본]
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// [참조]
import 'package:hongsi_project/helper/enum.dart';
import 'package:hongsi_project/helper/shared_preference_helper.dart';
import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/model/user_model.dart';
import 'package:hongsi_project/helper/locator.dart';
import 'package:provider/provider.dart';

// [페이지 이동을 위한 참조] - GoRouter 도입으로 사용하지 않음
//import 'package:hongsi_project/routes/route_manager.dart' show RouteManager;
//import 'package:hongsi_project/routes/route_path.dart';

// [http]
import 'package:http/http.dart' as http;

import '../model/notify_model.dart';

/// AuthState
/// 로그인한 유저의 state management
class AuthState extends AppState {
  //User? user;  '23.04.25 firebase user 사용안함 -> Spring boot User를 받아오도록 처리
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  late bool aditInfoExisted;

  /// 알림리스트
  final List<NotifyModel> _notifyList = [];

  /// 구글로그인 (firebase 라이브러리 사용 )
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// 유저모델
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  /* [init] auth_state 변수설정
    - authStatus :현재 로그인상태 
    - uid : 현재유저의 uid 
    - user : 현재유저 (firebase user) -- '23.04.25 firebase user 사용안함 -> Spring boot User를 받아오도록 처리 
  */

  // 유저 프로파일 변경이벤트를 참조하기위한 스냅샷
  //late Stream<DocumentSnapshot>? _profileRef;

  // List<UserModel> _profileUserModelList;
  //UserModel? get profileUserModel => _userModel;
  /* [init] Firebase 초기화  - '23.04.25 firebase user 사용안함 -> Spring boot User를 받아오도록 처리 
    - firebaseMessaging
    - firebaseAuth
    - firebaseStorage
    - googleSignIn
  */
  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  /*----------------------------------------------------------------
    - 함수 : clearVariable
    - 기능 : 변수를 초기화한다.
    - @param {} 
    - @return {} 
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
            2023.04.23 / 김종환 / user, _profileRef 주석처리
    ----------------------------------------------------------------*/
  void clearVariable() {
    //user = null;
    //_profileRef = null;
    _userModel = null;
  }

  /*---------------------------------
    [func] logoutCallback - 로그아웃 
    - googleSignIn signOut
    - kakaoSiginIn signOut
    - firebaseAuth signOut
    - SharedPreferenceHelper clear 
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
  -----------------------------------*/
  Future<void> logoutCallback() async {
    // 로그인하지 않은 상태로 변경
    authStatus = AuthStatus.NOT_LOGGED_IN;
    // 유저관련 변수 clear
    clearVariable();

    /// SharedPreference 초기화 (userModel 정보, accessToken 정보, refreshToken 정보 모두 삭제)
    await getIt<SharedPreferenceHelper>().clearPreferenceValues();
    // authState notify
    notifyListeners();

    /* 소셜 채널에 따른 로그아웃
    switch (_userModel!.channel) {
      case Channel.KAKAO:
        await kakao_sdk.UserApi.instance.logout();
        break;
      case Channel.GOOGLE:
        await _googleSignIn.signOut();
        break;
      case Channel.NAVER:
        break;
      default:
    }*/

    /// 파이어베이스 로그아웃
    //await _firebaseAuth.signOut();
  }

  /*----------------------------------------------------------------
    - 함수 : openSignUpPage
    - 기능 : 
    - @param {} 
    - @return {} 
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
    ----------------------------------------------------------------*/
  void openSignUpPage() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    notifyListeners();
  }

  /*----------------------------------------------------------------
    - 함수 : databaseInit
    - 기능 : 프로파일 변경이벤트를 등록한다.
    - @param {} 
    - @return {} 
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
            2023.04.23 / 김종환 / 프로파일 변경이벤트 삭제 
    ----------------------------------------------------------------*/
  void databaseInit() {
    try {
      /* 프로파일 변경이벤트 삭제 
      if (_profileRef == null) {
        _profileRef = firestore.collection('user').doc(user!.uid).snapshots();
        _profileRef!.listen(_onProfileChanged);
        //_profileQuery!.onChildChanged.listen(_onProfileUpdated);
      }*/

      // 유저 변경이벤트
      // databaseInit() 함수가 타 프로그램에서 한번 호출되어야 이벤트가 등록됨
      //_firebaseAuth.authStateChanges().listen((User? _user) async {});
    } catch (error) {
      //cprint(error, errorIn: 'databaseInit');
    }
  }

  /*----------------------------------------------------------------
    - 함수 : signIn
    - 기능 : email 로그인을 구현한다 
    - @param {String} email, password 
    - @return {String} u성공시 uid를 반환 
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
            2023.04.23 / 김종환 / firebase 로그인 폐지 
    ----------------------------------------------------------------*/
  Future<String?> signIn(String email, String password,
      {required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey}) async {
    try {
      isBusy = true;

      /* firebase 로그인 폐지  2023.04.23
      //var result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      //user = result.user;*/
      //uid = user!.uid;
      //return user!.uid;
    } on FirebaseException catch (error) {
      if (error.code == 'firebase_auth/user-not-found') {
        Utility.customSnackBar(
            scaffoldMessengerKey, '해당유저가 존재하지 않습니다. 이메일과 패스워드를 확인해주세요.');
      } else {
        Utility.customSnackBar(
          scaffoldMessengerKey,
          error.message ?? '로그인 중 오류가 발생했습니다. 네트워크 상태를 확인해주세요.',
        );
      }
      cprint(error, errorIn: 'signIn');
      return null;
    } catch (error) {
      Utility.customSnackBar(scaffoldMessengerKey, error.toString());
      cprint(error, errorIn: 'signIn');

      return null;
    } finally {
      isBusy = false;
    }
  }

  /*----------------------------------------------------------------
    - 함수 : handleKakaoSignIn
    - 기능 : Kakao 로그인기능을 구현한다. (내부에서 checkKakaoSignIn 함수 호출)
    - @param {}
    - @return {UserCredential}
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
            2023.04.21 / 김종환 / spring boot 를 통해 로그인 하는 방식으로 변경 
    ----------------------------------------------------------------*/
  Future<AuthStatus?> handleKakaoSignIn({
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  }) async {
    try {
      isBusy = true;

      final accessToken = await _retrieveToken();

      final parameters = jsonEncode({
        'provider': Channel.KAKAO.name,
        'accessToken': accessToken,
      });

      //localhost -> 10.0.2.2(android)
      final url = Uri.http(
          //'hongsi-env2.eba-cxnhz8ta.ap-northeast-2.elasticbeanstalk.com',
          'localhost:5000',
          '/oauth/login');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: parameters,
      );

      /* '23.4 firebase 방식의 로그인 사용안함 - spring boot restapi 호출 
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      */
      /*
      /// 유저정보 수정
      user = (await _firebaseAuth.signInWithCredential(credential)).user;
      uid = user!.uid;
      */

      final statusCode = response.statusCode;
      final jsonBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (statusCode == 200) {
        // tokenData 추출
        final tokenData = jsonBody['data'];

        // accessToken 및 refreshToken 저장
        await getIt<SharedPreferenceHelper>()
            .saveAccessToken(tokenData['accessToken']);
        await getIt<SharedPreferenceHelper>()
            .saveAccessToken(tokenData['refreshToken']);
        // 유저 프로파일 조회
        await getProfileUser(tokenData['accessToken']);

        // userModel이 null이 아닌경우
        if (_userModel != null) {
          // 로그인 성공
          authStatus = AuthStatus.LOGGED_IN;
        } else {
          // 로그인 안된상태
          authStatus = AuthStatus.NOT_LOGGED_IN;
        }
      } else {
        // 로그인 안된상태
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }

      // Social 로그인 유저생성 - 2022.07.25 / 김종환 / createUser 함수폐기
      // createUserFromSocialLogin();
      return authStatus;

      /* firebase 방식 주석처리 
      final authResult =
          await _firebaseAuth.signInWithCustomToken(await _verifyToken(token));

      final User? firebaseUser = authResult.user;
      assert(firebaseUser!.uid == _firebaseAuth.currentUser!.uid);
      

      if (authResult.user!.email == null || authResult.user!.email!.isEmpty) {
        /// 카카오 유저 정보 받아오기
        kakao_sdk.User kakaoUser = await kakao_sdk.UserApi.instance.me();

        /// 카카오 유저이메일이 null이거나 비어있을경우 이메일을 다시입력하도록 예외발생
        if ((kakaoUser.kakaoAccount!.email == null ||
            kakaoUser.kakaoAccount!.email!.isEmpty)) {
          throw Exception("로그인하기 위해서는 이메일을 반드시 입력하셔야 합니다.");
        }

        /// 이메일이 비워져 있지 않은경우, 이메일정보 업데이트
        if (kakaoUser.kakaoAccount!.email != null &&
            kakaoUser.kakaoAccount!.email!.isNotEmpty) {
          await authResult.user!.updateEmail(kakaoUser.kakaoAccount!.email!);
        }
      }
      */

      // 카카오로그인시 Exception 처리
    } on KakaoException catch (e) {
      Utility.customSnackBar(
          scaffoldMessengerKey, e.message ?? '카카오 로그인 오류가 발생했습니다.');
      cprint(e, errorIn: 'handleKakaoSignIn', uid: _userModel?.uid);
      //crashlytics 처리해야함

      return null;
      // custom 토큰 로그인 시 Exception 처리
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-custom-token":
          cprint(e, errorIn: 'handleKakaoSignIn', uid: _userModel?.uid);
          break;
        case "custom-token-mismatch":
          cprint(e, errorIn: 'handleKakaoSignIn', uid: _userModel?.uid);
          break;
        default:
          cprint(e, errorIn: 'handleKakaoSignIn', uid: _userModel?.uid);
      }

      return null;
    } catch (e) {
      if (e.toString().contains("already in use")) {
        Utility.customSnackBar(scaffoldMessengerKey, '해당 카카오 계정이 이미 사용중입니다.');
        cprint(e, errorIn: 'handleKakaoSignIn', uid: _userModel?.uid);
        //crashlytics 처리해야함
        return null;
      }

      if (e.toString().contains("User canceled login")) {
        Utility.customSnackBar(scaffoldMessengerKey, '유저가 카카오 로그인을 취소하였습니다.');
        cprint(e, errorIn: 'handleKakaoSignIn', uid: _userModel?.uid);
        //crashlytics 처리해야함

        return null;
      }

      Utility.customSnackBar(scaffoldMessengerKey, e.toString());
      cprint(e, errorIn: 'handleKakaoSignIn', uid: _userModel?.uid);

      return null;
    }
  }

  /*----------------------------------------------------------------
    - 함수 : _retrieveToken
    - 기능 : Kakao 토큰을 발행하고 저장한다.
    - @param {}
    - @return {String} token.accessToken
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
    ----------------------------------------------------------------*/

  Future<String> _retrieveToken() async {
    try {
      late OAuthToken token;

      if (await isKakaoTalkInstalled()) {
        try {
          token = await kakao_sdk.UserApi.instance.loginWithKakaoTalk();
          cprint('카카오톡으로 로그인 성공');
        } catch (error) {
          cprint('카카오톡으로 로그인 실패 $error');

          // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
          // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
          if (error is PlatformException && error.code == 'CANCELED') {
            return error.code;
          }
          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
          try {
            token = await kakao_sdk.UserApi.instance.loginWithKakaoAccount();
            cprint('카카오계정으로 로그인 성공');
          } catch (error) {
            cprint('카카오계정으로 로그인 실패 $error');
          }
        }
      } else {
        try {
          token = await kakao_sdk.UserApi.instance.loginWithKakaoAccount();
          cprint('카카오계정으로 로그인 성공');
        } catch (error) {
          cprint('카카오계정으로 로그인 실패 $error');
        }
      }

      /*  loginWithKakaoTalk(), loginWithKakaoAccount() 방식으로 변경 (AuthCode, AccessToekn, token Setting 과정을 한번에 처리)
      //authCode 발급 
      final authCode = installed
          ? await kakao_sdk.AuthCodeClient.instance.authorizeWithTalk()
          : await kakao_sdk.AuthCodeClient.instance.authorize();

      //authCode를 통한 AccessToken 발급
      final token =
          await kakao_sdk.AuthApi.instance.issueAccessToken(authCode: authCode);
      // token Setting 
      await kakao_sdk.TokenManagerProvider.instance.manager.setToken(token);
      */

      return token.accessToken;
    } catch (error) {
      return Future.error(error);
    }
  }

  /*----------------------------------------------------------------
    - 함수 : handleGoogleSignIn
    - 기능 : 구글로그인
    - @param {} 
    - @return {User} 로그인성공시 유저를 리턴 
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
    ----------------------------------------------------------------*/
  Future<AuthStatus?> handleGoogleSignIn() async {
    try {
      isBusy = true;

      /// Record log in firebase kAnalytics about Google login
      kAnalytics.logLogin(loginMethod: 'google_login');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('로그인을 취소하였습니다.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final parameters = jsonEncode({
        'provider': Channel.GOOGLE.name,
        'accessToken': googleAuth.accessToken,
      });

      //localhost -> 10.0.2.2(android)
      final url = Uri.http(
          //'hongsi-env2.eba-cxnhz8ta.ap-northeast-2.elasticbeanstalk.com',
          'localhost:5000',
          '/oauth/login');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: parameters,
      );

      /* '23.4 firebase 방식의 로그인 사용안함 - spring boot restapi 호출 
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      */
      /*
      /// 유저정보 수정
      user = (await _firebaseAuth.signInWithCredential(credential)).user;
      uid = user!.uid;
      */

      final statusCode = response.statusCode;
      final jsonBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (statusCode == 200) {
        // tokenData 추출
        final tokenData = jsonBody['data'];

        // accessToken 및 refreshToken 저장
        await getIt<SharedPreferenceHelper>()
            .saveAccessToken(tokenData['accessToken']);
        await getIt<SharedPreferenceHelper>()
            .saveAccessToken(tokenData['refreshToken']);
        // 유저 프로파일 조회
        await getProfileUser(tokenData['accessToken']);

        // userModel이 null이 아닌경우
        if (_userModel != null) {
          // 로그인 성공
          authStatus = AuthStatus.LOGGED_IN;
        } else {
          // 로그인 안된상태
          authStatus = AuthStatus.NOT_LOGGED_IN;
        }
      } else {
        // 로그인 안된상태
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }

      // Social 로그인 유저생성 - 2022.07.25 / 김종환 / createUser 함수폐기
      // createUserFromSocialLogin();
      return authStatus;
    } on PlatformException catch (error) {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return authStatus;
    } on Exception catch (error) {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return authStatus;
    } catch (error) {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return authStatus;
    }
  }

  /* verifyToken 방식 폐기 
  /*----------------------------------------------------------------
    - 함수 : _verifyToken
    - 기능 : Kakao access Token을 이용하여 cloud function을 호출하고 커스텀키를 발급받는다.
    - @param {String} kakaoToken - accessToken 
    - @return {String} result.data['token'] - firebase custom token
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
    -       2023.04.11 / 김종환 / Spring boot를 사용함에 따라 폐기하였음
    ----------------------------------------------------------------*/

  Future<String> _verifyToken(String kakaoToken) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('verifyKakaoToken');

      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'token': kakaoToken,
        },
      );

      if (result.data['error'] != null) {
        return Future.error(result.data['error']);
      } else {
        return result.data['token'];
      }
    } catch (e) {
      return Future.error(e);
    }
  }
  */

  /*----------------------------------------------------------------
    - 함수 : createUserFromSocialLogin - 폐기
    - 기능 : 소셜로그인 유저를 생성한다. 기존유저가 있는 경우는 추가정보 입력여부에 따라 화면을 분기처리 한다. 
    - @param {} 
    - @return {}
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
            2022.07.24 / 김종환 / 소셜로그인시 유저 추가정보입력까지 갔다가 뒤로가기버튼으로 나가는 경우 유저정보를 삭제하는 로직을 넣었기 때문에, 유저가 존재하는지 체크하는 로직 주석처리함
            2022.07.25 / 김종환 / 유저생성로직을 signup_page.dart 에서 처리하도록 변경함에따라 전체 주석처리
    ----------------------------------------------------------------*/
  /* 
  void createUserFromSocialLogin() {
    //  2022.07.24 / 김종환 / 소셜로그인시 유저 추가정보입력까지 갔다가 뒤로가기버튼으로 나가는 경우 유저정보를 삭제하는 로직을 넣었기 때문에, 유저가 존재하는지 체크하는 로직 주석처리함
    // 유저가 존재하는지 체크
    firestore
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        /// 추가정보 가져오기
        String? name = documentSnapshot.get('name');

        /// 추가정보(닉네임, 역할)가 입력되지 않은경우
        if (name == null) {
          authStatus = AuthStatus.LOGGED_IN_WITHOUT_INFO;

          /// 추가정보(닉네임, 역할)가 입력된 경우
        } else {
          authStatus = AuthStatus.LOGGED_IN;
        }
      } else {
        /// 유저생성 - 신규유저
        createUser(model, newUser: true);
        /// 신규유저를 생성한경우는 추가정보를 입력받아야 한다.
        authStatus = AuthStatus.LOGGED_IN_WITHOUT_INFO;
      }
      

      // authStatus 변경사항 전파
      notifyListeners();
    });
    
    /// 신규유저를 생성한경우는 추가정보를 입력받아야 한다.
    authStatus = AuthStatus.LOGGED_IN_WITHOUT_INFO;
    notifyListeners();
  }
  */

  /*----------------------------------------------------------------
  - 함수 : signUp
  - 기능 : email 방식으로 새 유저를 생성한다. 
  - @param {UserModel} 유저모델파라미터
  - @param {GlobalKey} 스낵바를 위한 글로벌키
  - @return {String} 패스워드 
  - 이력 : 2022.06.15 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  /// 이메일, 패스워드 방식으로 회원가입을 진행한다.
  /*
  Future<AuthStatus?> signUp(UserModel userModel,
      {required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
      required String password}) async {
    try {
      // isBusy 처리
      isBusy = true;

      // 이메일과 패스워드로 신규유저 생성
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password,
      );

      // user 셋팅
      user = result.user;
      authStatus = AuthStatus.LOGGED_IN;

      // SignUp 기록
      kAnalytics.logSignUp(signUpMethod: 'register');

      // DisplayName 업데이트
      result.user!.updateDisplayName(
        userModel.name,
      );

      // [TODO] 프로필 사진추가 기능 나중에 추가
      //result.user!.updatePhotoURL(userModel.profilePic);

      // userModel 셋팅
      _userModel = userModel;
      _userModel!.key = user!.uid;
      _userModel!.uid = user!.uid;
      createUser(_userModel!, newUser: true);
      return authStatus;
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'signUp');
      Utility.customSnackBar(scaffoldMessengerKey, error.toString());
      return null;
    }
  }
  */

  /*----------------------------------------------------------------
  - 함수 : createUser
  - 기능 : 새 유저를 생성한다. 
  - @param {UserModel} 유저모델파라미터
  - @param {newUser} 신규유저여부
  - @return {String} token.accessToken
  - 이력 : 2022.06.15 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  void createUser(UserModel user, {bool newUser = false}) {
    if (newUser) {
      // Create username by the combination of name and id
      // 홍시가족에서는 유저 닉네임이 유니크하므로 아래로직을 주석처리
      //user.name = Utility.getUserName(id: user.uid!, name: user.name!);
      kAnalytics.logEvent(name: 'create_newUser');

      user.createdAt = DateTime.now().millisecond;
    }

    // set 메서드를 통해 기존유저가 있는경우는 update, 신규유저인 경우는 insert
    /* firestore
      .collection('user')
      .doc(user.uid)
      .set(user.toJson(), SetOptions(merge: true))
      .catchError((error) => print("Failed to add user: $error"));
    */

    _userModel = user;
    isBusy = false;
  }

  /*----------------------------------------------------------------
  - 함수 : deleteUser
  - 기능 : 유저를 삭제한다.
  - @param {} 
  - 이력 : 2022.07.25 / 김종환 / 최초생성 
   [todo] cloud function 을 이용해 User를 delete 하도록 기능 추가해야함
  ----------------------------------------------------------------*/
  FutureOr<void> deleteUser({
    GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
  }) async {
    try {
      isBusy = true;
      // 유저가 null이 아닌경우 유저를 삭제한다.
      /*
      if (user != null) {
        await user!.delete();
      }
      */
      isBusy = false;
    } catch (e) {
      Utility.customSnackBar(scaffoldMessengerKey, e.toString());
      /* 로그기록 
      cprint(e, errorIn: 'deleteUser', uid: user!.uid);
      */
    }
  }

  /*----------------------------------------------------------------
    - 함수 : getCurrentUser 
    - 기능 : 현재 유저를 받아온다
    - @param {}
    - @return {User} 현재 로그인한 유저
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
            2023.04.19 / 김종환 / spring boot 도입에 따라 SharedPreference 의 accessKey를 통해 profile을 가져오는 방식으로 수정
    ----------------------------------------------------------------*/
  Future<AuthStatus?> getCurrentUser() async {
    try {
      isBusy = true;
      Utility.logEvent('getCurrentUser', parameter: {});

      // 현재 유저를 가져온다.
      // user = _firebaseAuth.currentUser;

      // accessKey 가져온다
      String? accessKey =
          await getIt<SharedPreferenceHelper>().getAccessToken();
      // accessKey 체크
      if (accessKey != null) {
        /// 현재 유저의 프로파일을 가져온다. - 해당 함수안에서 uid, channel, _userModel 셋팅 후 isBusy = false 처리
        await getProfileUser(accessKey);

        //accessKey에 해당하는 유저모델 체크
        if (_userModel == null) {
          authStatus = AuthStatus.NOT_LOGGED_IN;
        } else {
          authStatus = AuthStatus.LOGGED_IN;
        }
      } else {
        // accessKey가 없는 경우
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      isBusy = false;
      return authStatus;
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getCurrentUser');
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return authStatus;
    }
  }

  /// Reload user to get refresh user data
  void reloadUser() async {
    /*
    await user!.reload();
    user = _firebaseAuth.currentUser;
    */
    /*
    if (user!.emailVerified) {
      //userModel!.isVerified = true;
      // If user verified his email
      // Update user in firebase realtime kDatabase
      createUser(userModel!);
      cprint('UserModel email verification complete');
      //Utility.logEvent('email_verification_complete',
      //  parameter: {userModel!.name!: user!.email});
    }
    */
  }

  /// Send email verification link to email2
  /*
  Future<void> sendEmailVerification(
      GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
    User user = _firebaseAuth.currentUser!;
    user.sendEmailVerification().then((_) {
      Utility.logEvent('email_verification_sent',
          parameter: {userModel!.name!: user.email});
      Utility.customSnackBar(
        scaffoldMessengerKey,
        'An email verification link is send to your email.',
      );
    }).catchError((error) {
      cprint(error.message, errorIn: 'sendEmailVerification');
      Utility.logEvent('email_verification_block',
          parameter: {userModel!.name!: user.email});
      Utility.customSnackBar(
        scaffoldMessengerKey,
        error.message,
      );
    });
  }
  */

/*
  /// Check if user's email is verified
  Future<bool> emailVerified() async {
    
    User user = _firebaseAuth.currentUser!;
    return user.emailVerified;
  }
*/

  /// Send password reset link to email
  Future<void> forgetPassword(String email,
      {required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey}) async {
    try {
      /*
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        Utility.customSnackBar(scaffoldMessengerKey,
            'A reset password link is sent yo your mail.You can reset your password from there');
        Utility.logEvent('forgot+password', parameter: {});
      }).catchError((error) {
        cprint(error.message);
      });
      */
    } catch (error) {
      Utility.customSnackBar(scaffoldMessengerKey, error.toString());
      return Future.value(false);
    }
  }

  /*----------------------------------------------------------------
    - 함수 : updateUserProfile 
    - 기능 : 유저정보를 업데이트한다.
    - @param {UserModel} 업데이트할 유저정보
    - @return {}
    - 이력 : 2022.07.23 / 김종환 / 최초생성 
            2023.04.23 / 김종환 / state 안에 userModel을 사용한다. 
    ----------------------------------------------------------------*/
  Future<void> updateUserProfile() async {
    try {
      final parameters = jsonEncode(userModel);

      //localhost -> 10.0.2.2(android)
      final url = Uri.http(
          //'hongsi-env2.eba-cxnhz8ta.ap-northeast-2.elasticbeanstalk.com',
          'localhost:5000',
          '/users/profile');

      final accessToken =
          await getIt<SharedPreferenceHelper>().getAccessToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: parameters,
      );

      final statusCode = response.statusCode;
      final jsonBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (statusCode == 200) {
        _userModel = UserModel.fromJson(jsonBody['data']);
      }

      Utility.logEvent('update_user');

      /* firestore
        .collection('user')
        .doc(uid)
        .update(argu)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
      */
    } catch (error) {
      cprint(error, errorIn: 'updateUserProfile');
    }
  }

  /*
  Future<String> _uploadFileToStorage(File file, path) async {
    var task = _firebaseStorage.ref().child(path);
    var status = await task.putFile(file);
    cprint(status.state.name);

    /// get file storage path from server
    return await task.getDownloadURL();
  }
  */

  /// `Fetch` user `detail` whose userId is passed
  Future<UserModel?> getUserDetail(String userId) async {
    UserModel user;

    var documentSnapshot = await firestore.collection('user').doc(userId).get();
    //var event = await kDatabase.child('profile').child(userId).once();

    if (documentSnapshot.exists) {
      user = UserModel.fromJson(documentSnapshot.data());
      //user.key = event.snapshot.key!;
      return user;
      print('Document data: ${documentSnapshot.data()}');
    } else {
      return null;
      print('Document does not exist on the database');
    }

    /*
    final map = event.value as Map?;
    if (map != null) {
      user = UserModel.fromJson(map);
      user.key = event.snapshot.key!;
      return user;
    } else {
      return null;
    }
    */
  }

  /*--------------------------------------------------------------------------------------------------------------------
  - 함수 : getProfileUser 
  - 기능 : 현재 유저의 프로파일을 가져온다.
  - @param {userProfileId} uid
  - @return {bool} isLoggedIn
  - 이력 : 2022.06.15 / 김종환 / 최초생성 
          2022.07.24 / 김종환 / 소셜로그인의 경우 이름, 역할이 null 값이면 AuthStatus를 AuthStatus.LOGGED_IN_WITHOUT_INFO로 처리한다.
          2023.04.19 / 김종환 / spring boot 도입에 따라 SharedPreference 의 accessKey를 통해 profile을 가져오는 방식으로 수정
  ----------------------------------------------------------------------------------------------------------------------*/
  Future<bool> getProfileUser(String accessToken) async {
    try {
      var url = Uri.parse(
          'http://hongsi-env2.eba-cxnhz8ta.ap-northeast-2.elasticbeanstalk.com/users/profile');

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });

      var statusCode = response.statusCode;
      if (statusCode == 200) {
        var user = jsonDecode(utf8.decode(response.bodyBytes));
        // 유저모델 할당
        _userModel = UserModel.fromJson(user);
        // 프로필 저장
        getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);

        return true;
      } else {
        // 유저모델 없음
        _userModel = null;
        return false;
      }

      /* spring boot 도입에 따른 기존로직 주석처리 
      userProfileId = userProfileId ?? user!.uid;

      await firestore
          .collection('user')
          .doc(userProfileId)
          .get()
          .then((DocumentSnapshot event) {
        if (event.exists) {
          var map = event.data() as Map;

          // uid 할당
          uid = map['uid'];

          // channel 할당
          channel = Channel.values.byName(map['channel']);

          // 유저모델 할당
          _userModel = UserModel.fromJson(map);
          _userModel!.isVerified = user!.emailVerified;

          // 이메일 인증이 완료되지 않은경우
          if (!user!.emailVerified) {
            // Check if logged in user verified his email address or not
            // reloadUser();
          }

          // cloud MessageToken이 null인 경우
          if (_userModel!.fcmToken == null) {
            updateFCMToken();
          }

          // 로그인한 상태
          authStatus = AuthStatus.LOGGED_IN;

          // serProfile 저장
          getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);

          Utility.logEvent('get_profile', parameter: {});
        } else {
          // 소셜로그인을 하는 경우 이미 로그인되어 있음, 현재 로그인상태가 아닌경우
          if (authStatus == AuthStatus.NOT_DETERMINED) {
            //비정상적 종료
            authStatus = AuthStatus.LOGGED_IN_WITH_ABNOMAL_EXIT;
          } else {
            // signup_page.dart 이동
            /*
            Provider.of<RouteManager>(context, listen: false).push(
                RoutePath.otherPage(RouteName.SIGNUP,
                    args: {'channel': Channel.GOOGLE}));
            */
          }
        }

        
        // isBusy false 처리
        isBusy = false;
      }); */
    } catch (error) {
      // 로그인하지 않은 상태
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'getProfileUser');
      return false;
    }
  }

  /*----------------------------------------------------------------
  - 함수 : whenAbnomalSignIn 
  - 기능 : 로그인이 비정상 종료된 경우 AlertDialog를 호출하여, 로그인 진행을 돕는다.
  - @param {BuildContext} Dialog 를 호출하기 위해서 BuildContext를 파라미터로 받는다. 
  - @return {} 
  - 이력 : 2022.06.15 / 김종환 / 최초생성
  ----------------------------------------------------------------*/
  void whenAbnomalSignIn(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("회원가입"),
          content: const Text("진행중인 회원가입 페이지로 바로 이동하시겠습니까?"),
          actions: [
            TextButton(
              child: const Text("아니오"),
              onPressed: () {
                Navigator.pop(context);
                authStatus = AuthStatus.NOT_LOGGED_IN;
                isBusy = false;
              },
            ),
            TextButton(
              child: const Text("예"),
              onPressed: () {
                Navigator.pop(context);

                // 로그인한 상태
                authStatus = AuthStatus.LOGGED_IN;
                isBusy = false;
                /*
                // signup_page.dart 이동
                Provider.of<RouteManager>(context, listen: false).push(
                    RoutePath.otherPage(RouteName.SIGNUP,
                        args: {'channel': Channel.GOOGLE}));
                */
              },
            ),
          ],
        );
      },
    );
  }

  /// Trigger when logged-in user's profile change or updated
  /// Firebase event callback for profile update
  void _onProfileChanged(DocumentSnapshot event) {
    final val = event.data();
    if (val is Map) {
      final updatedUser = UserModel.fromJson(val);
      _userModel = updatedUser;
      cprint('UserModel Updated');
      getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);
      notifyListeners();
    }
  }

  /*----------------------------------------------------------------
  - 함수 : updateFCMToken 
  - 기능 : FCMToken을 업데이트 한다.
  - @param {userProfileId} uid
  - @return {} 
  - 이력 : 2022.06.15 / 김종환 / 최초생성
  ----------------------------------------------------------------*/
  /*
  void updateFCMToken() {
    if (_userModel == null) {
      return;
    }
    //getProfileUser();
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      _userModel!.fcmToken = token;
      createUser(_userModel!);
    });
  }
  */

  /*
  void _onProfileUpdated(DatabaseEvent event) {
    final val = event.snapshot.value;
    if (val is List &&
        ['following', 'followers'].contains(event.snapshot.key)) {
      final list = val.cast<String>().map((e) => e).toList();
      if (event.previousChildKey == 'following') {
        _userModel = _userModel!.copyWith(
          followingList: val.cast<String>().map((e) => e).toList(),
          following: list.length,
        );
      } else if (event.previousChildKey == 'followers') {
        _userModel = _userModel!.copyWith(
          followersList: list,
          followers: list.length,
        );
      }
      getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);
      cprint('UserModel Updated');
      notifyListeners();
    }
  }
  */
}
