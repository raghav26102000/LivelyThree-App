import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AgrimethodRecord extends FirestoreRecord {
  AgrimethodRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "agriMethodName" field.
  String? _agriMethodName;
  String get agriMethodName => _agriMethodName ?? '';
  bool hasAgriMethodName() => _agriMethodName != null;

  // "agriMethodDescription" field.
  String? _agriMethodDescription;
  String get agriMethodDescription => _agriMethodDescription ?? '';
  bool hasAgriMethodDescription() => _agriMethodDescription != null;

  void _initializeFields() {
    _agriMethodName = snapshotData['agriMethodName'] as String?;
    _agriMethodDescription = snapshotData['agriMethodDescription'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('agrimethod');

  static Stream<AgrimethodRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AgrimethodRecord.fromSnapshot(s));

  static Future<AgrimethodRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AgrimethodRecord.fromSnapshot(s));

  static AgrimethodRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AgrimethodRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AgrimethodRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AgrimethodRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AgrimethodRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AgrimethodRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAgrimethodRecordData({
  String? agriMethodName,
  String? agriMethodDescription,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'agriMethodName': agriMethodName,
      'agriMethodDescription': agriMethodDescription,
    }.withoutNulls,
  );

  return firestoreData;
}

class AgrimethodRecordDocumentEquality implements Equality<AgrimethodRecord> {
  const AgrimethodRecordDocumentEquality();

  @override
  bool equals(AgrimethodRecord? e1, AgrimethodRecord? e2) {
    return e1?.agriMethodName == e2?.agriMethodName &&
        e1?.agriMethodDescription == e2?.agriMethodDescription;
  }

  @override
  int hash(AgrimethodRecord? e) =>
      const ListEquality().hash([e?.agriMethodName, e?.agriMethodDescription]);

  @override
  bool isValidKey(Object? o) => o is AgrimethodRecord;
}
