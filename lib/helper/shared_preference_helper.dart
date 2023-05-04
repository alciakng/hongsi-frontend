import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// user_model.dart => USER_MODEL을 정의
import 'package:hongsi_project/model/user_model.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._internal();
  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() {
    return _singleton;
  }

  Future<String?> getUserName() async {
    return (await SharedPreferences.getInstance())
        .getString(UserPreferenceKey.UserName.toString());
  }

  Future clearPreferenceValues() async {
    (await SharedPreferences.getInstance()).clear();
  }

  Future<bool> saveUserProfile(UserModel user) async {
    return (await SharedPreferences.getInstance()).setString(
        UserPreferenceKey.UserProfile.toString(), json.encode(user.toJson()));
  }

  Future<UserModel?> getUserProfile() async {
    final String? jsonString = (await SharedPreferences.getInstance())
        .getString(UserPreferenceKey.UserProfile.toString());
    if (jsonString == null) return null;
    return UserModel.fromJson(json.decode(jsonString));
  }

  Future<bool> saveAccessToken(String accessToken) async {
    return (await SharedPreferences.getInstance())
        .setString(UserPreferenceKey.AccessToken.toString(), accessToken);
  }

  Future<String?> getAccessToken() async {
    final String? accessToken = (await SharedPreferences.getInstance())
        .getString(UserPreferenceKey.AccessToken.toString());
    if (accessToken == null) return null;
    return accessToken;
  }

  Future<bool> saveRefreshToken(String refreshToken) async {
    return (await SharedPreferences.getInstance())
        .setString(UserPreferenceKey.RefreshToken.toString(), refreshToken);
  }

  Future<String?> getRefreshToken() async {
    final String? refreshToken = (await SharedPreferences.getInstance())
        .getString(UserPreferenceKey.RefreshToken.toString());
    if (refreshToken == null) return null;
    return refreshToken;
  }
}

enum UserPreferenceKey {
  AccessToken,
  RefreshToken,
  UserProfile,
  UserName,
  IsFirstTimeApp
}
