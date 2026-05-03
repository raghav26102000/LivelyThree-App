import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ClimateconditionRecord extends FirestoreRecord {
  ClimateconditionRecord._(
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

  // "regions" field.
  String? _regions;
  String get regions => _regions ?? '';
  bool hasRegions() => _regions != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _description = snapshotData['description'] as String?;
    _regions = snapshotData['regions'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('climatecondition');

  static Stream<ClimateconditionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ClimateconditionRecord.fromSnapshot(s));

  static Future<ClimateconditionRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ClimateconditionRecord.fromSnapshot(s));

  static ClimateconditionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ClimateconditionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ClimateconditionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ClimateconditionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ClimateconditionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ClimateconditionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createClimateconditionRecordData({
  String? name,
  String? description,
  String? regions,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'description': description,
      'regions': regions,
    }.withoutNulls,
  );

  return firestoreData;
}

class ClimateconditionRecordDocumentEquality
    implements Equality<ClimateconditionRecord> {
  const ClimateconditionRecordDocumentEquality();

  @override
  bool equals(ClimateconditionRecord? e1, ClimateconditionRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.description == e2?.description &&
        e1?.regions == e2?.regions;
  }

  @override
  int hash(ClimateconditionRecord? e) =>
      const ListEquality().hash([e?.name, e?.description, e?.regions]);

  @override
  bool isValidKey(Object? o) => o is ClimateconditionRecord;
}
