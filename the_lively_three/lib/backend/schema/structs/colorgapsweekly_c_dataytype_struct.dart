// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ColorgapsweeklyCDataytypeStruct extends FFFirebaseStruct {
  ColorgapsweeklyCDataytypeStruct({
    String? color,
    double? totalPortions,
    int? distinctPlantCount,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _color = color,
        _totalPortions = totalPortions,
        _distinctPlantCount = distinctPlantCount,
        super(firestoreUtilData);

  // "color" field.
  String? _color;
  String get color => _color ?? '';
  set color(String? val) => _color = val;

  bool hasColor() => _color != null;

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

  static ColorgapsweeklyCDataytypeStruct fromMap(Map<String, dynamic> data) =>
      ColorgapsweeklyCDataytypeStruct(
        color: data['color'] as String?,
        totalPortions: castToType<double>(data['total_portions']),
        distinctPlantCount: castToType<int>(data['distinct_plant_count']),
      );

  static ColorgapsweeklyCDataytypeStruct? maybeFromMap(dynamic data) => data
          is Map
      ? ColorgapsweeklyCDataytypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'color': _color,
        'total_portions': _totalPortions,
        'distinct_plant_count': _distinctPlantCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'color': serializeParam(
          _color,
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

  static ColorgapsweeklyCDataytypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ColorgapsweeklyCDataytypeStruct(
        color: deserializeParam(
          data['color'],
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
  String toString() => 'ColorgapsweeklyCDataytypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ColorgapsweeklyCDataytypeStruct &&
        color == other.color &&
        totalPortions == other.totalPortions &&
        distinctPlantCount == other.distinctPlantCount;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([color, totalPortions, distinctPlantCount]);
}

ColorgapsweeklyCDataytypeStruct createColorgapsweeklyCDataytypeStruct({
  String? color,
  double? totalPortions,
  int? distinctPlantCount,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ColorgapsweeklyCDataytypeStruct(
      color: color,
      totalPortions: totalPortions,
      distinctPlantCount: distinctPlantCount,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ColorgapsweeklyCDataytypeStruct? updateColorgapsweeklyCDataytypeStruct(
  ColorgapsweeklyCDataytypeStruct? colorgapsweeklyCDataytype, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    colorgapsweeklyCDataytype
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addColorgapsweeklyCDataytypeStructData(
  Map<String, dynamic> firestoreData,
  ColorgapsweeklyCDataytypeStruct? colorgapsweeklyCDataytype,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (colorgapsweeklyCDataytype == null) {
    return;
  }
  if (colorgapsweeklyCDataytype.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      colorgapsweeklyCDataytype.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final colorgapsweeklyCDataytypeData =
      getColorgapsweeklyCDataytypeFirestoreData(
          colorgapsweeklyCDataytype, forFieldValue);
  final nestedData =
      colorgapsweeklyCDataytypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      colorgapsweeklyCDataytype.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getColorgapsweeklyCDataytypeFirestoreData(
  ColorgapsweeklyCDataytypeStruct? colorgapsweeklyCDataytype, [
  bool forFieldValue = false,
]) {
  if (colorgapsweeklyCDataytype == null) {
    return {};
  }
  final firestoreData = mapToFirestore(colorgapsweeklyCDataytype.toMap());

  // Add any Firestore field values
  colorgapsweeklyCDataytype.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getColorgapsweeklyCDataytypeListFirestoreData(
  List<ColorgapsweeklyCDataytypeStruct>? colorgapsweeklyCDataytypes,
) =>
    colorgapsweeklyCDataytypes
        ?.map((e) => getColorgapsweeklyCDataytypeFirestoreData(e, true))
        .toList() ??
    [];
