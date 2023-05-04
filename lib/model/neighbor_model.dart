import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class NeighborModel extends Equatable {
  String? id;
  String? fid;
  DocumentReference? fam;
  String? state;

  NeighborModel({
    this.id,
    this.fid,
    this.fam,
    this.state,
  });

  NeighborModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    id = map['fid1']!;
    fid = map['fid2'];
    fam = map['fam'];
    state = map['state'];
  }

  toJson() {
    return {
      'id': id,
      'fid': fid,
      'fam': fam,
      'state': state,
    };
  }

  NeighborModel copyWith({
    String? id,
    String? fid,
    DocumentReference? fam,
    String? state,
  }) {
    return NeighborModel(
      id: id,
      fid: fid,
      fam: fam,
      state: state,
    );
  }

  @override
  List<Object?> get props => [id, fid, fam, state];
}
