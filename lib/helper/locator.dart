import 'package:hongsi_project/helper/shared_preference_helper.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<SharedPreferenceHelper>(SharedPreferenceHelper());
  // getIt.registerSingleton<PushNotificationService>(
  //     PushNotificationService(FirebaseMessaging()));
}
