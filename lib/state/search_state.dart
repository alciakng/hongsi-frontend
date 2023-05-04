// [firebase 플러그인]
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
// [참조]
import 'package:hongsi_project/model/family_model.dart';
import 'package:hongsi_project/model/user_model.dart';

// [기본  state 관리]
import 'package:hongsi_project/state/app_state.dart';

class SearchState extends AppState {
  final List<FamilyModel> _familyList = [];
  final List<UserModel> _userList = [];

  List<UserModel> get userList => _userList;
  List<FamilyModel> get familyList => _familyList;

  late QuerySnapshot userCollectionState;
  late QuerySnapshot familyCollectionState;

  /*--------------------------------------------------------------------------------------------------------------------
  - 함수 : getFamilys
  - 기능 : 가족 검색결과를 가져온다
  - @param {} 
  - @return {} 
  - 이력 : 2022.08.31 / 김종환 / 최초생성  
  ----------------------------------------------------------------------------------------------------------------------*/
  Future<void> getFamilys() async {
    isBusy = true;
    var collection = FirebaseFirestore.instance.collection('family').limit(3);

    // familyList를 clear 해준다.(초기화)
    _familyList.clear();
    await fetchFamily(collection);
  }

  /*--------------------------------------------------------------------------------------------------------------------
  - 함수 : fetchFamily 
  - 기능 : 가족정보를 가져온다.
  - @param {} 
  - @return {} 
  - 이력 : 2022.09.01 / 김종환 / 최초생성 
  ----------------------------------------------------------------------------------------------------------------------*/
  Future<void> fetchFamily(Query collection) async {
    await collection.get().then((value) {
      familyCollectionState = value;

      value.docs.forEach((element) {
        print('getDocuments ${element.data()}');
        _familyList.add(FamilyModel.fromJson(element.data() as Map));
      });
    });

    isBusy = false;
  }

  /*--------------------------------------------------------------------------------------------------------------------
  - 함수 : getFamilysNext 
  - 기능 : 가족 추가검색결과를 가져온다. 
  - @param {} 
  - @return {} 
  - 이력 : 2022.10.01 / 김종환 / 최초생성 
  ----------------------------------------------------------------------------------------------------------------------*/
  Future<void> getFamilysNext() async {
    isBusy = true;
    // Get the last visible document
    var lastVisible =
        familyCollectionState.docs[familyCollectionState.docs.length - 1];
    print(
        'listDocument legnth: ${familyCollectionState.size} last: $lastVisible');

    var collection = FirebaseFirestore.instance
        .collection('family')
        .startAfterDocument(lastVisible)
        .limit(3);

    await fetchFamily(collection);
  }

  /*--------------------------------------------------------------------------------------------------------------------
  - 함수 : searchFamily 
  - 기능 : 조건에 맞는 검색결과 리턴 
  - @param {} 
  - @return {} 
  - 이력 : 2022.09.01 / 김종환 / 최초생성 
  ----------------------------------------------------------------------------------------------------------------------*/

  Future<void> searchFamily(String keyword) async {
    isBusy = true;

    // 검색어가 있는경우
    if (keyword != '') {
      _familyList.clear();
      await FirebaseFirestore.instance
          .collection('family')
          .orderBy('name')
          .startAt([keyword])
          .endAt([keyword + '\uf8ff'])
          .get()
          .then((QuerySnapshot value) => value.docs.forEach((element) {
                log(element.data().toString());

                _familyList.add(FamilyModel.fromJson(element.data() as Map));
              }));
      isBusy = false;
    } else {
      await getFamilys();
    }
  }

  /*--------------------------------------------------------------------------------------------------------------------
  - 함수 : onChangeFamilyData 
  - 기능 : 가족정보 리스너 (가족정보 변경사항이 있으면 _familyList를 변경하고 notifyListeners()를 호출해준다.)
  - @param {} 
  - @return {} 
  - 이력 : 2022.09.01 / 김종환 / 최초생성 
  ----------------------------------------------------------------------------------------------------------------------*/
  void onChangeFamilyData(List<DocumentChange> documentChanges) {
    documentChanges.forEach((familyChange) {
      if (familyChange.type == DocumentChangeType.removed) {
        isBusy = true;
        _familyList.removeWhere((family) {
          return familyChange.doc.id == family.id;
        });
      } else {
        if (familyChange.type == DocumentChangeType.modified) {
          isBusy = true;
          int indexWhere = _familyList.indexWhere((family) {
            return familyChange.doc.id == family.id;
          });

          if (indexWhere >= 0) {
            _familyList[indexWhere] =
                FamilyModel.fromJson(familyChange.doc.data() as Map);
          }
        }
      }
    });

    isBusy = false;
  }

  Future<void> getDocuments() async {
    isBusy = true;
    var collection = FirebaseFirestore.instance.collection('user').limit(10);
    print('getDocuments');

    _userList.clear();
    await fetchUser(collection);
  }

  Future<void> getDocumentsNext() async {
    isBusy = true;
    // Get the last visible document
    var lastVisible =
        userCollectionState.docs[userCollectionState.docs.length - 1];
    print(
        'listDocument legnth: ${userCollectionState.size} last: $lastVisible');

    var collection = FirebaseFirestore.instance
        .collection('user')
        .startAfterDocument(lastVisible)
        .limit(5);

    await fetchUser(collection);
  }

  Future<void> fetchUser(Query collection) async {
    await collection.get().then((value) {
      userCollectionState =
          value; // store collection state to set where to start next
      value.docs.forEach((element) {
        print('getDocuments ${element.data()}');
        _userList.add(UserModel.fromJson(element.data() as Map));
      });
    });

    isBusy = false;
  }
}
