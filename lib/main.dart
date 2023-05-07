import 'package:flutter/material.dart';
import 'package:hongsi_project/helper/enum.dart';
import 'package:hongsi_project/page/auth/adit_info_page.dart';
import 'package:hongsi_project/page/auth/signup_page.dart';
import 'package:hongsi_project/page/auth/welcome_page.dart';
import 'package:hongsi_project/page/common/splash.dart';
import 'package:hongsi_project/page/family/search_family_page.dart';
import 'package:hongsi_project/page/feed/home_page.dart';
import 'package:hongsi_project/state/notify_state.dart';
//provider pakage import
import 'package:provider/provider.dart';
// flutter localization
import 'package:flutter_localizations/flutter_localizations.dart';
//firebase initialize
import 'package:hongsi_project/services/firebase_service.dart';
//locator.dart => sharedPreference 공유저장소 사용(get-it)
import 'package:hongsi_project/helper/locator.dart';
//auth_state.dart => 계정과 관련된 State
import 'package:hongsi_project/state/auth_state.dart';
//app_state.dart => 기본 State (다른 State class에서 상속받아 사용)
import 'package:hongsi_project/state/app_state.dart';
//family_state.dart => 가족과 관련된 State
import 'package:hongsi_project/state/family_state.dart';
//search_state.dart => 검색과 관련된 State
import 'package:hongsi_project/state/search_state.dart';

//[route 2.0] route_delegate.dart => appState를 navigatorState로 변환 - GoRouter 도입하면서 사용하지않음
///import 'package:hongsi_project/routes/route_delegate.dart';
//[route 2.0] route_information_parser.dart => path를 appState로 변환 - GoRouter 도입하면서 사용하지않음
//import 'package:hongsi_project/routes/route_information_parser.dart';
//[route 2.0] route_path.dart => route path (route 경로 객체) - GoRouter 도입하면서 사용하지않음
//import 'package:hongsi_project/routes/route_path.dart';
//import 'package:hongsi_project/routes/route_manager.dart'; - GoRouter 도입하면서 사용하지않음

// [goRouter] - 라우터 2.0 pakage
import 'package:go_router/go_router.dart';
// [kakao SDK] - 카카오 SDK
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hongsi_project/firebase_options.dart';
// [theme]
import 'package:hongsi_project/theme/theme.dart';

// Routing 설정 - 별도 파일로 빼지않고 main에 위치한다.
final _router = GoRouter(
  initialLocation: '/',
  redirectLimit: 5,
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        // authState
        var authState = context.read<AuthState>();
        // 현재유저셋팅
        final AuthStatus? status = await authState.getCurrentUser();

        switch (status) {
          case AuthStatus.NOT_LOGGED_IN:
            return '/welcome';
          case AuthStatus.LOGGED_IN:
            return '/home';
          default:
            return '/welcome';
        }
      },
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/signUp',
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      path: '/aditInfo/:channel',
      builder: (context, state) =>
          AditInfoPage(channel: state.params['channel']),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'searchFamily',
          builder: (context, state) => const SearchFamily(),
        ),
      ],
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase configure
  await FirebaseService.configureFirebase();
  // kakao sdk 초기화 - 서비스 키
  KakaoSdk.init(nativeAppKey: 'b963bbc312a5cdeb5f82fa3682f075e9');
  // [get-it] 의존성주입 플러그인을 사용하여 sharedPreferences 등록
  setupDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  /// 스낵바 컨트롤을 위한 스캐폴드키
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //Provider<RouteManager>(create: (_) => RouteManager()),- GoRouter 도입하면서 사용하지않음
          ChangeNotifierProvider<AppState>(create: (_) => AppState()),
          ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
          ChangeNotifierProvider<FamilyState>(create: (_) => FamilyState()),
          ChangeNotifierProvider<SearchState>(create: (_) => SearchState()),
          ChangeNotifierProvider<NotifyState>(create: (_) => NotifyState()),
        ],
        child: MaterialApp.router(
          routerConfig: _router,
          scaffoldMessengerKey: scaffoldMessengerKey,
          // ignore: prefer_const_literals_to_create_immutables
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // ignore: prefer_const_literals_to_create_immutables
          supportedLocales: [
            const Locale('ko', ''),
            const Locale('en ', ''),
          ],
          locale: const Locale('ko', ''),
          debugShowCheckedModeBanner: false,
          title: 'hongsi',
          theme: AppTheme.apptheme,
        ));
  }
}
