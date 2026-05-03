import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RelDatasharingUserRecord extends FirestoreRecord {
  RelDatasharingUserRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "id_datasharing" field.
  DocumentReference? _idDatasharing;
  DocumentReference? get idDatasharing => _idDatasharing;
  bool hasIdDatasharing() => _idDatasharing != null;

  // "id_user" field.
  DocumentReference? _idUser;
  DocumentReference? get idUser => _idUser;
  bool hasIdUser() => _idUser != null;

  // "opt_in" field.
  bool? _optIn;
  bool get optIn => _optIn ?? false;
  bool hasOptIn() => _optIn != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "deleted_at" field.
  DateTime? _deletedAt;
  DateTime? get deletedAt => _deletedAt;
  bool hasDeletedAt() => _deletedAt != null;

  void _initializeFields() {
    _idDatasharing = snapshotData['id_datasharing'] as DocumentReference?;
    _idUser = snapshotData['id_user'] as DocumentReference?;
    _optIn = snapshotData['opt_in'] as bool?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _deletedAt = snapshotData['deleted_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('rel_datasharing_user');

  static Stream<RelDatasharingUserRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RelDatasharingUserRecord.fromSnapshot(s));

  static Future<RelDatasharingUserRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => RelDatasharingUserRecord.fromSnapshot(s));

  static RelDatasharingUserRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RelDatasharingUserRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RelDatasharingUserRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RelDatasharingUserRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RelDatasharingUserRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RelDatasharingUserRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRelDatasharingUserRecordData({
  DocumentReference? idDatasharing,
  DocumentReference? idUser,
  bool? optIn,
  DateTime? createdAt,
  DateTime? deletedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'id_datasharing': idDatasharing,
      'id_user': idUser,
      'opt_in': optIn,
      'created_at': createdAt,
      'deleted_at': deletedAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class RelDatasharingUserRecordDocumentEquality
    implements Equality<RelDatasharingUserRecord> {
  const RelDatasharingUserRecordDocumentEquality();

  @override
  bool equals(RelDatasharingUserRecord? e1, RelDatasharingUserRecord? e2) {
    return e1?.idDatasharing == e2?.idDatasharing &&
        e1?.idUser == e2?.idUser &&
        e1?.optIn == e2?.optIn &&
        e1?.createdAt == e2?.createdAt &&
        e1?.deletedAt == e2?.deletedAt;
  }

  @override
  int hash(RelDatasharingUserRecord? e) => const ListEquality().hash(
      [e?.idDatasharing, e?.idUser, e?.optIn, e?.createdAt, e?.deletedAt]);

  @override
  bool isValidKey(Object? o) => o is RelDatasharingUserRecord;
}
