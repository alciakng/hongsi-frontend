# 홍시프로젝트
> 가족 일상공유 앱 프로젝트

가족을 위한 일상공유 앱

## 환경

 - Flutter 3.7.11 • Dart 2.19.6 
 - Firebase 로컬 구성 
   * 안드로이드 : https://firebase.flutter.dev/docs/manual-installation/androidㅎ
   * ios1 : https://firebase.flutter.dev/docs/manual-installation/ios
   * ios2 : https://pub.dev/packages/google_sign_in (ios 셋팅 방법 참고)


## 프로젝트 개요 

 <<사용라이브러리>>

 - [Navigation] Navigation 2.0 native를 활용하다가, 너무 복잡하고 러닝커브가 심각하여 Router 2.0으로 변환하였음 
 - [Provider] 현재까지는 상태관리에 MultiProvider를 활용하고 있음 

 <<프로젝트 구조>>
<img width="303" alt="image" src="https://user-images.githubusercontent.com/10395170/236672382-98a29fd6-b75a-432c-ba5c-f32b7fc5a1b9.png">

- [helper] utility 성 공통 
- [model] 홍시 앱에서 사용하는 데이터 객체 모델 
- [page] 홍시 앱 메인 페이지들 
- [routes] Navigation 2.0 사용 시 공통 (현재 Go_Router 사용으로 인해 사용안함)
- [state] Provider 상태관리 객체
- [widgets] 공통 widget들 (Page에서 참조)
 

## 업데이트 내역
* 0.1.0 
    * firebase firestore 사용하지 않도록 수정 
    * http 방식으로 spring boot API 콜하는 방식으로 수정 
    * navigation 2.0 사용하지않고 go_router 사용
    * 위 변경사항으로 인한 주석처리 소스 정리 
* 0.0.1
    * 첫 배포 
