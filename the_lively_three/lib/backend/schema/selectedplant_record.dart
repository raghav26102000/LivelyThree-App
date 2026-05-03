import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SelectedplantRecord extends FirestoreRecord {
  SelectedplantRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "id_user" field.
  DocumentReference? _idUser;
  DocumentReference? get idUser => _idUser;
  bool hasIdUser() => _idUser != null;

  // "id_localizedplant" field.
  DocumentReference? _idLocalizedplant;
  DocumentReference? get idLocalizedplant => _idLocalizedplant;
  bool hasIdLocalizedplant() => _idLocalizedplant != null;

  void _initializeFields() {
    _createdAt = snapshotData['created_at'] as DateTime?;
    _idUser = snapshotData['id_user'] as DocumentReference?;
    _idLocalizedplant = snapshotData['id_localizedplant'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('selectedplant');

  static Stream<SelectedplantRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SelectedplantRecord.fromSnapshot(s));

  static Future<SelectedplantRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SelectedplantRecord.fromSnapshot(s));

  static SelectedplantRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SelectedplantRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SelectedplantRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SelectedplantRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SelectedplantRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SelectedplantRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSelectedplantRecordData({
  DateTime? createdAt,
  DocumentReference? idUser,
  DocumentReference? idLocalizedplant,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'created_at': createdAt,
      'id_user': idUser,
      'id_localizedplant': idLocalizedplant,
    }.withoutNulls,
  );

  return firestoreData;
}

class SelectedplantRecordDocumentEquality
    implements Equality<SelectedplantRecord> {
  const SelectedplantRecordDocumentEquality();

  @override
  bool equals(SelectedplantRecord? e1, SelectedplantRecord? e2) {
    return e1?.createdAt == e2?.createdAt &&
        e1?.idUser == e2?.idUser &&
        e1?.idLocalizedplant == e2?.idLocalizedplant;
  }

  @override
  int hash(SelectedplantRecord? e) =>
      const ListEquality().hash([e?.createdAt, e?.idUser, e?.idLocalizedplant]);

  @override
  bool isValidKey(Object? o) => o is SelectedplantRecord;
}
