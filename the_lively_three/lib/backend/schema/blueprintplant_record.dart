import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BlueprintplantRecord extends FirestoreRecord {
  BlueprintplantRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "species" field.
  String? _species;
  String get species => _species ?? '';
  bool hasSpecies() => _species != null;

  // "genus" field.
  String? _genus;
  String get genus => _genus ?? '';
  bool hasGenus() => _genus != null;

  // "origin" field.
  String? _origin;
  String get origin => _origin ?? '';
  bool hasOrigin() => _origin != null;

  // "color" field.
  String? _color;
  String get color => _color ?? '';
  bool hasColor() => _color != null;

  // "hex" field.
  Color? _hex;
  Color? get hex => _hex;
  bool hasHex() => _hex != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "created" field.
  String? _created;
  String get created => _created ?? '';
  bool hasCreated() => _created != null;

  // "plantcategory" field.
  String? _plantcategory;
  String get plantcategory => _plantcategory ?? '';
  bool hasPlantcategory() => _plantcategory != null;

  void _initializeFields() {
    _species = snapshotData['species'] as String?;
    _genus = snapshotData['genus'] as String?;
    _origin = snapshotData['origin'] as String?;
    _color = snapshotData['color'] as String?;
    _hex = getSchemaColor(snapshotData['hex']);
    _name = snapshotData['name'] as String?;
    _created = snapshotData['created'] as String?;
    _plantcategory = snapshotData['plantcategory'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('blueprintplant');

  static Stream<BlueprintplantRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BlueprintplantRecord.fromSnapshot(s));

  static Future<BlueprintplantRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BlueprintplantRecord.fromSnapshot(s));

  static BlueprintplantRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BlueprintplantRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BlueprintplantRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BlueprintplantRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BlueprintplantRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BlueprintplantRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBlueprintplantRecordData({
  String? species,
  String? genus,
  String? origin,
  String? color,
  Color? hex,
  String? name,
  String? created,
  String? plantcategory,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'species': species,
      'genus': genus,
      'origin': origin,
      'color': color,
      'hex': hex,
      'name': name,
      'created': created,
      'plantcategory': plantcategory,
    }.withoutNulls,
  );

  return firestoreData;
}

class BlueprintplantRecordDocumentEquality
    implements Equality<BlueprintplantRecord> {
  const BlueprintplantRecordDocumentEquality();

  @override
  bool equals(BlueprintplantRecord? e1, BlueprintplantRecord? e2) {
    return e1?.species == e2?.species &&
        e1?.genus == e2?.genus &&
        e1?.origin == e2?.origin &&
        e1?.color == e2?.color &&
        e1?.hex == e2?.hex &&
        e1?.name == e2?.name &&
        e1?.created == e2?.created &&
        e1?.plantcategory == e2?.plantcategory;
  }

  @override
  int hash(BlueprintplantRecord? e) => const ListEquality().hash([
        e?.species,
        e?.genus,
        e?.origin,
        e?.color,
        e?.hex,
        e?.name,
        e?.created,
        e?.plantcategory
      ]);

  @override
  bool isValidKey(Object? o) => o is BlueprintplantRecord;
}
