import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class NotifyModel extends Equatable {
  String? id;
  late String type;
  late Map<String, dynamic> notification;
  late String? createdAt;
  late String? message;

  NotifyModel(
      {this.id,
      required this.type,
      required this.notification,
      required this.createdAt,
      this.message});

  NotifyModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    id = map['id'];
    type = map['type'];
    createdAt = map['createdAt'];
    message = map['message'];

    if (map['notification'] != null) {
      notification = Map<String, dynamic>.from(map['notification']);
    }
  }

  toJson() {
    return {
      'id': id,
      'type': type,
      'notification': notification,
      'createdAt': createdAt,
      'message': message,
    };
  }

  NotifyModel copyWith({
    String? id,
    required String type,
    required Map<String, dynamic> notification,
    required String createdAt,
    String? message,
  }) {
    return NotifyModel(
      id: id,
      type: type,
      notification: notification,
      createdAt: createdAt,
      message: message,
    );
  }

  @override
  List<Object?> get props => [id, type, notification, createdAt, message];
}
