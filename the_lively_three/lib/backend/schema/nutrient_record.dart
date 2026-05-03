import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NutrientRecord extends FirestoreRecord {
  NutrientRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _description = snapshotData['description'] as String?;
    _category = snapshotData['category'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('nutrient');

  static Stream<NutrientRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NutrientRecord.fromSnapshot(s));

  static Future<NutrientRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NutrientRecord.fromSnapshot(s));

  static NutrientRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NutrientRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NutrientRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NutrientRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NutrientRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NutrientRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNutrientRecordData({
  String? name,
  String? description,
  String? category,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'description': description,
      'category': category,
    }.withoutNulls,
  );

  return firestoreData;
}

class NutrientRecordDocumentEquality implements Equality<NutrientRecord> {
  const NutrientRecordDocumentEquality();

  @override
  bool equals(NutrientRecord? e1, NutrientRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.description == e2?.description &&
        e1?.category == e2?.category;
  }

  @override
  int hash(NutrientRecord? e) =>
      const ListEquality().hash([e?.name, e?.description, e?.category]);

  @override
  bool isValidKey(Object? o) => o is NutrientRecord;
}
