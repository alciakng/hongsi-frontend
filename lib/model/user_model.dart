import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

// ignore: must_be_immutable
class UserModel extends Equatable {
  int? uid;
  int? famId;
  String? email;
  String? username;
  String? channel;
  String? role;
  String? grade;
  String? level;
  bool? leader;
  String? bio;
  int? age;
  String? job;
  String? addr1;
  String? addr2;
  String? profilePicPath;
  List<String>? appUserRoles;
  int? createdAt;
  int? updatedAt;

  UserModel(
      {this.uid,
      this.famId,
      this.email,
      this.username,
      this.channel,
      this.role,
      this.grade,
      this.level,
      this.leader,
      this.bio,
      this.age,
      this.job,
      this.addr1,
      this.addr2,
      this.profilePicPath,
      this.appUserRoles,
      this.createdAt,
      this.updatedAt});

  UserModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    uid = map['uid'];
    famId = map['famId'];
    email = map['email']!;
    username = map['username']!;
    channel = map['channel']!;
    role = map['role'];
    grade = map['grade'];
    level = map['level'];
    leader = map['leader'];
    bio = map['bio'];
    age = map['age'];
    job = map['job'];
    addr1 = map['addr1'];
    addr2 = map['addr2'];
    profilePicPath = map['profilePicPath'];

    if (map['createdAt'] != null) {
      createdAt = DateTime.parse(map['createdAt']).millisecondsSinceEpoch;
    }

    if (map['updatedAt'] != null) {
      updatedAt = DateTime.parse(map['updatedAt']).millisecondsSinceEpoch;
    }

    /*
    if (map['fam'] != null) {
      fam = Map<dynamic, dynamic>.from(map['fam']);
    }
    */

    // 리스트 아이템 추가
    if (map['appUserRoles'] != null) {
      appUserRoles = <String>[];
      map['appUserRoles'].forEach((value) {
        appUserRoles!.add(value);
      });
    }
  }

  toJson() {
    return {
      'uid': uid,
      'famId': famId,
      'email': email,
      'username': username,
      'channel': channel,
      'role': role,
      'grade': grade,
      'level': level,
      'leader': leader,
      'bio': bio,
      'age': age,
      'job': job,
      'addr1': addr1,
      'addr2': addr2,
      'profilePicPath': profilePicPath,
      'appUserRoles': appUserRoles,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  UserModel copyWith(
      {int? uid,
      int? famId,
      String? email,
      String? username,
      String? channel,
      String? role,
      String? grade,
      String? level,
      bool? leader,
      String? bio,
      int? age,
      String? job,
      String? addr1,
      String? addr2,
      String? profilePicPath,
      List<String>? appUserRoles,
      int? createdAt,
      int? updatedAt}) {
    return UserModel(
        uid: uid,
        famId: famId,
        email: email,
        username: username,
        channel: channel,
        role: role,
        grade: grade,
        level: level,
        leader: leader ?? this.leader,
        bio: bio ?? this.bio,
        age: age ?? this.age,
        job: job ?? this.job,
        addr1: addr1 ?? this.addr1,
        addr2: addr2 ?? this.addr2,
        profilePicPath: profilePicPath,
        appUserRoles: appUserRoles,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  @override
  List<Object?> get props => [
        uid,
        famId,
        email,
        username,
        channel,
        role,
        grade,
        level,
        leader,
        bio,
        age,
        job,
        addr1,
        addr2,
        profilePicPath,
        appUserRoles,
        createdAt,
        updatedAt
      ];
}
