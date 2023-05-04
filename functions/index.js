const functions = require('firebase-functions');
const kakao = require("./kakao");

// The Firebase Admin SDK to access Firestore.

/* --------------------------------------------------------------------------------------------------------------------------------
이 줄은 firebase-functions 및 firebase-admin 모듈을 로드하고 Cloud Firestore 변경이 가능한 admin 앱 인스턴스를 초기화합니다. 
FCM, 인증, Firebase 실시간 데이터베이스의 경우처럼 Admin SDK가 지원되기만 하면 어디에서든 Cloud Functions를 사용하여 Firebase를 강력하게 통합할 수 있습니다.
프로젝트를 초기화하면 Firebase CLI가 자동으로 Cloud Functions 노드 모듈용 Firebase SDK 및 Firebase를 설치합니다. 
프로젝트에 타사 라이브러리를 추가하려면 package.json을 수정하고 npm install을 실행합니다. 자세한 내용은 종속 항목 처리를 참조하세요.
----------------------------------------------------------------------------------------------------------------------------------- */

const admin = require('firebase-admin');
const request = require('request');
admin.initializeApp();

const db = admin.firestore();

// [verifyKakaoToken] 
exports.verifyKakaoToken = functions.https.onCall(async (data) => {
  const token = data.token;
  if (!token) return { error: "access 토큰이 존재하지 않습니다." };

  console.log(`커스텀 토큰 발급: ${token}`);

  return kakao
    .createFirebaseToken(token)
    .then(firebaseToken => {
      console.log(`firebase 커스텀토큰 유저에게 전달 : ${firebaseToken}`);
      return { token: firebaseToken };
    })
    .catch(e => {
      return { error: e.message };
    });
});


/*---------------------------------------------------------------------
- 함수 : eventOnFamilyCreate
- 기능 : 가족이 생성될때 신청한 유저를 서브컬렉션으로 생성하고, 가족의 leader로 설정한다. 
- @param {String} fid  - 가족아이디  
- 이력 : 2022.09.08 / 김종환 / 최초생성 
        2022.09.10 / 김종환 / firestore의 경우 context.auth.uid 미지원으로 잠시 함수 주석처리
----------------------------------------------------------------------*/
/* 함수 주석처리
exports.eventOnFamilyCreate = functions.firestore.document('family/{fid}').onCreate((snap, context) => {

  const fid = context.params.fid;
  const familyRef = db.collection('family').doc(fid);

  // 가족을 생성하는 유저의 DocumentReference 정보 
  const userRef = db.collection('user').doc(context.auth.uid);

  console.log("request user uid %s.", context.auth.uid);

  // 가족을 생성한 유저의 leader 여부를 셋팅한다. 
  userRef.update({ leader: true });
  // family 콜렉션의 user subCollection에  유저의 DocumentReference 정보를 추가한다.
  familyRef
    .collection('user')
    .add({ 'user': userRef })
    .catch(e => {
      return { error: e.message };
    });

  console.log("%s family, user subcollection created.", fid);
});
*/

/*----------------------------------------------------------------
- 함수 : countUserOfFamily
- 기능 : 가족구성원수
- @param {String} fid  - 가족아이디  
- @param {String} fuid - 유저아이디  
- 이력 : 2022.09.08 / 김종환 / 최초생성 
----------------------------------------------------------------*/
exports.countUserOfFamily = functions.firestore.document('family/{fid}/user/{fuid}').onWrite((change, context) => {

  const fid = context.params.fid;
  const familyRef = db.collection('family').doc(fid);

  let FieldValue = admin.firestore.FieldValue;

  if (!change.before.exists) {
    familyRef
      .update({ userCnt: FieldValue.increment(1) })
      .catch(e => {
        return { error: e.message };
      });
    console.log("%s userCnt incremented by 1", fid);

  } else if (change.before.exists && change.after.exists) {

    // updating existing document : Do nothing

  } else if (!change.after.exists) {
    // deleting document : subtract one from count
    familyRef
      .update({ userCnt: FieldValue.increment(-1) })
      .catch(e => {
        return { error: e.message };
      });
    console.log("%s userCnt incremented by 1", fid);
  }

});

