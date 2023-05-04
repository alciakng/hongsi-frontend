// [firebase 플러그인]
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as db;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

// [참조]
import 'package:hongsi_project/helper/enum.dart';
import 'package:hongsi_project/helper/shared_preference_helper.dart';
import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/model/family_model.dart';
import 'package:hongsi_project/model/notify_model.dart';
import 'package:hongsi_project/model/user_model.dart';
import 'package:hongsi_project/helper/locator.dart';
import 'package:provider/provider.dart';

// [기본  state 관리]
import 'package:hongsi_project/state/app_state.dart';

class NotifyState extends AppState {
  final List<NotifyModel> _userNotificationList = [];
  final List<NotifyModel> _familyNotificationList = [];

  List<NotifyModel> get userNotificationList => _userNotificationList;
  List<NotifyModel> get familyNotificationList => _familyNotificationList;
}
