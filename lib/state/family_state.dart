// [firebase 플러그인]
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// [참조]
import 'package:hongsi_project/helper/enum.dart';
import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/model/family_model.dart';
import 'package:hongsi_project/model/neighbor_model.dart';
import 'package:hongsi_project/state/search_state.dart';
import 'package:provider/provider.dart';

// [기본  state 관리]
import 'package:hongsi_project/state/app_state.dart';

// [path]
import 'package:path/path.dart' as path;

import '../model/notify_model.dart';
import 'auth_state.dart';

class FamilyState extends AppState {
  // document Id
  int? id;
  // Family model
  FamilyModel? _familyModel;
  FamilyModel? get familyModel => _familyModel;

  // noramlRequestList - 일반알람리스트
  final List<NotifyModel> _notificationList = [];

  // 알람리스트 가져오기
  List<NotifyModel> get normalRequestList {
    return _notificationList
        .where((element) => (NotificationType.getByName(element.type) ==
            NotificationType.NORMAL))
        .toList();
  }

  List<NotifyModel> get neighborRequestList {
    return _notificationList
        .where((element) => (NotificationType.getByName(element.type) ==
            NotificationType.NEIGHBOR_REQUEST))
        .toList();
  }

  List<NotifyModel> get familyRequestList {
    return _notificationList
        .where((element) => (NotificationType.getByName(element.type) ==
            NotificationType.FAMILY_REQEST))
        .toList();
  }

  //파이어베이스 스토리지
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  /*----------------------------------------------------------------
    - 함수 : clearVariable
    - 기능 : 변수를 초기화한다.
    - @param {} 
    - @return {} 
    - 이력 : 2022.06.15 / 김종환 / 최초생성 
    ----------------------------------------------------------------*/
  void clearVariable() {
    id = null;
    _familyModel = null;
  }

  /*----------------------------------------------------------------
  - 함수 : createFamily
  - 기능 : 새로운 가족을 생성한다. 
  - @param {FamilyModel} 
  - @param {newFamily} 
  - 이력 : 2022.08.24 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  Future<void> createOrUpdateFamily(
      {required FamilyModel familyModel,
      required BuildContext buildContext,
      File? familyImage,
      File? bannerImage}) async {
    isBusy = true;

    var authState = Provider.of<AuthState>(buildContext, listen: false);

    var isNew = (id == null);

    if (familyImage != null) {
      /// path package : p.basename('path/to/foo.dart'); // -> 'foo.dart'
      familyModel.familyImage = await _uploadFileToStorage(familyImage,
          'user/profile/${familyModel.name}/${path.basename(familyImage.path)}');

      Utility.logEvent('family_profile_image');
    }

    if (bannerImage != null) {
      familyModel.bannerImage = await _uploadFileToStorage(bannerImage,
          'user/profile/${familyModel.name}/${path.basename(bannerImage.path)}');
      Utility.logEvent('family_banner_image');
    }

    // famId 가 null 이면(현재 소속된 가족이 없으면) 가족 신규생성
    if (isNew) {
      // create_newFamily 로그
      kAnalytics.logEvent(name: 'create_newFamily');
      DocumentReference familyReference = firestore.collection('family').doc();
      familyModel.createdAt = DateTime.now().toUtc().toString();
      familyModel.userList = [authState.userModel!.toJson()];
      familyModel.id = familyReference.id;
      //id = familyReference.id;

      // 신규생성 유저가 해당가족의 리더가 된다.
      //authState.updateUserProfile({"fam": familyReference, "leader": true});
    }

    final batch = firestore.batch();

    // set 메서드를 통해 가족 생성, 신규가 아닌경우 업데이트
    /*
    var createFamily = firestore
        .collection('family')
        .doc(id); // id가 null이면 신규 document가 생성되고 null이 아니면 기존 다큐먼트와 병합한다.
    batch.set(createFamily, familyModel.toJson(), SetOptions(merge: true));
    */

    //  신규 생성인 경우 user sub Collection을 생성한다.
    if (isNew) {
      // 신규 user sub Collection의 document
      /*
      var createUser =
          firestore.collection('family').doc(id).collection('user').doc();
      batch.set(createUser,
          {'user': firestore.collection('user').doc(authState.uid)});
      */
    }

    // Commit the batch
    batch.commit().then((_) {}).catchError((error) {
      isBusy = false;
      cprint(error, errorIn: 'create_family');
    });

