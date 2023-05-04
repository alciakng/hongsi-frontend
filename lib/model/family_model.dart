import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hongsi_project/helper/enum.dart';

// ignore: must_be_immutable
class FamilyModel extends Equatable {
  String? id;
  late String name;
  List<Map<dynamic, dynamic>>? userList;
  late String? sido;
  String? sigungu;
  late String bio;
  String? interestField;
  List<Map<String, dynamic>>? anniversarys;
  String? bannerImage;
  String? familyImage;
  late int userCnt;
  late int neighborCnt;
  late int notificationCnt;
  late int neighborRequestCnt;
  late int familyRequestCnt;
  late int normalCnt;
  String? createdAt;
  String? updatedAt;

  FamilyModel({
    this.id,
    required this.name,
    this.userList,
    required this.sido,
    this.sigungu,
    required this.bio,
    this.interestField,
    this.anniversarys,
    this.bannerImage,
    this.familyImage,
    // default 카운트 0
    this.userCnt = 0,
    this.neighborCnt = 0,
    this.notificationCnt = 0,
    this.neighborRequestCnt = 0,
    this.familyRequestCnt = 0,
    this.normalCnt = 0,
    this.createdAt,
    this.updatedAt,
  });

  FamilyModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    id = map['id'];
    name = map['name'];
    sido = map['sido'];
    sigungu = map['sigungu'];
    bio = map['bio'];
    interestField = map['interestField'];
    bannerImage = map['bannerImage'];
    familyImage = map['familyImage'];
    userCnt = map['userCnt'] ?? 0;
    neighborCnt = map['neighborCnt'] ?? 0;
    notificationCnt = map['notificationCnt'] ?? 0;
    neighborRequestCnt = map['neighborRequestCnt'] ?? 0;
    familyRequestCnt = map['familyRequestCnt'] ?? 0;
    normalCnt = map['normalCnt'] ?? 0;
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];

    if (map['userList'] != null) {
      userList = <Map<dynamic, dynamic>>[];
      map['userList'].forEach((value) {
        userList!.add(value);
      });
    }

    if (map['anniversarys'] != null) {
      anniversarys = <Map<String, dynamic>>[];
      map['anniversarys'].forEach((value) {
        anniversarys!.add(value);
      });
    }
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'userList': userList,
      if (sigungu != null) 'sido': sido,
      if (sigungu != null) 'sigungu': sigungu,
      'bio': bio,
      if (interestField != null) 'interestField': interestField,
      if (anniversarys != null) 'anniversarys': anniversarys,
      if (bannerImage != null) 'bannerImage': bannerImage,
      if (familyImage != null) 'familyImage': familyImage,
      'userCnt': userCnt,
      'neighborCnt': neighborCnt,
      'notificationCnt': notificationCnt,
      'neighborRequestCnt': neighborRequestCnt,
      'familyRequestCnt': familyRequestCnt,
      'normalCnt': normalCnt,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  FamilyModel copyWith({
    String? id,
    required String name,
    List<Map<dynamic, dynamic>>? userList,
    String? sido,
    String? sigungu,
    required String bio,
    String? interestField,
    List<Map<String, dynamic>>? anniversarys,
    String? bannerImage,
    String? familyImage,
    int userCnt = 0,
    int neighborCnt = 0,
    int notificationCnt = 0,
    int neighborRequestCnt = 0,
    int familyRequestCnt = 0,
    int normalCnt = 0,
    String? createdAt,
    String? updatedAt,
    String? fcmToken,
  }) {
    return FamilyModel(
        id: id,
        name: name,
        userList: this.userList,
        sido: sido ?? this.sido,
        sigungu: sigungu ?? this.sigungu,
        bio: this.bio,
        interestField: interestField ?? this.interestField,
        anniversarys: anniversarys ?? this.anniversarys,
        bannerImage: bannerImage ?? this.bannerImage,
        familyImage: familyImage ?? this.familyImage,
        userCnt: this.userCnt,
        neighborCnt: this.neighborCnt,
        notificationCnt: this.notificationCnt,
        neighborRequestCnt: this.neighborRequestCnt,
        familyRequestCnt: this.familyRequestCnt,
        normalCnt: this.normalCnt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        userList,
        sido,
        sigungu,
        bio,
        interestField,
        anniversarys,
        bannerImage,
        familyImage,
        userCnt,
        neighborCnt,
        notificationCnt,
        neighborRequestCnt,
        familyRequestCnt,
        normalCnt,
        createdAt,
        updatedAt,
      ];
}
