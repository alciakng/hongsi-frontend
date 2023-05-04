import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hongsi_project/firebase_options.dart';

// 아래 초기화작업을 하기전에 flutterfire configure를 통해 프로젝트를 firebase와 연결시킨다.
// --------------------------flutterfire configure-------------------------- //
// 1. dart pub global activate flutterfire_cli
// 2. flutterfire configure -> make firebase_options.dart
// ------------------------------------------------------------------------- //
class FirebaseService {
  static configureFirebase() async {
    //
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      name: 'hongsi-project',
      // firebase_options.dart 에서 불러온다.
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
