// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DashboardTrendwatchDataTypeStruct extends FFFirebaseStruct {
  DashboardTrendwatchDataTypeStruct({
    double? trendRatio,
    double? currentHealthScore,
    double? previousHealthScore,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _trendRatio = trendRatio,
        _currentHealthScore = currentHealthScore,
        _previousHealthScore = previousHealthScore,
        super(firestoreUtilData);

  // "trendRatio" field.
  double? _trendRatio;
  double get trendRatio => _trendRatio ?? 0.0;
  set trendRatio(double? val) => _trendRatio = val;

  void incrementTrendRatio(double amount) => trendRatio = trendRatio + amount;

  bool hasTrendRatio() => _trendRatio != null;

  // "currentHealthScore" field.
  double? _currentHealthScore;
  double get currentHealthScore => _currentHealthScore ?? 0.0;
  set currentHealthScore(double? val) => _currentHealthScore = val;

  void incrementCurrentHealthScore(double amount) =>
      currentHealthScore = currentHealthScore + amount;

  bool hasCurrentHealthScore() => _currentHealthScore != null;

  // "previousHealthScore" field.
  double? _previousHealthScore;
  double get previousHealthScore => _previousHealthScore ?? 0.0;
  set previousHealthScore(double? val) => _previousHealthScore = val;

  void incrementPreviousHealthScore(double amount) =>
      previousHealthScore = previousHealthScore + amount;

  bool hasPreviousHealthScore() => _previousHealthScore != null;

  static DashboardTrendwatchDataTypeStruct fromMap(Map<String, dynamic> data) =>
      DashboardTrendwatchDataTypeStruct(
        trendRatio: castToType<double>(data['trendRatio']),
        currentHealthScore: castToType<double>(data['currentHealthScore']),
        previousHealthScore: castToType<double>(data['previousHealthScore']),
      );

  static DashboardTrendwatchDataTypeStruct? maybeFromMap(dynamic data) => data
          is Map
      ? DashboardTrendwatchDataTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'trendRatio': _trendRatio,
        'currentHealthScore': _currentHealthScore,
        'previousHealthScore': _previousHealthScore,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'trendRatio': serializeParam(
          _trendRatio,
          ParamType.double,
        ),
        'currentHealthScore': serializeParam(
          _currentHealthScore,
          ParamType.double,
        ),
        'previousHealthScore': serializeParam(
          _previousHealthScore,
          ParamType.double,
        ),
      }.withoutNulls;

  static DashboardTrendwatchDataTypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DashboardTrendwatchDataTypeStruct(
        trendRatio: deserializeParam(
          data['trendRatio'],
          ParamType.double,
          false,
        ),
        currentHealthScore: deserializeParam(
          data['currentHealthScore'],
          ParamType.double,
          false,
        ),
        previousHealthScore: deserializeParam(
          data['previousHealthScore'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DashboardTrendwatchDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DashboardTrendwatchDataTypeStruct &&
        trendRatio == other.trendRatio &&
        currentHealthScore == other.currentHealthScore &&
        previousHealthScore == other.previousHealthScore;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([trendRatio, currentHealthScore, previousHealthScore]);
}

DashboardTrendwatchDataTypeStruct createDashboardTrendwatchDataTypeStruct({
  double? trendRatio,
  double? currentHealthScore,
  double? previousHealthScore,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DashboardTrendwatchDataTypeStruct(
      trendRatio: trendRatio,
      currentHealthScore: currentHealthScore,
      previousHealthScore: previousHealthScore,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DashboardTrendwatchDataTypeStruct? updateDashboardTrendwatchDataTypeStruct(
  DashboardTrendwatchDataTypeStruct? dashboardTrendwatchDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dashboardTrendwatchDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDashboardTrendwatchDataTypeStructData(
  Map<String, dynamic> firestoreData,
  DashboardTrendwatchDataTypeStruct? dashboardTrendwatchDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dashboardTrendwatchDataType == null) {
    return;
  }
  if (dashboardTrendwatchDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      dashboardTrendwatchDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dashboardTrendwatchDataTypeData =
      getDashboardTrendwatchDataTypeFirestoreData(
          dashboardTrendwatchDataType, forFieldValue);
  final nestedData = dashboardTrendwatchDataTypeData
      .map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      dashboardTrendwatchDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDashboardTrendwatchDataTypeFirestoreData(
  DashboardTrendwatchDataTypeStruct? dashboardTrendwatchDataType, [
  bool forFieldValue = false,
]) {
  if (dashboardTrendwatchDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dashboardTrendwatchDataType.toMap());

  // Add any Firestore field values
  dashboardTrendwatchDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDashboardTrendwatchDataTypeListFirestoreData(
  List<DashboardTrendwatchDataTypeStruct>? dashboardTrendwatchDataTypes,
) =>
    dashboardTrendwatchDataTypes
        ?.map((e) => getDashboardTrendwatchDataTypeFirestoreData(e, true))
        .toList() ??
    [];
