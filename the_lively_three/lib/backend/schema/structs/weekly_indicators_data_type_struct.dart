// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Assigned to App State Variable "weeklyIndicators" and contains indicator
/// values for current and prior week to be shown within the Dashboard page
class WeeklyIndicatorsDataTypeStruct extends FFFirebaseStruct {
  WeeklyIndicatorsDataTypeStruct({
    int? cwColorGapsMissingCount,
    int? pwColorGapsMissingCount,
    List<String>? cwColorGapsMissingColors,
    List<String>? pwColorGapsMissingColors,
    double? cwHealthScoreValue,
    double? pwHealthScoreValue,
    double? cwFiberTrackerValue,
    double? pwFiberTrackerValue,
    double? cwProteinTrackerValue,
    double? pwProteinTrackerValue,
    double? cwAveragePlantsValue,
    double? pwAveragePlantsValue,
    double? cwAveragePortionsValue,
    double? pwAveragePortionsValue,
    double? cwConsistencyScoreValue,
    double? pwConsistencyScoreValue,
    double? cwProgressConsistencyValue,
    double? pwProgressConsistencyValue,
    double? cwProgressHealthScoreValue,
    double? pwProgressHealthScoreValue,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _cwColorGapsMissingCount = cwColorGapsMissingCount,
        _pwColorGapsMissingCount = pwColorGapsMissingCount,
        _cwColorGapsMissingColors = cwColorGapsMissingColors,
        _pwColorGapsMissingColors = pwColorGapsMissingColors,
        _cwHealthScoreValue = cwHealthScoreValue,
        _pwHealthScoreValue = pwHealthScoreValue,
        _cwFiberTrackerValue = cwFiberTrackerValue,
        _pwFiberTrackerValue = pwFiberTrackerValue,
        _cwProteinTrackerValue = cwProteinTrackerValue,
        _pwProteinTrackerValue = pwProteinTrackerValue,
        _cwAveragePlantsValue = cwAveragePlantsValue,
        _pwAveragePlantsValue = pwAveragePlantsValue,
        _cwAveragePortionsValue = cwAveragePortionsValue,
        _pwAveragePortionsValue = pwAveragePortionsValue,
        _cwConsistencyScoreValue = cwConsistencyScoreValue,
        _pwConsistencyScoreValue = pwConsistencyScoreValue,
        _cwProgressConsistencyValue = cwProgressConsistencyValue,
        _pwProgressConsistencyValue = pwProgressConsistencyValue,
        _cwProgressHealthScoreValue = cwProgressHealthScoreValue,
        _pwProgressHealthScoreValue = pwProgressHealthScoreValue,
        super(firestoreUtilData);

  // "cwColorGapsMissingCount" field.
  int? _cwColorGapsMissingCount;
  int get cwColorGapsMissingCount => _cwColorGapsMissingCount ?? 0;
  set cwColorGapsMissingCount(int? val) => _cwColorGapsMissingCount = val;

  void incrementCwColorGapsMissingCount(int amount) =>
      cwColorGapsMissingCount = cwColorGapsMissingCount + amount;

  bool hasCwColorGapsMissingCount() => _cwColorGapsMissingCount != null;

  // "pwColorGapsMissingCount" field.
  int? _pwColorGapsMissingCount;
  int get pwColorGapsMissingCount => _pwColorGapsMissingCount ?? 0;
  set pwColorGapsMissingCount(int? val) => _pwColorGapsMissingCount = val;

  void incrementPwColorGapsMissingCount(int amount) =>
      pwColorGapsMissingCount = pwColorGapsMissingCount + amount;

  bool hasPwColorGapsMissingCount() => _pwColorGapsMissingCount != null;

  // "cwColorGapsMissingColors" field.
  List<String>? _cwColorGapsMissingColors;
  List<String> get cwColorGapsMissingColors =>
      _cwColorGapsMissingColors ?? const [];
  set cwColorGapsMissingColors(List<String>? val) =>
      _cwColorGapsMissingColors = val;

  void updateCwColorGapsMissingColors(Function(List<String>) updateFn) {
    updateFn(_cwColorGapsMissingColors ??= []);
  }

  bool hasCwColorGapsMissingColors() => _cwColorGapsMissingColors != null;

  // "pwColorGapsMissingColors" field.
  List<String>? _pwColorGapsMissingColors;
  List<String> get pwColorGapsMissingColors =>
      _pwColorGapsMissingColors ?? const [];
  set pwColorGapsMissingColors(List<String>? val) =>
      _pwColorGapsMissingColors = val;

  void updatePwColorGapsMissingColors(Function(List<String>) updateFn) {
    updateFn(_pwColorGapsMissingColors ??= []);
  }

  bool hasPwColorGapsMissingColors() => _pwColorGapsMissingColors != null;

  // "cwHealthScoreValue" field.
  double? _cwHealthScoreValue;
  double get cwHealthScoreValue => _cwHealthScoreValue ?? 0.0;
  set cwHealthScoreValue(double? val) => _cwHealthScoreValue = val;

  void incrementCwHealthScoreValue(double amount) =>
      cwHealthScoreValue = cwHealthScoreValue + amount;

  bool hasCwHealthScoreValue() => _cwHealthScoreValue != null;

  // "pwHealthScoreValue" field.
  double? _pwHealthScoreValue;
  double get pwHealthScoreValue => _pwHealthScoreValue ?? 0.0;
  set pwHealthScoreValue(double? val) => _pwHealthScoreValue = val;

  void incrementPwHealthScoreValue(double amount) =>
      pwHealthScoreValue = pwHealthScoreValue + amount;

  bool hasPwHealthScoreValue() => _pwHealthScoreValue != null;

  // "cwFiberTrackerValue" field.
  double? _cwFiberTrackerValue;
  double get cwFiberTrackerValue => _cwFiberTrackerValue ?? 0.0;
  set cwFiberTrackerValue(double? val) => _cwFiberTrackerValue = val;

  void incrementCwFiberTrackerValue(double amount) =>
      cwFiberTrackerValue = cwFiberTrackerValue + amount;

  bool hasCwFiberTrackerValue() => _cwFiberTrackerValue != null;

  // "pwFiberTrackerValue" field.
  double? _pwFiberTrackerValue;
  double get pwFiberTrackerValue => _pwFiberTrackerValue ?? 0.0;
  set pwFiberTrackerValue(double? val) => _pwFiberTrackerValue = val;

  void incrementPwFiberTrackerValue(double amount) =>
      pwFiberTrackerValue = pwFiberTrackerValue + amount;

  bool hasPwFiberTrackerValue() => _pwFiberTrackerValue != null;

  // "cwProteinTrackerValue" field.
  double? _cwProteinTrackerValue;
  double get cwProteinTrackerValue => _cwProteinTrackerValue ?? 0.0;
  set cwProteinTrackerValue(double? val) => _cwProteinTrackerValue = val;

  void incrementCwProteinTrackerValue(double amount) =>
      cwProteinTrackerValue = cwProteinTrackerValue + amount;

  bool hasCwProteinTrackerValue() => _cwProteinTrackerValue != null;

  // "pwProteinTrackerValue" field.
  double? _pwProteinTrackerValue;
  double get pwProteinTrackerValue => _pwProteinTrackerValue ?? 0.0;
  set pwProteinTrackerValue(double? val) => _pwProteinTrackerValue = val;

  void incrementPwProteinTrackerValue(double amount) =>
      pwProteinTrackerValue = pwProteinTrackerValue + amount;

  bool hasPwProteinTrackerValue() => _pwProteinTrackerValue != null;

  // "cwAveragePlantsValue" field.
  double? _cwAveragePlantsValue;
  double get cwAveragePlantsValue => _cwAveragePlantsValue ?? 0.0;
  set cwAveragePlantsValue(double? val) => _cwAveragePlantsValue = val;

  void incrementCwAveragePlantsValue(double amount) =>
      cwAveragePlantsValue = cwAveragePlantsValue + amount;

  bool hasCwAveragePlantsValue() => _cwAveragePlantsValue != null;

  // "pwAveragePlantsValue" field.
  double? _pwAveragePlantsValue;
  double get pwAveragePlantsValue => _pwAveragePlantsValue ?? 0.0;
  set pwAveragePlantsValue(double? val) => _pwAveragePlantsValue = val;

  void incrementPwAveragePlantsValue(double amount) =>
      pwAveragePlantsValue = pwAveragePlantsValue + amount;

  bool hasPwAveragePlantsValue() => _pwAveragePlantsValue != null;

  // "cwAveragePortionsValue" field.
  double? _cwAveragePortionsValue;
  double get cwAveragePortionsValue => _cwAveragePortionsValue ?? 0.0;
  set cwAveragePortionsValue(double? val) => _cwAveragePortionsValue = val;

  void incrementCwAveragePortionsValue(double amount) =>
      cwAveragePortionsValue = cwAveragePortionsValue + amount;

  bool hasCwAveragePortionsValue() => _cwAveragePortionsValue != null;

  // "pwAveragePortionsValue" field.
  double? _pwAveragePortionsValue;
  double get pwAveragePortionsValue => _pwAveragePortionsValue ?? 0.0;
  set pwAveragePortionsValue(double? val) => _pwAveragePortionsValue = val;

  void incrementPwAveragePortionsValue(double amount) =>
      pwAveragePortionsValue = pwAveragePortionsValue + amount;

  bool hasPwAveragePortionsValue() => _pwAveragePortionsValue != null;

  // "cwConsistencyScoreValue" field.
  double? _cwConsistencyScoreValue;
  double get cwConsistencyScoreValue => _cwConsistencyScoreValue ?? 0.0;
  set cwConsistencyScoreValue(double? val) => _cwConsistencyScoreValue = val;

  void incrementCwConsistencyScoreValue(double amount) =>
      cwConsistencyScoreValue = cwConsistencyScoreValue + amount;

  bool hasCwConsistencyScoreValue() => _cwConsistencyScoreValue != null;

  // "pwConsistencyScoreValue" field.
  double? _pwConsistencyScoreValue;
  double get pwConsistencyScoreValue => _pwConsistencyScoreValue ?? 0.0;
  set pwConsistencyScoreValue(double? val) => _pwConsistencyScoreValue = val;

  void incrementPwConsistencyScoreValue(double amount) =>
      pwConsistencyScoreValue = pwConsistencyScoreValue + amount;

  bool hasPwConsistencyScoreValue() => _pwConsistencyScoreValue != null;

  // "cwProgressConsistencyValue" field.
  double? _cwProgressConsistencyValue;
  double get cwProgressConsistencyValue => _cwProgressConsistencyValue ?? 0.0;
  set cwProgressConsistencyValue(double? val) =>
      _cwProgressConsistencyValue = val;

  void incrementCwProgressConsistencyValue(double amount) =>
      cwProgressConsistencyValue = cwProgressConsistencyValue + amount;

  bool hasCwProgressConsistencyValue() => _cwProgressConsistencyValue != null;

  // "pwProgressConsistencyValue" field.
  double? _pwProgressConsistencyValue;
  double get pwProgressConsistencyValue => _pwProgressConsistencyValue ?? 0.0;
  set pwProgressConsistencyValue(double? val) =>
      _pwProgressConsistencyValue = val;

  void incrementPwProgressConsistencyValue(double amount) =>
      pwProgressConsistencyValue = pwProgressConsistencyValue + amount;

  bool hasPwProgressConsistencyValue() => _pwProgressConsistencyValue != null;

  // "cwProgressHealthScoreValue" field.
  double? _cwProgressHealthScoreValue;
  double get cwProgressHealthScoreValue => _cwProgressHealthScoreValue ?? 0.0;
  set cwProgressHealthScoreValue(double? val) =>
      _cwProgressHealthScoreValue = val;

  void incrementCwProgressHealthScoreValue(double amount) =>
      cwProgressHealthScoreValue = cwProgressHealthScoreValue + amount;

  bool hasCwProgressHealthScoreValue() => _cwProgressHealthScoreValue != null;

  // "pwProgressHealthScoreValue" field.
  double? _pwProgressHealthScoreValue;
  double get pwProgressHealthScoreValue => _pwProgressHealthScoreValue ?? 0.0;
  set pwProgressHealthScoreValue(double? val) =>
      _pwProgressHealthScoreValue = val;

  void incrementPwProgressHealthScoreValue(double amount) =>
      pwProgressHealthScoreValue = pwProgressHealthScoreValue + amount;

  bool hasPwProgressHealthScoreValue() => _pwProgressHealthScoreValue != null;

  static WeeklyIndicatorsDataTypeStruct fromMap(Map<String, dynamic> data) =>
      WeeklyIndicatorsDataTypeStruct(
        cwColorGapsMissingCount:
            castToType<int>(data['cwColorGapsMissingCount']),
        pwColorGapsMissingCount:
            castToType<int>(data['pwColorGapsMissingCount']),
        cwColorGapsMissingColors: getDataList(data['cwColorGapsMissingColors']),
        pwColorGapsMissingColors: getDataList(data['pwColorGapsMissingColors']),
        cwHealthScoreValue: castToType<double>(data['cwHealthScoreValue']),
        pwHealthScoreValue: castToType<double>(data['pwHealthScoreValue']),
        cwFiberTrackerValue: castToType<double>(data['cwFiberTrackerValue']),
        pwFiberTrackerValue: castToType<double>(data['pwFiberTrackerValue']),
        cwProteinTrackerValue:
            castToType<double>(data['cwProteinTrackerValue']),
        pwProteinTrackerValue:
            castToType<double>(data['pwProteinTrackerValue']),
        cwAveragePlantsValue: castToType<double>(data['cwAveragePlantsValue']),
        pwAveragePlantsValue: castToType<double>(data['pwAveragePlantsValue']),
        cwAveragePortionsValue:
            castToType<double>(data['cwAveragePortionsValue']),
        pwAveragePortionsValue:
            castToType<double>(data['pwAveragePortionsValue']),
        cwConsistencyScoreValue:
            castToType<double>(data['cwConsistencyScoreValue']),
        pwConsistencyScoreValue:
            castToType<double>(data['pwConsistencyScoreValue']),
        cwProgressConsistencyValue:
            castToType<double>(data['cwProgressConsistencyValue']),
        pwProgressConsistencyValue:
            castToType<double>(data['pwProgressConsistencyValue']),
        cwProgressHealthScoreValue:
            castToType<double>(data['cwProgressHealthScoreValue']),
        pwProgressHealthScoreValue:
            castToType<double>(data['pwProgressHealthScoreValue']),
      );

  static WeeklyIndicatorsDataTypeStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? WeeklyIndicatorsDataTypeStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'cwColorGapsMissingCount': _cwColorGapsMissingCount,
        'pwColorGapsMissingCount': _pwColorGapsMissingCount,
        'cwColorGapsMissingColors': _cwColorGapsMissingColors,
        'pwColorGapsMissingColors': _pwColorGapsMissingColors,
        'cwHealthScoreValue': _cwHealthScoreValue,
        'pwHealthScoreValue': _pwHealthScoreValue,
        'cwFiberTrackerValue': _cwFiberTrackerValue,
        'pwFiberTrackerValue': _pwFiberTrackerValue,
        'cwProteinTrackerValue': _cwProteinTrackerValue,
        'pwProteinTrackerValue': _pwProteinTrackerValue,
        'cwAveragePlantsValue': _cwAveragePlantsValue,
        'pwAveragePlantsValue': _pwAveragePlantsValue,
        'cwAveragePortionsValue': _cwAveragePortionsValue,
        'pwAveragePortionsValue': _pwAveragePortionsValue,
        'cwConsistencyScoreValue': _cwConsistencyScoreValue,
        'pwConsistencyScoreValue': _pwConsistencyScoreValue,
        'cwProgressConsistencyValue': _cwProgressConsistencyValue,
        'pwProgressConsistencyValue': _pwProgressConsistencyValue,
        'cwProgressHealthScoreValue': _cwProgressHealthScoreValue,
        'pwProgressHealthScoreValue': _pwProgressHealthScoreValue,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'cwColorGapsMissingCount': serializeParam(
          _cwColorGapsMissingCount,
          ParamType.int,
        ),
        'pwColorGapsMissingCount': serializeParam(
          _pwColorGapsMissingCount,
          ParamType.int,
        ),
        'cwColorGapsMissingColors': serializeParam(
          _cwColorGapsMissingColors,
          ParamType.String,
          isList: true,
        ),
        'pwColorGapsMissingColors': serializeParam(
          _pwColorGapsMissingColors,
          ParamType.String,
          isList: true,
        ),
        'cwHealthScoreValue': serializeParam(
          _cwHealthScoreValue,
          ParamType.double,
        ),
        'pwHealthScoreValue': serializeParam(
          _pwHealthScoreValue,
          ParamType.double,
        ),
        'cwFiberTrackerValue': serializeParam(
          _cwFiberTrackerValue,
          ParamType.double,
        ),
        'pwFiberTrackerValue': serializeParam(
          _pwFiberTrackerValue,
          ParamType.double,
        ),
        'cwProteinTrackerValue': serializeParam(
          _cwProteinTrackerValue,
          ParamType.double,
        ),
        'pwProteinTrackerValue': serializeParam(
          _pwProteinTrackerValue,
          ParamType.double,
        ),
        'cwAveragePlantsValue': serializeParam(
          _cwAveragePlantsValue,
          ParamType.double,
        ),
        'pwAveragePlantsValue': serializeParam(
          _pwAveragePlantsValue,
          ParamType.double,
        ),
        'cwAveragePortionsValue': serializeParam(
          _cwAveragePortionsValue,
          ParamType.double,
        ),
        'pwAveragePortionsValue': serializeParam(
          _pwAveragePortionsValue,
          ParamType.double,
        ),
        'cwConsistencyScoreValue': serializeParam(
          _cwConsistencyScoreValue,
          ParamType.double,
        ),
        'pwConsistencyScoreValue': serializeParam(
          _pwConsistencyScoreValue,
          ParamType.double,
        ),
        'cwProgressConsistencyValue': serializeParam(
          _cwProgressConsistencyValue,
          ParamType.double,
        ),
        'pwProgressConsistencyValue': serializeParam(
          _pwProgressConsistencyValue,
          ParamType.double,
        ),
        'cwProgressHealthScoreValue': serializeParam(
          _cwProgressHealthScoreValue,
          ParamType.double,
        ),
        'pwProgressHealthScoreValue': serializeParam(
          _pwProgressHealthScoreValue,
          ParamType.double,
        ),
      }.withoutNulls;

  static WeeklyIndicatorsDataTypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      WeeklyIndicatorsDataTypeStruct(
        cwColorGapsMissingCount: deserializeParam(
          data['cwColorGapsMissingCount'],
          ParamType.int,
          false,
        ),
        pwColorGapsMissingCount: deserializeParam(
          data['pwColorGapsMissingCount'],
          ParamType.int,
          false,
        ),
        cwColorGapsMissingColors: deserializeParam<String>(
          data['cwColorGapsMissingColors'],
          ParamType.String,
          true,
        ),
        pwColorGapsMissingColors: deserializeParam<String>(
          data['pwColorGapsMissingColors'],
          ParamType.String,
          true,
        ),
        cwHealthScoreValue: deserializeParam(
          data['cwHealthScoreValue'],
          ParamType.double,
          false,
        ),
        pwHealthScoreValue: deserializeParam(
          data['pwHealthScoreValue'],
          ParamType.double,
          false,
        ),
        cwFiberTrackerValue: deserializeParam(
          data['cwFiberTrackerValue'],
          ParamType.double,
          false,
        ),
        pwFiberTrackerValue: deserializeParam(
          data['pwFiberTrackerValue'],
          ParamType.double,
          false,
        ),
        cwProteinTrackerValue: deserializeParam(
          data['cwProteinTrackerValue'],
          ParamType.double,
          false,
        ),
        pwProteinTrackerValue: deserializeParam(
          data['pwProteinTrackerValue'],
          ParamType.double,
          false,
        ),
        cwAveragePlantsValue: deserializeParam(
          data['cwAveragePlantsValue'],
          ParamType.double,
          false,
        ),
        pwAveragePlantsValue: deserializeParam(
          data['pwAveragePlantsValue'],
          ParamType.double,
          false,
        ),
        cwAveragePortionsValue: deserializeParam(
          data['cwAveragePortionsValue'],
          ParamType.double,
          false,
        ),
        pwAveragePortionsValue: deserializeParam(
          data['pwAveragePortionsValue'],
          ParamType.double,
          false,
        ),
        cwConsistencyScoreValue: deserializeParam(
          data['cwConsistencyScoreValue'],
          ParamType.double,
          false,
        ),
        pwConsistencyScoreValue: deserializeParam(
          data['pwConsistencyScoreValue'],
          ParamType.double,
          false,
        ),
        cwProgressConsistencyValue: deserializeParam(
          data['cwProgressConsistencyValue'],
          ParamType.double,
          false,
        ),
        pwProgressConsistencyValue: deserializeParam(
          data['pwProgressConsistencyValue'],
          ParamType.double,
          false,
        ),
        cwProgressHealthScoreValue: deserializeParam(
          data['cwProgressHealthScoreValue'],
          ParamType.double,
          false,
        ),
        pwProgressHealthScoreValue: deserializeParam(
          data['pwProgressHealthScoreValue'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'WeeklyIndicatorsDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is WeeklyIndicatorsDataTypeStruct &&
        cwColorGapsMissingCount == other.cwColorGapsMissingCount &&
        pwColorGapsMissingCount == other.pwColorGapsMissingCount &&
        listEquality.equals(
            cwColorGapsMissingColors, other.cwColorGapsMissingColors) &&
        listEquality.equals(
            pwColorGapsMissingColors, other.pwColorGapsMissingColors) &&
        cwHealthScoreValue == other.cwHealthScoreValue &&
        pwHealthScoreValue == other.pwHealthScoreValue &&
        cwFiberTrackerValue == other.cwFiberTrackerValue &&
        pwFiberTrackerValue == other.pwFiberTrackerValue &&
        cwProteinTrackerValue == other.cwProteinTrackerValue &&
        pwProteinTrackerValue == other.pwProteinTrackerValue &&
        cwAveragePlantsValue == other.cwAveragePlantsValue &&
        pwAveragePlantsValue == other.pwAveragePlantsValue &&
        cwAveragePortionsValue == other.cwAveragePortionsValue &&
        pwAveragePortionsValue == other.pwAveragePortionsValue &&
        cwConsistencyScoreValue == other.cwConsistencyScoreValue &&
        pwConsistencyScoreValue == other.pwConsistencyScoreValue &&
        cwProgressConsistencyValue == other.cwProgressConsistencyValue &&
        pwProgressConsistencyValue == other.pwProgressConsistencyValue &&
        cwProgressHealthScoreValue == other.cwProgressHealthScoreValue &&
        pwProgressHealthScoreValue == other.pwProgressHealthScoreValue;
  }

  @override
  int get hashCode => const ListEquality().hash([
        cwColorGapsMissingCount,
        pwColorGapsMissingCount,
        cwColorGapsMissingColors,
        pwColorGapsMissingColors,
        cwHealthScoreValue,
        pwHealthScoreValue,
        cwFiberTrackerValue,
        pwFiberTrackerValue,
        cwProteinTrackerValue,
        pwProteinTrackerValue,
        cwAveragePlantsValue,
        pwAveragePlantsValue,
        cwAveragePortionsValue,
        pwAveragePortionsValue,
        cwConsistencyScoreValue,
        pwConsistencyScoreValue,
        cwProgressConsistencyValue,
        pwProgressConsistencyValue,
        cwProgressHealthScoreValue,
        pwProgressHealthScoreValue
      ]);
}

WeeklyIndicatorsDataTypeStruct createWeeklyIndicatorsDataTypeStruct({
  int? cwColorGapsMissingCount,
  int? pwColorGapsMissingCount,
  double? cwHealthScoreValue,
  double? pwHealthScoreValue,
  double? cwFiberTrackerValue,
  double? pwFiberTrackerValue,
  double? cwProteinTrackerValue,
  double? pwProteinTrackerValue,
  double? cwAveragePlantsValue,
  double? pwAveragePlantsValue,
  double? cwAveragePortionsValue,
  double? pwAveragePortionsValue,
  double? cwConsistencyScoreValue,
  double? pwConsistencyScoreValue,
  double? cwProgressConsistencyValue,
  double? pwProgressConsistencyValue,
  double? cwProgressHealthScoreValue,
  double? pwProgressHealthScoreValue,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    WeeklyIndicatorsDataTypeStruct(
      cwColorGapsMissingCount: cwColorGapsMissingCount,
      pwColorGapsMissingCount: pwColorGapsMissingCount,
      cwHealthScoreValue: cwHealthScoreValue,
      pwHealthScoreValue: pwHealthScoreValue,
      cwFiberTrackerValue: cwFiberTrackerValue,
      pwFiberTrackerValue: pwFiberTrackerValue,
      cwProteinTrackerValue: cwProteinTrackerValue,
      pwProteinTrackerValue: pwProteinTrackerValue,
      cwAveragePlantsValue: cwAveragePlantsValue,
      pwAveragePlantsValue: pwAveragePlantsValue,
      cwAveragePortionsValue: cwAveragePortionsValue,
      pwAveragePortionsValue: pwAveragePortionsValue,
      cwConsistencyScoreValue: cwConsistencyScoreValue,
      pwConsistencyScoreValue: pwConsistencyScoreValue,
      cwProgressConsistencyValue: cwProgressConsistencyValue,
      pwProgressConsistencyValue: pwProgressConsistencyValue,
      cwProgressHealthScoreValue: cwProgressHealthScoreValue,
      pwProgressHealthScoreValue: pwProgressHealthScoreValue,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

WeeklyIndicatorsDataTypeStruct? updateWeeklyIndicatorsDataTypeStruct(
  WeeklyIndicatorsDataTypeStruct? weeklyIndicatorsDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    weeklyIndicatorsDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addWeeklyIndicatorsDataTypeStructData(
  Map<String, dynamic> firestoreData,
  WeeklyIndicatorsDataTypeStruct? weeklyIndicatorsDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (weeklyIndicatorsDataType == null) {
    return;
  }
  if (weeklyIndicatorsDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      weeklyIndicatorsDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final weeklyIndicatorsDataTypeData = getWeeklyIndicatorsDataTypeFirestoreData(
      weeklyIndicatorsDataType, forFieldValue);
  final nestedData =
      weeklyIndicatorsDataTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      weeklyIndicatorsDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getWeeklyIndicatorsDataTypeFirestoreData(
  WeeklyIndicatorsDataTypeStruct? weeklyIndicatorsDataType, [
  bool forFieldValue = false,
]) {
  if (weeklyIndicatorsDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(weeklyIndicatorsDataType.toMap());

  // Add any Firestore field values
  weeklyIndicatorsDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getWeeklyIndicatorsDataTypeListFirestoreData(
  List<WeeklyIndicatorsDataTypeStruct>? weeklyIndicatorsDataTypes,
) =>
    weeklyIndicatorsDataTypes
        ?.map((e) => getWeeklyIndicatorsDataTypeFirestoreData(e, true))
        .toList() ??
    [];
