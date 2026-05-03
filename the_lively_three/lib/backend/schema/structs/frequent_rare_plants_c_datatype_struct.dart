// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FrequentRarePlantsCDatatypeStruct extends FFFirebaseStruct {
  FrequentRarePlantsCDatatypeStruct({
    String? color,
    String? plantType,
    double? totalPortions,
    int? distinctPlantCount,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _color = color,
        _plantType = plantType,
        _totalPortions = totalPortions,
        _distinctPlantCount = distinctPlantCount,
        super(firestoreUtilData);

  // "color" field.
  String? _color;
  String get color => _color ?? '';
  set color(String? val) => _color = val;

  bool hasColor() => _color != null;

  // "plant_type" field.
  String? _plantType;
  String get plantType => _plantType ?? '';
  set plantType(String? val) => _plantType = val;

  bool hasPlantType() => _plantType != null;

  // "total_portions" field.
  double? _totalPortions;
  double get totalPortions => _totalPortions ?? 0.0;
  set totalPortions(double? val) => _totalPortions = val;

  void incrementTotalPortions(double amount) =>
      totalPortions = totalPortions + amount;

  bool hasTotalPortions() => _totalPortions != null;

  // "distinct_plant_count" field.
  int? _distinctPlantCount;
  int get distinctPlantCount => _distinctPlantCount ?? 0;
  set distinctPlantCount(int? val) => _distinctPlantCount = val;

  void incrementDistinctPlantCount(int amount) =>
      distinctPlantCount = distinctPlantCount + amount;

  bool hasDistinctPlantCount() => _distinctPlantCount != null;

  static FrequentRarePlantsCDatatypeStruct fromMap(Map<String, dynamic> data) =>
      FrequentRarePlantsCDatatypeStruct(
        color: data['color'] as String?,
        plantType: data['plant_type'] as String?,
        totalPortions: castToType<double>(data['total_portions']),
        distinctPlantCount: castToType<int>(data['distinct_plant_count']),
      );

  static FrequentRarePlantsCDatatypeStruct? maybeFromMap(dynamic data) => data
          is Map
      ? FrequentRarePlantsCDatatypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'color': _color,
        'plant_type': _plantType,
        'total_portions': _totalPortions,
        'distinct_plant_count': _distinctPlantCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'color': serializeParam(
          _color,
          ParamType.String,
        ),
        'plant_type': serializeParam(
          _plantType,
          ParamType.String,
        ),
        'total_portions': serializeParam(
          _totalPortions,
          ParamType.double,
        ),
        'distinct_plant_count': serializeParam(
          _distinctPlantCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static FrequentRarePlantsCDatatypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      FrequentRarePlantsCDatatypeStruct(
        color: deserializeParam(
          data['color'],
          ParamType.String,
          false,
        ),
        plantType: deserializeParam(
          data['plant_type'],
          ParamType.String,
          false,
        ),
        totalPortions: deserializeParam(
          data['total_portions'],
          ParamType.double,
          false,
        ),
        distinctPlantCount: deserializeParam(
          data['distinct_plant_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'FrequentRarePlantsCDatatypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FrequentRarePlantsCDatatypeStruct &&
        color == other.color &&
        plantType == other.plantType &&
        totalPortions == other.totalPortions &&
        distinctPlantCount == other.distinctPlantCount;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([color, plantType, totalPortions, distinctPlantCount]);
}

FrequentRarePlantsCDatatypeStruct createFrequentRarePlantsCDatatypeStruct({
  String? color,
  String? plantType,
  double? totalPortions,
  int? distinctPlantCount,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    FrequentRarePlantsCDatatypeStruct(
      color: color,
      plantType: plantType,
      totalPortions: totalPortions,
      distinctPlantCount: distinctPlantCount,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

FrequentRarePlantsCDatatypeStruct? updateFrequentRarePlantsCDatatypeStruct(
  FrequentRarePlantsCDatatypeStruct? frequentRarePlantsCDatatype, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    frequentRarePlantsCDatatype
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addFrequentRarePlantsCDatatypeStructData(
  Map<String, dynamic> firestoreData,
  FrequentRarePlantsCDatatypeStruct? frequentRarePlantsCDatatype,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (frequentRarePlantsCDatatype == null) {
    return;
  }
  if (frequentRarePlantsCDatatype.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      frequentRarePlantsCDatatype.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final frequentRarePlantsCDatatypeData =
      getFrequentRarePlantsCDatatypeFirestoreData(
          frequentRarePlantsCDatatype, forFieldValue);
  final nestedData = frequentRarePlantsCDatatypeData
      .map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      frequentRarePlantsCDatatype.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getFrequentRarePlantsCDatatypeFirestoreData(
  FrequentRarePlantsCDatatypeStruct? frequentRarePlantsCDatatype, [
  bool forFieldValue = false,
]) {
  if (frequentRarePlantsCDatatype == null) {
    return {};
  }
  final firestoreData = mapToFirestore(frequentRarePlantsCDatatype.toMap());

  // Add any Firestore field values
  frequentRarePlantsCDatatype.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getFrequentRarePlantsCDatatypeListFirestoreData(
  List<FrequentRarePlantsCDatatypeStruct>? frequentRarePlantsCDatatypes,
) =>
    frequentRarePlantsCDatatypes
        ?.map((e) => getFrequentRarePlantsCDatatypeFirestoreData(e, true))
        .toList() ??
    [];
