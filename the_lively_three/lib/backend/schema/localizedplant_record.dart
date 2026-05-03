import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LocalizedplantRecord extends FirestoreRecord {
  LocalizedplantRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "id_blueprintplant" field.
  DocumentReference? _idBlueprintplant;
  DocumentReference? get idBlueprintplant => _idBlueprintplant;
  bool hasIdBlueprintplant() => _idBlueprintplant != null;

  // "id_origincountry" field.
  DocumentReference? _idOrigincountry;
  DocumentReference? get idOrigincountry => _idOrigincountry;
  bool hasIdOrigincountry() => _idOrigincountry != null;

  // "id_agrimethod" field.
  DocumentReference? _idAgrimethod;
  DocumentReference? get idAgrimethod => _idAgrimethod;
  bool hasIdAgrimethod() => _idAgrimethod != null;

  // "id_selectedplant" field.
  DocumentReference? _idSelectedplant;
  DocumentReference? get idSelectedplant => _idSelectedplant;
  bool hasIdSelectedplant() => _idSelectedplant != null;

  // "id_climatecondition" field.
  DocumentReference? _idClimatecondition;
  DocumentReference? get idClimatecondition => _idClimatecondition;
  bool hasIdClimatecondition() => _idClimatecondition != null;

  void _initializeFields() {
    _idBlueprintplant = snapshotData['id_blueprintplant'] as DocumentReference?;
    _idOrigincountry = snapshotData['id_origincountry'] as DocumentReference?;
    _idAgrimethod = snapshotData['id_agrimethod'] as DocumentReference?;
    _idSelectedplant = snapshotData['id_selectedplant'] as DocumentReference?;
    _idClimatecondition =
        snapshotData['id_climatecondition'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('localizedplant');

  static Stream<LocalizedplantRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LocalizedplantRecord.fromSnapshot(s));

  static Future<LocalizedplantRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LocalizedplantRecord.fromSnapshot(s));

  static LocalizedplantRecord fromSnapshot(DocumentSnapshot snapshot) =>
      LocalizedplantRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LocalizedplantRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LocalizedplantRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LocalizedplantRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LocalizedplantRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLocalizedplantRecordData({
  DocumentReference? idBlueprintplant,
  DocumentReference? idOrigincountry,
  DocumentReference? idAgrimethod,
  DocumentReference? idSelectedplant,
  DocumentReference? idClimatecondition,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'id_blueprintplant': idBlueprintplant,
      'id_origincountry': idOrigincountry,
      'id_agrimethod': idAgrimethod,
      'id_selectedplant': idSelectedplant,
      'id_climatecondition': idClimatecondition,
    }.withoutNulls,
  );

  return firestoreData;
}

class LocalizedplantRecordDocumentEquality
    implements Equality<LocalizedplantRecord> {
  const LocalizedplantRecordDocumentEquality();

  @override
  bool equals(LocalizedplantRecord? e1, LocalizedplantRecord? e2) {
    return e1?.idBlueprintplant == e2?.idBlueprintplant &&
        e1?.idOrigincountry == e2?.idOrigincountry &&
        e1?.idAgrimethod == e2?.idAgrimethod &&
        e1?.idSelectedplant == e2?.idSelectedplant &&
        e1?.idClimatecondition == e2?.idClimatecondition;
  }

  @override
  int hash(LocalizedplantRecord? e) => const ListEquality().hash([
        e?.idBlueprintplant,
        e?.idOrigincountry,
        e?.idAgrimethod,
        e?.idSelectedplant,
        e?.idClimatecondition
      ]);

  @override
  bool isValidKey(Object? o) => o is LocalizedplantRecord;
}