/*----------------------------------------------------------------
- 함수 : countNotificationOfFamily
- 기능 : 가족알람횟수
- @param {String} fid - 가족아이디 
- @param {String} nid - 알람아이디 
- 이력 : 2022.09.08 / 김종환 / 최초생성 
----------------------------------------------------------------*/
exports.countNotificationOfFamily = functions.firestore.document('family/{fid}/notification/{nid}').onWrite((change, context) => {

  const fid = context.params.fid;
  const familyRef = db.collection('family').doc(fid)

  let FieldValue = require('firebase-admin').firestore.FieldValue;


  if (!change.before.exists) {
    // new document created : add one to count

    // 알람 타입에따른 카운트 증가 
    switch (change.after.get('type')) {
      case 'NEIGHBOR_REQUEST':
        familyRef
          .update({ neighborRequestCnt: FieldValue.increment(1) })
          .catch(e => {
            return { error: e.message };
          });
        break;
      case 'FAMILY_REQUEST':
        familyRef
          .update({ familyRequestCnt: FieldValue.increment(1) })
          .catch(e => {
            return { error: e.message };
          });
        break;
      case 'NORMAL':
        familyRef
          .update({ normalCnt: FieldValue.increment(1) })
          .catch(e => {
            return { error: e.message };
          });
        break;
      default:
        break;
    }

    // 전체카운트 증가 
    familyRef
      .update({ notificationCnt: FieldValue.increment(1) })
      .catch(e => {
        return { error: e.message };
      });
    console.log("%s notificationCnt incremented by 1", fid);

  } else if (change.before.exists && change.after.exists) {

    // updating existing document : Do nothing

  } else if (!change.after.exists) {
    // deleting document : subtract one from count

    // 알람 타입에따른 카운트 감소 
    switch (change.before.get('type')) {
      case 'NEIGHBOR_REQUEST':
        familyRef
          .update({ neighborRequestCnt: FieldValue.increment(-1) })
          .catch(e => {
            return { error: e.message };
          });
        break;
      case 'FAMILY_REQUEST':
        familyRef
          .update({ familyRequestCnt: FieldValue.increment(-1) })
          .catch(e => {
            return { error: e.message };
          });
        break;
      case 'NORMAL':
        familyRef
          .update({ normalCnt: FieldValue.increment(-1) })
          .catch(e => {
            return { error: e.message };
          });
        break;
      default:
        break;
    }

    familyRef
      .update({ notificationCnt: FieldValue.increment(-1) })
      .catch(e => {
        return { error: e.message };
      });
    console.log("%s notificationCnt incremented by 1", fid);
  }

});

/*----------------------------------------------------------------
- 함수 : countNeighborOfFamily
- 기능 : 가족의 이웃숫자를 카운트 한다.
- @param {String} fid
- @param {String} nid
- 이력 : 2022.09.08 / 김종환 / 최초생성 
----------------------------------------------------------------*/
exports.countNeighborOfFamily = functions.firestore.document('family/{fid}/neighbor/{nid}').onWrite((change, context) => {

  const fid = context.params.fid;
  const familyRef = db.collection('family').doc(fid)

  let FieldValue = require('firebase-admin').firestore.FieldValue;

  const state = change.after.get('state');

  if (!change.before.exists) {
    // new document created : add one to count
    // 이웃상태인 경우만 이웃 수 증가
    if (state == 'APPROVE') {
      familyRef
        .update({ neighborCnt: FieldValue.increment(1) })
        .catch(e => {
          return { error: e.message };
        });
      console.log("%s neighborCnt incremented by 1", fid);
    }

  } else if (change.before.exists && change.after.exists) {

    // updating existing document : 상태가 APPROVE로 변경된경우 카운트 증가 
    // 이웃상태인 경우만 이웃 수 증가
    if (state == 'APPROVE') {
      familyRef
        .update({ neighborCnt: FieldValue.increment(1) })
        .catch(e => {
          return { error: e.message };
        });
      console.log("%s neighborCnt incremented by 1", fid);
    }

  } else if (!change.after.exists) {
    // deleting document : subtract one from count
    familyRef
      .update({ neighborCnt: FieldValue.increment(-1) })
      .catch(e => {
        return { error: e.message };
      });
    console.log("%s neighborCnt incremented by 1", fid);
  }

});