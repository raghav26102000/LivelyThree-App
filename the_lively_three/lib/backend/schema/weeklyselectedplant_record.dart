import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WeeklyselectedplantRecord extends FirestoreRecord {
  WeeklyselectedplantRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "week" field.
  int? _week;
  int get week => _week ?? 0;
  bool hasWeek() => _week != null;

  // "weeklyhealthscore" field.
  double? _weeklyhealthscore;
  double get weeklyhealthscore => _weeklyhealthscore ?? 0.0;
  bool hasWeeklyhealthscore() => _weeklyhealthscore != null;

  // "communityweeklyhealthscore" field.
  double? _communityweeklyhealthscore;
  double get communityweeklyhealthscore => _communityweeklyhealthscore ?? 0.0;
  bool hasCommunityweeklyhealthscore() => _communityweeklyhealthscore != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "deleted_at" field.
  DateTime? _deletedAt;
  DateTime? get deletedAt => _deletedAt;
  bool hasDeletedAt() => _deletedAt != null;

  // "deleted" field.
  bool? _deleted;
  bool get deleted => _deleted ?? false;
  bool hasDeleted() => _deleted != null;

  // "id_selectedplant" field.
  DocumentReference? _idSelectedplant;
  DocumentReference? get idSelectedplant => _idSelectedplant;
  bool hasIdSelectedplant() => _idSelectedplant != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _week = castToType<int>(snapshotData['week']);
    _weeklyhealthscore = castToType<double>(snapshotData['weeklyhealthscore']);
    _communityweeklyhealthscore =
        castToType<double>(snapshotData['communityweeklyhealthscore']);
    _createdAt = snapshotData['created_at'] as DateTime?;
    _deletedAt = snapshotData['deleted_at'] as DateTime?;
    _deleted = snapshotData['deleted'] as bool?;
    _idSelectedplant = snapshotData['id_selectedplant'] as DocumentReference?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('weeklyselectedplant')
          : FirebaseFirestore.instance.collectionGroup('weeklyselectedplant');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('weeklyselectedplant').doc(id);

  static Stream<WeeklyselectedplantRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => WeeklyselectedplantRecord.fromSnapshot(s));

  static Future<WeeklyselectedplantRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => WeeklyselectedplantRecord.fromSnapshot(s));

  static WeeklyselectedplantRecord fromSnapshot(DocumentSnapshot snapshot) =>
      WeeklyselectedplantRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static WeeklyselectedplantRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      WeeklyselectedplantRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'WeeklyselectedplantRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is WeeklyselectedplantRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createWeeklyselectedplantRecordData({
  int? week,
  double? weeklyhealthscore,
  double? communityweeklyhealthscore,
  DateTime? createdAt,
  DateTime? deletedAt,
  bool? deleted,
  DocumentReference? idSelectedplant,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'week': week,
      'weeklyhealthscore': weeklyhealthscore,
      'communityweeklyhealthscore': communityweeklyhealthscore,
      'created_at': createdAt,
      'deleted_at': deletedAt,
      'deleted': deleted,
      'id_selectedplant': idSelectedplant,
    }.withoutNulls,
  );

  return firestoreData;
}

class WeeklyselectedplantRecordDocumentEquality
    implements Equality<WeeklyselectedplantRecord> {
  const WeeklyselectedplantRecordDocumentEquality();

  @override
  bool equals(WeeklyselectedplantRecord? e1, WeeklyselectedplantRecord? e2) {
    return e1?.week == e2?.week &&
        e1?.weeklyhealthscore == e2?.weeklyhealthscore &&
        e1?.communityweeklyhealthscore == e2?.communityweeklyhealthscore &&
        e1?.createdAt == e2?.createdAt &&
        e1?.deletedAt == e2?.deletedAt &&
        e1?.deleted == e2?.deleted &&
        e1?.idSelectedplant == e2?.idSelectedplant;
  }

  @override
  int hash(WeeklyselectedplantRecord? e) => const ListEquality().hash([
        e?.week,
        e?.weeklyhealthscore,
        e?.communityweeklyhealthscore,
        e?.createdAt,
        e?.deletedAt,
        e?.deleted,
        e?.idSelectedplant
      ]);

  @override
  bool isValidKey(Object? o) => o is WeeklyselectedplantRecord;
}