    _familyModel = familyModel;
    isBusy = false;
  }

  /*--------------------------------------------------------------------------------------------------------------------
  - 함수 : getFamily 
  - 기능 : 현재 가족정보를 가져온다.
  - @param {String} familyKey
  - @return {} 
  - 이력 : 2022.06.15 / 김종환 / 최초생성 
          2022.07.24 / 김종환 / 소셜로그인의 경우 이름, 역할이 null 값이면 AuthStatus를 AuthStatus.LOGGED_IN_WITHOUT_INFO로 처리한다.
  ----------------------------------------------------------------------------------------------------------------------*/

  Future<void> getFamily(int? _id) async {
    isBusy = true;

    try {
      var familyId = _id ?? id;

      /*
      await firestore
          .collection('family')
          .doc(familyId)
          .get()
          .then((DocumentSnapshot event) {
        if (event.exists) {
          var map = event.data() as Map;

          // id 할당
          id = event.id;

          // 패밀리모델 할당
          _familyModel = FamilyModel.fromJson(map);

          Utility.logEvent('get_profile', parameter: {});
        }
      

        // isBusy false 처리
        isBusy = false;
      });
      */
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getProfileUser');
    }
  }

  /*----------------------------------------------------------------
  - 함수 : createNeighbor
  - 기능 : 이웃을 생성한다 
  - @param {String} famId / 이웃 생성할 가족의 ID  
  - 이력 : 2022.08.24 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  Future<String?> createNeighbor(FamilyModel familyModel) async {
    isBusy = true;

    /*
    String? myDocId =
        firestore.collection('family').doc(id).collection('neighbor').doc().id;

    String? toDocId = firestore
        .collection('family')
        .doc(familyModel.id)
        .collection('neighbor')
        .doc()
        .id;

    // send neighborModel 신규생성
    NeighborModel sendNeighborModel = NeighborModel(
      // key 는 아래 family_state의 createFamily 메소드내부에서 셋팅
      fid: familyModel.id,
      // [todo] cloud function 으로 구현
      fam: firestore.collection('family').doc(familyModel.id),
      id: myDocId,
      state: NeighborState.SEND_REQUEST.name,
    );

    // receive neighborModel 신규생성 (상대방 가족)
    NeighborModel receiveNeighborModel = NeighborModel(
      // key 는 아래 family_state의 createFamily 메소드내부에서 셋팅
      fid: id,
      // [todo] cloud function 으로 구현
      fam: firestore.collection('family').doc(id),
      id: toDocId,
      state: NeighborState.RECEIVE_REQUEST.name,
    );

    // 내 이웃 신규생성
    await firestore
        .collection('family')
        .doc(id)
        .collection('neighbor')
        .doc(myDocId)
        .set(sendNeighborModel.toJson())
        .then((value) async {
      isBusy = false;
    }).catchError((error) {
      isBusy = false;
      cprint(error, errorIn: '_createNeighbor');
    });

    // 상대방 이웃 신규생성
    await firestore
        .collection('family')
        .doc(familyModel.id)
        .collection('neighbor')
        .doc(toDocId)
        .set(receiveNeighborModel.toJson())
        .then((value) async {
      isBusy = false;
    }).catchError((error) {
      isBusy = false;
      cprint(error, errorIn: '_createNeighbor');
    });
    
    return myDocId;
    */
  }

  /*----------------------------------------------------------------
  - 함수 : updateNeighbor
  - 기능 : 이웃을 업데이트한다.
  - @param {FamilyModel} familyModel / 삭제할 가족 모델
  - 이력 : 2022.09.07 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  Future<void> updateNeighbor(String fid, NeighborState state) async {
    isBusy = true;

    /*
    // 원자성을 보장하기 위한 일괄쓰기
    final batch = firestore.batch();

    // 상대방 가족 업데이트
    await firestore
        .collection('family')
        .doc(fid)
        .collection('neighbor')
        .where('fid', isEqualTo: id)
        .get()
        .then((value) => value.docs.forEach((element) {
              batch.update(element.reference, {'state': state.name});
            }))
        .catchError((error) {
      isBusy = false;
      cprint(error, errorIn: 'updateNeighbor_to');
    });

    // 내가족 업데이트
    await firestore
        .collection('family')
        .doc(id)
        .collection('neighbor')
        .where('fid', isEqualTo: fid)
        .get()
        .then((value) => value.docs.forEach((element) {
              batch.update(element.reference, {'state': state.name});
            }))
        .catchError((error) {
      isBusy = false;
      cprint(error, errorIn: 'updateNeighbor_my');
    });

    // Commit the batch
    batch.commit().then((_) {}).catchError((error) {
      isBusy = false;
      cprint(error, errorIn: 'updateNeighbor_all');
    });

    isBusy = false;

    */
  }

  /*----------------------------------------------------------------
  - 함수 : deleteNeighbor
  - 기능 : 이웃을 삭제한다 
  - @param {FamilyModel} familyModel / 삭제할 가족 모델
  - 이력 : 2022.09.07 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  Future<void> deleteNeighbor(String fid) async {
    isBusy = true;

    /*
    // 가족삭제
    await firestore
        .collection('family')
        .doc(id)
        .collection('neighbor')
        .where('fid', isEqualTo: fid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    }).catchError((error) {});

    isBusy = false;
    */
  }

  /*----------------------------------------------------------------
  - 함수 : isMyNeighbor
  - 기능 : 내 이웃인지 체크한다 
  - @param {String} famId / 이웃 생성할 가족의 ID  
  - 이력 : 2022.08.24 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  /*
  Future<NeighborState> isMyNeighbor(String? fid) async {
    NeighborState state = NeighborState.NONE;

    
    // 이웃 신규생성
    await firestore
        .collection('family')
        .doc(id)
        .collection('neighbor')
        .where("fid", isEqualTo: fid ?? '')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        // 현재 가족 state를 리턴한다.
        switch (value.docs.first.get('state')) {
          case 'SEND_REQUEST':
            state = NeighborState.SEND_REQUEST;
            break;
          case 'RECEIVE_REQUEST':
            state = NeighborState.RECEIVE_REQUEST;
            break;
          case 'APPROVE':
            state = NeighborState.APPROVE;
            break;
          default:
            state = NeighborState.NONE;
            break;
        }
      } else {
        state = NeighborState.NONE;
      }
    }).catchError((error) {
      state = NeighborState.NONE;
      cprint(error, errorIn: 'isMyNeighbor');
    });

    return state;
    
  }
  */

  /*----------------------------------------------------------------
  - 함수 : getNotifications
  - 기능 : 알림 리스트를 받아온다. 
  - @param {NotifyModel} 
  - @param {buildContext} 
  - 이력 : 2022.08.24 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  Future<void> getNotifications() async {
    isBusy = true;

    List<NotifyModel> tempList = [];

    // 해당유저의 notification 서브콜렉션에 document를 추가한다.
    /*
    await firestore
        .collection('family')
        .doc(id)
        .collection('notification')
        .get()
        .then((value) {
      // notification List에 추가
      value.docs.forEach((element) {
        print('getDocuments ${element.data()}');

        _notificationList.clear();
        _notificationList.add(NotifyModel.fromJson(element.data()));
      });
    });
    */

    isBusy = false;
  }

  /*----------------------------------------------------------------
  - 함수 : createNotification
  - 기능 : 새로운 알림을 발송한다.
  - @param {NotifyModel} 
  - @param {buildContext} 
  - 이력 : 2022.08.24 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  Future<void> createNotification({
    required String to,
    required NotifyModel notifyModel,
  }) async {
    isBusy = true;

    // notification 다큐먼트 아이디 채번
    DocumentReference notificationReference =
        firestore.collection('notification').doc();

    // 아이디 할당
    notifyModel.id = notificationReference.id;

    // 해당유저의 notification 서브콜렉션에 document를 추가한다.
    await firestore
        .collection('family')
        .doc(to)
        .collection('notification')
        .doc(notificationReference.id)
        .set(notifyModel.toJson(), SetOptions(merge: true))
        .catchError((error) => print("Failed to add user: $error"));

    isBusy = false;
  }

  /*----------------------------------------------------------------
  - 함수 : deleteNotification
  - 기능 : 알람을 삭제한다. 
  - @param {NotifyModel} 
  - @param {buildContext} 
  - 이력 : 2022.08.24 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  Future<void> deleteNotification({
    required NotifyModel notifyModel,
  }) async {
    isBusy = true;

    /*
    // 해당유저의 notification 서브콜렉션에 document를 추가한다.
    await firestore
        .collection('family')
        .doc(id)
        .collection('notification')
        .doc(notifyModel.id)
        .delete()
        .catchError((error) => print("Failed to add user: $error"));
    */

    isBusy = false;
  }

  /*----------------------------------------------------------------
  - 함수 : onChangeFamily
  - 기능 : 알람변경을 추적한다.
  - @param {NotifyModel} 
  - @param {buildContext} 
  - 이력 : 2022.08.24 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  void onChangeFamily(DocumentSnapshot documentSnapshot) {
    isBusy = true;

    _familyModel = FamilyModel.fromJson(documentSnapshot.data() as Map);

    isBusy = false;
  }

  /*----------------------------------------------------------------
  - 함수 : onChangeNotification
  - 기능 : 알람변경을 추적한다.
  - @param {NotifyModel} 
  - @param {buildContext} 
  - 이력 : 2022.08.24 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  void onChangeNotification(List<DocumentChange> documentChanges) {
    documentChanges.forEach((notificationChange) {
      if (notificationChange.type == DocumentChangeType.removed) {
        isBusy = true;

        _notificationList.removeWhere((notification) {
          return notificationChange.doc.id == notification.id;
        });
      } else {
        if (notificationChange.type == DocumentChangeType.modified) {
          isBusy = true;
          int indexWhere = _notificationList.indexWhere((notification) {
            return notificationChange.doc.id == notification.id;
          });

          if (indexWhere >= 0) {
            _notificationList[indexWhere] =
                NotifyModel.fromJson(notificationChange.doc.data() as Map);
          }
        }
      }
    });

    isBusy = false;
  }

  /*----------------------------------------------------------------
  - 함수 : _uploadFileToStorage
  - 기능 : 파일을 스토리지에 업로드한다.
  - @param {FamilyModel} 
  - @param {newFamily} 
  - 이력 : 2022.08.24 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
  Future<String> _uploadFileToStorage(File file, path) async {
    var task = _firebaseStorage.ref().child(path);
    var status = await task.putFile(file);
    cprint(status.state.name);

    /// get file storage path from server
    return await task.getDownloadURL();
  }
}
