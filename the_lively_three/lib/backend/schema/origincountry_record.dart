import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrigincountryRecord extends FirestoreRecord {
  OrigincountryRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Country" field.
  String? _country;
  String get country => _country ?? '';
  bool hasCountry() => _country != null;

  // "Region" field.
  String? _region;
  String get region => _region ?? '';
  bool hasRegion() => _region != null;

  // "Population" field.
  String? _population;
  String get population => _population ?? '';
  bool hasPopulation() => _population != null;

  // "Area" field.
  String? _area;
  String get area => _area ?? '';
  bool hasArea() => _area != null;

  void _initializeFields() {
    _country = snapshotData['Country'] as String?;
    _region = snapshotData['Region'] as String?;
    _population = snapshotData['Population'] as String?;
    _area = snapshotData['Area'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('origincountry');

  static Stream<OrigincountryRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrigincountryRecord.fromSnapshot(s));

  static Future<OrigincountryRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrigincountryRecord.fromSnapshot(s));

  static OrigincountryRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OrigincountryRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrigincountryRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrigincountryRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrigincountryRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrigincountryRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrigincountryRecordData({
  String? country,
  String? region,
  String? population,
  String? area,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Country': country,
      'Region': region,
      'Population': population,
      'Area': area,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrigincountryRecordDocumentEquality
    implements Equality<OrigincountryRecord> {
  const OrigincountryRecordDocumentEquality();

  @override
  bool equals(OrigincountryRecord? e1, OrigincountryRecord? e2) {
    return e1?.country == e2?.country &&
        e1?.region == e2?.region &&
        e1?.population == e2?.population &&
        e1?.area == e2?.area;
  }

  @override
  int hash(OrigincountryRecord? e) => const ListEquality()
      .hash([e?.country, e?.region, e?.population, e?.area]);

  @override
  bool isValidKey(Object? o) => o is OrigincountryRecord;
}
