import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DatasharingRecord extends FirestoreRecord {
  DatasharingRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "origin" field.
  String? _origin;
  String get origin => _origin ?? '';
  bool hasOrigin() => _origin != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "deleted_at" field.
  DateTime? _deletedAt;
  DateTime? get deletedAt => _deletedAt;
  bool hasDeletedAt() => _deletedAt != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  void _initializeFields() {
    _id = castToType<int>(snapshotData['id']);
    _name = snapshotData['name'] as String?;
    _description = snapshotData['description'] as String?;
    _origin = snapshotData['origin'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _deletedAt = snapshotData['deleted_at'] as DateTime?;
    _category = snapshotData['category'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('datasharing');

  static Stream<DatasharingRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DatasharingRecord.fromSnapshot(s));

  static Future<DatasharingRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DatasharingRecord.fromSnapshot(s));

  static DatasharingRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DatasharingRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DatasharingRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DatasharingRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DatasharingRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DatasharingRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDatasharingRecordData({
  int? id,
  String? name,
  String? description,
  String? origin,
  DateTime? createdAt,
  DateTime? deletedAt,
  String? category,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'origin': origin,
      'created_at': createdAt,
      'deleted_at': deletedAt,
      'category': category,
    }.withoutNulls,
  );

  return firestoreData;
}

class DatasharingRecordDocumentEquality implements Equality<DatasharingRecord> {
  const DatasharingRecordDocumentEquality();

  @override
  bool equals(DatasharingRecord? e1, DatasharingRecord? e2) {
    return e1?.id == e2?.id &&
        e1?.name == e2?.name &&
        e1?.description == e2?.description &&
        e1?.origin == e2?.origin &&
        e1?.createdAt == e2?.createdAt &&
        e1?.deletedAt == e2?.deletedAt &&
        e1?.category == e2?.category;
  }

  @override
  int hash(DatasharingRecord? e) => const ListEquality().hash([
        e?.id,
        e?.name,
        e?.description,
        e?.origin,
        e?.createdAt,
        e?.deletedAt,
        e?.category
      ]);

  @override
  bool isValidKey(Object? o) => o is DatasharingRecord;
}
