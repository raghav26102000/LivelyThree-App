// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DashboardPlantPortionDataTypeStruct extends FFFirebaseStruct {
  DashboardPlantPortionDataTypeStruct({
    String? color,
    String? plantType,
    double? totalPortions,
    int? distinctPlantCount,
    int? numConsumers,
    double? pctConsumers,
    double? avgPortionsPerPerson,
    double? avgPortionsPerConsumer,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _color = color,
        _plantType = plantType,
        _totalPortions = totalPortions,
        _distinctPlantCount = distinctPlantCount,
        _numConsumers = numConsumers,
        _pctConsumers = pctConsumers,
        _avgPortionsPerPerson = avgPortionsPerPerson,
        _avgPortionsPerConsumer = avgPortionsPerConsumer,
        super(firestoreUtilData);

  // "color" field.
  String? _color;
  String get color => _color ?? '';
  set color(String? val) => _color = val;

  bool hasColor() => _color != null;

  // "plantType" field.
  String? _plantType;
  String get plantType => _plantType ?? '';
  set plantType(String? val) => _plantType = val;

  bool hasPlantType() => _plantType != null;

  // "totalPortions" field.
  double? _totalPortions;
  double get totalPortions => _totalPortions ?? 0.0;
  set totalPortions(double? val) => _totalPortions = val;

  void incrementTotalPortions(double amount) =>
      totalPortions = totalPortions + amount;

  bool hasTotalPortions() => _totalPortions != null;

  // "distinctPlantCount" field.
  int? _distinctPlantCount;
  int get distinctPlantCount => _distinctPlantCount ?? 0;
  set distinctPlantCount(int? val) => _distinctPlantCount = val;

  void incrementDistinctPlantCount(int amount) =>
      distinctPlantCount = distinctPlantCount + amount;

  bool hasDistinctPlantCount() => _distinctPlantCount != null;

  // "numConsumers" field.
  int? _numConsumers;
  int get numConsumers => _numConsumers ?? 0;
  set numConsumers(int? val) => _numConsumers = val;

  void incrementNumConsumers(int amount) =>
      numConsumers = numConsumers + amount;

  bool hasNumConsumers() => _numConsumers != null;

  // "pctConsumers" field.
  double? _pctConsumers;
  double get pctConsumers => _pctConsumers ?? 0.0;
  set pctConsumers(double? val) => _pctConsumers = val;

  void incrementPctConsumers(double amount) =>
      pctConsumers = pctConsumers + amount;

  bool hasPctConsumers() => _pctConsumers != null;

  // "avgPortionsPerPerson" field.
  double? _avgPortionsPerPerson;
  double get avgPortionsPerPerson => _avgPortionsPerPerson ?? 0.0;
  set avgPortionsPerPerson(double? val) => _avgPortionsPerPerson = val;

  void incrementAvgPortionsPerPerson(double amount) =>
      avgPortionsPerPerson = avgPortionsPerPerson + amount;

  bool hasAvgPortionsPerPerson() => _avgPortionsPerPerson != null;

  // "avgPortionsPerConsumer" field.
  double? _avgPortionsPerConsumer;
  double get avgPortionsPerConsumer => _avgPortionsPerConsumer ?? 0.0;
  set avgPortionsPerConsumer(double? val) => _avgPortionsPerConsumer = val;

  void incrementAvgPortionsPerConsumer(double amount) =>
      avgPortionsPerConsumer = avgPortionsPerConsumer + amount;

  bool hasAvgPortionsPerConsumer() => _avgPortionsPerConsumer != null;

  static DashboardPlantPortionDataTypeStruct fromMap(
          Map<String, dynamic> data) =>
      DashboardPlantPortionDataTypeStruct(
        color: data['color'] as String?,
        plantType: data['plantType'] as String?,
        totalPortions: castToType<double>(data['totalPortions']),
        distinctPlantCount: castToType<int>(data['distinctPlantCount']),
        numConsumers: castToType<int>(data['numConsumers']),
        pctConsumers: castToType<double>(data['pctConsumers']),
        avgPortionsPerPerson: castToType<double>(data['avgPortionsPerPerson']),
        avgPortionsPerConsumer:
            castToType<double>(data['avgPortionsPerConsumer']),
      );

  static DashboardPlantPortionDataTypeStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? DashboardPlantPortionDataTypeStruct.fromMap(
              data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'color': _color,
        'plantType': _plantType,
        'totalPortions': _totalPortions,
        'distinctPlantCount': _distinctPlantCount,
        'numConsumers': _numConsumers,
        'pctConsumers': _pctConsumers,
        'avgPortionsPerPerson': _avgPortionsPerPerson,
        'avgPortionsPerConsumer': _avgPortionsPerConsumer,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'color': serializeParam(
          _color,
          ParamType.String,
        ),
        'plantType': serializeParam(
          _plantType,
          ParamType.String,
        ),
        'totalPortions': serializeParam(
          _totalPortions,
          ParamType.double,
        ),
        'distinctPlantCount': serializeParam(
          _distinctPlantCount,
          ParamType.int,
        ),
        'numConsumers': serializeParam(
          _numConsumers,
          ParamType.int,
        ),
        'pctConsumers': serializeParam(
          _pctConsumers,
          ParamType.double,
        ),
        'avgPortionsPerPerson': serializeParam(
          _avgPortionsPerPerson,
          ParamType.double,
        ),
        'avgPortionsPerConsumer': serializeParam(
          _avgPortionsPerConsumer,
          ParamType.double,
        ),
      }.withoutNulls;

  static DashboardPlantPortionDataTypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DashboardPlantPortionDataTypeStruct(
        color: deserializeParam(
          data['color'],
          ParamType.String,
          false,
        ),
        plantType: deserializeParam(
          data['plantType'],
          ParamType.String,
          false,
        ),
        totalPortions: deserializeParam(
          data['totalPortions'],
          ParamType.double,
          false,
        ),
        distinctPlantCount: deserializeParam(
          data['distinctPlantCount'],
          ParamType.int,
          false,
        ),
        numConsumers: deserializeParam(
          data['numConsumers'],
          ParamType.int,
          false,
        ),
        pctConsumers: deserializeParam(
          data['pctConsumers'],
          ParamType.double,
          false,
        ),
        avgPortionsPerPerson: deserializeParam(
          data['avgPortionsPerPerson'],
          ParamType.double,
          false,
        ),
        avgPortionsPerConsumer: deserializeParam(
          data['avgPortionsPerConsumer'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DashboardPlantPortionDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DashboardPlantPortionDataTypeStruct &&
        color == other.color &&
        plantType == other.plantType &&
        totalPortions == other.totalPortions &&
        distinctPlantCount == other.distinctPlantCount &&
        numConsumers == other.numConsumers &&
        pctConsumers == other.pctConsumers &&
        avgPortionsPerPerson == other.avgPortionsPerPerson &&
        avgPortionsPerConsumer == other.avgPortionsPerConsumer;
  }

  @override
  int get hashCode => const ListEquality().hash([
        color,
        plantType,
        totalPortions,
        distinctPlantCount,
        numConsumers,
        pctConsumers,
        avgPortionsPerPerson,
        avgPortionsPerConsumer
      ]);
}

DashboardPlantPortionDataTypeStruct createDashboardPlantPortionDataTypeStruct({
  String? color,
  String? plantType,
  double? totalPortions,
  int? distinctPlantCount,
  int? numConsumers,
  double? pctConsumers,
  double? avgPortionsPerPerson,
  double? avgPortionsPerConsumer,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DashboardPlantPortionDataTypeStruct(
      color: color,
      plantType: plantType,
      totalPortions: totalPortions,
      distinctPlantCount: distinctPlantCount,
      numConsumers: numConsumers,
      pctConsumers: pctConsumers,
      avgPortionsPerPerson: avgPortionsPerPerson,
      avgPortionsPerConsumer: avgPortionsPerConsumer,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DashboardPlantPortionDataTypeStruct? updateDashboardPlantPortionDataTypeStruct(
  DashboardPlantPortionDataTypeStruct? dashboardPlantPortionDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dashboardPlantPortionDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDashboardPlantPortionDataTypeStructData(
  Map<String, dynamic> firestoreData,
  DashboardPlantPortionDataTypeStruct? dashboardPlantPortionDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dashboardPlantPortionDataType == null) {
    return;
  }
  if (dashboardPlantPortionDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      dashboardPlantPortionDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dashboardPlantPortionDataTypeData =
      getDashboardPlantPortionDataTypeFirestoreData(
          dashboardPlantPortionDataType, forFieldValue);
  final nestedData = dashboardPlantPortionDataTypeData
      .map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      dashboardPlantPortionDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDashboardPlantPortionDataTypeFirestoreData(
  DashboardPlantPortionDataTypeStruct? dashboardPlantPortionDataType, [
  bool forFieldValue = false,
]) {
  if (dashboardPlantPortionDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dashboardPlantPortionDataType.toMap());

  // Add any Firestore field values
  dashboardPlantPortionDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDashboardPlantPortionDataTypeListFirestoreData(
  List<DashboardPlantPortionDataTypeStruct>? dashboardPlantPortionDataTypes,
) =>
    dashboardPlantPortionDataTypes
        ?.map((e) => getDashboardPlantPortionDataTypeFirestoreData(e, true))
        .toList() ??
    [];
