// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DashboardComIndDataTypeStruct extends FFFirebaseStruct {
  DashboardComIndDataTypeStruct({
    double? averagePlantsValue,
    int? averagePlantsCount,
    double? averagePortionsValue,
    int? averagePortionsCount,
    double? consistencyScoreValue,
    int? consistencyScoreCount,
    double? fiberTrackerValue,
    int? fiberTrackerCount,
    double? proteinTrackerValue,
    int? proteinTrackerCount,
    double? healthScoreValue,
    int? healthScoreCount,
    DashboardTrendwatchDataTypeStruct? trendwatch,
    List<DashboardPlantPortionDataTypeStruct>? rareFinds,
    List<DashboardPlantPortionDataTypeStruct>? frequentFive,
    List<DashboardPlantPortionDataTypeStruct>? colorGaps,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _averagePlantsValue = averagePlantsValue,
        _averagePlantsCount = averagePlantsCount,
        _averagePortionsValue = averagePortionsValue,
        _averagePortionsCount = averagePortionsCount,
        _consistencyScoreValue = consistencyScoreValue,
        _consistencyScoreCount = consistencyScoreCount,
        _fiberTrackerValue = fiberTrackerValue,
        _fiberTrackerCount = fiberTrackerCount,
        _proteinTrackerValue = proteinTrackerValue,
        _proteinTrackerCount = proteinTrackerCount,
        _healthScoreValue = healthScoreValue,
        _healthScoreCount = healthScoreCount,
        _trendwatch = trendwatch,
        _rareFinds = rareFinds,
        _frequentFive = frequentFive,
        _colorGaps = colorGaps,
        super(firestoreUtilData);

  // "averagePlantsValue" field.
  double? _averagePlantsValue;
  double get averagePlantsValue => _averagePlantsValue ?? 0.0;
  set averagePlantsValue(double? val) => _averagePlantsValue = val;

  void incrementAveragePlantsValue(double amount) =>
      averagePlantsValue = averagePlantsValue + amount;

  bool hasAveragePlantsValue() => _averagePlantsValue != null;

  // "averagePlantsCount" field.
  int? _averagePlantsCount;
  int get averagePlantsCount => _averagePlantsCount ?? 0;
  set averagePlantsCount(int? val) => _averagePlantsCount = val;

  void incrementAveragePlantsCount(int amount) =>
      averagePlantsCount = averagePlantsCount + amount;

  bool hasAveragePlantsCount() => _averagePlantsCount != null;

  // "averagePortionsValue" field.
  double? _averagePortionsValue;
  double get averagePortionsValue => _averagePortionsValue ?? 0.0;
  set averagePortionsValue(double? val) => _averagePortionsValue = val;

  void incrementAveragePortionsValue(double amount) =>
      averagePortionsValue = averagePortionsValue + amount;

  bool hasAveragePortionsValue() => _averagePortionsValue != null;

  // "averagePortionsCount" field.
  int? _averagePortionsCount;
  int get averagePortionsCount => _averagePortionsCount ?? 0;
  set averagePortionsCount(int? val) => _averagePortionsCount = val;

  void incrementAveragePortionsCount(int amount) =>
      averagePortionsCount = averagePortionsCount + amount;

  bool hasAveragePortionsCount() => _averagePortionsCount != null;

  // "consistencyScoreValue" field.
  double? _consistencyScoreValue;
  double get consistencyScoreValue => _consistencyScoreValue ?? 0.0;
  set consistencyScoreValue(double? val) => _consistencyScoreValue = val;

  void incrementConsistencyScoreValue(double amount) =>
      consistencyScoreValue = consistencyScoreValue + amount;

  bool hasConsistencyScoreValue() => _consistencyScoreValue != null;

  // "consistencyScoreCount" field.
  int? _consistencyScoreCount;
  int get consistencyScoreCount => _consistencyScoreCount ?? 0;
  set consistencyScoreCount(int? val) => _consistencyScoreCount = val;

  void incrementConsistencyScoreCount(int amount) =>
      consistencyScoreCount = consistencyScoreCount + amount;

  bool hasConsistencyScoreCount() => _consistencyScoreCount != null;

  // "fiberTrackerValue" field.
  double? _fiberTrackerValue;
  double get fiberTrackerValue => _fiberTrackerValue ?? 0.0;
  set fiberTrackerValue(double? val) => _fiberTrackerValue = val;

  void incrementFiberTrackerValue(double amount) =>
      fiberTrackerValue = fiberTrackerValue + amount;

  bool hasFiberTrackerValue() => _fiberTrackerValue != null;

  // "fiberTrackerCount" field.
  int? _fiberTrackerCount;
  int get fiberTrackerCount => _fiberTrackerCount ?? 0;
  set fiberTrackerCount(int? val) => _fiberTrackerCount = val;

  void incrementFiberTrackerCount(int amount) =>
      fiberTrackerCount = fiberTrackerCount + amount;

  bool hasFiberTrackerCount() => _fiberTrackerCount != null;

  // "proteinTrackerValue" field.
  double? _proteinTrackerValue;
  double get proteinTrackerValue => _proteinTrackerValue ?? 0.0;
  set proteinTrackerValue(double? val) => _proteinTrackerValue = val;

  void incrementProteinTrackerValue(double amount) =>
      proteinTrackerValue = proteinTrackerValue + amount;

  bool hasProteinTrackerValue() => _proteinTrackerValue != null;

  // "proteinTrackerCount" field.
  int? _proteinTrackerCount;
  int get proteinTrackerCount => _proteinTrackerCount ?? 0;
  set proteinTrackerCount(int? val) => _proteinTrackerCount = val;

  void incrementProteinTrackerCount(int amount) =>
      proteinTrackerCount = proteinTrackerCount + amount;

  bool hasProteinTrackerCount() => _proteinTrackerCount != null;

  // "healthScoreValue" field.
  double? _healthScoreValue;
  double get healthScoreValue => _healthScoreValue ?? 0.0;
  set healthScoreValue(double? val) => _healthScoreValue = val;

  void incrementHealthScoreValue(double amount) =>
      healthScoreValue = healthScoreValue + amount;

  bool hasHealthScoreValue() => _healthScoreValue != null;

  // "healthScoreCount" field.
  int? _healthScoreCount;
  int get healthScoreCount => _healthScoreCount ?? 0;
  set healthScoreCount(int? val) => _healthScoreCount = val;

  void incrementHealthScoreCount(int amount) =>
      healthScoreCount = healthScoreCount + amount;

  bool hasHealthScoreCount() => _healthScoreCount != null;

  // "trendwatch" field.
  DashboardTrendwatchDataTypeStruct? _trendwatch;
  DashboardTrendwatchDataTypeStruct get trendwatch =>
      _trendwatch ?? DashboardTrendwatchDataTypeStruct();
  set trendwatch(DashboardTrendwatchDataTypeStruct? val) => _trendwatch = val;

  void updateTrendwatch(Function(DashboardTrendwatchDataTypeStruct) updateFn) {
    updateFn(_trendwatch ??= DashboardTrendwatchDataTypeStruct());
  }

  bool hasTrendwatch() => _trendwatch != null;

  // "rareFinds" field.
  List<DashboardPlantPortionDataTypeStruct>? _rareFinds;
  List<DashboardPlantPortionDataTypeStruct> get rareFinds =>
      _rareFinds ?? const [];
  set rareFinds(List<DashboardPlantPortionDataTypeStruct>? val) =>
      _rareFinds = val;

  void updateRareFinds(
      Function(List<DashboardPlantPortionDataTypeStruct>) updateFn) {
    updateFn(_rareFinds ??= []);
  }

  bool hasRareFinds() => _rareFinds != null;

  // "frequentFive" field.
  List<DashboardPlantPortionDataTypeStruct>? _frequentFive;
  List<DashboardPlantPortionDataTypeStruct> get frequentFive =>
      _frequentFive ?? const [];
  set frequentFive(List<DashboardPlantPortionDataTypeStruct>? val) =>
      _frequentFive = val;

  void updateFrequentFive(
      Function(List<DashboardPlantPortionDataTypeStruct>) updateFn) {
    updateFn(_frequentFive ??= []);
  }

  bool hasFrequentFive() => _frequentFive != null;

  // "colorGaps" field.
  List<DashboardPlantPortionDataTypeStruct>? _colorGaps;
  List<DashboardPlantPortionDataTypeStruct> get colorGaps =>
      _colorGaps ?? const [];
  set colorGaps(List<DashboardPlantPortionDataTypeStruct>? val) =>
      _colorGaps = val;

  void updateColorGaps(
      Function(List<DashboardPlantPortionDataTypeStruct>) updateFn) {
    updateFn(_colorGaps ??= []);
  }

  bool hasColorGaps() => _colorGaps != null;

  static DashboardComIndDataTypeStruct fromMap(Map<String, dynamic> data) =>
      DashboardComIndDataTypeStruct(
        averagePlantsValue: castToType<double>(data['averagePlantsValue']),
        averagePlantsCount: castToType<int>(data['averagePlantsCount']),
        averagePortionsValue: castToType<double>(data['averagePortionsValue']),
        averagePortionsCount: castToType<int>(data['averagePortionsCount']),
        consistencyScoreValue:
            castToType<double>(data['consistencyScoreValue']),
        consistencyScoreCount: castToType<int>(data['consistencyScoreCount']),
        fiberTrackerValue: castToType<double>(data['fiberTrackerValue']),
        fiberTrackerCount: castToType<int>(data['fiberTrackerCount']),
        proteinTrackerValue: castToType<double>(data['proteinTrackerValue']),
        proteinTrackerCount: castToType<int>(data['proteinTrackerCount']),
        healthScoreValue: castToType<double>(data['healthScoreValue']),
        healthScoreCount: castToType<int>(data['healthScoreCount']),
        trendwatch: data['trendwatch'] is DashboardTrendwatchDataTypeStruct
            ? data['trendwatch']
            : DashboardTrendwatchDataTypeStruct.maybeFromMap(
                data['trendwatch']),
        rareFinds: getStructList(
          data['rareFinds'],
          DashboardPlantPortionDataTypeStruct.fromMap,
        ),
        frequentFive: getStructList(
          data['frequentFive'],
          DashboardPlantPortionDataTypeStruct.fromMap,
        ),
        colorGaps: getStructList(
          data['colorGaps'],
          DashboardPlantPortionDataTypeStruct.fromMap,
        ),
      );

  static DashboardComIndDataTypeStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? DashboardComIndDataTypeStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'averagePlantsValue': _averagePlantsValue,
        'averagePlantsCount': _averagePlantsCount,
        'averagePortionsValue': _averagePortionsValue,
        'averagePortionsCount': _averagePortionsCount,
        'consistencyScoreValue': _consistencyScoreValue,
        'consistencyScoreCount': _consistencyScoreCount,
        'fiberTrackerValue': _fiberTrackerValue,
        'fiberTrackerCount': _fiberTrackerCount,
        'proteinTrackerValue': _proteinTrackerValue,
        'proteinTrackerCount': _proteinTrackerCount,
        'healthScoreValue': _healthScoreValue,
        'healthScoreCount': _healthScoreCount,
        'trendwatch': _trendwatch?.toMap(),
        'rareFinds': _rareFinds?.map((e) => e.toMap()).toList(),
        'frequentFive': _frequentFive?.map((e) => e.toMap()).toList(),
        'colorGaps': _colorGaps?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'averagePlantsValue': serializeParam(
          _averagePlantsValue,
          ParamType.double,
        ),
        'averagePlantsCount': serializeParam(
          _averagePlantsCount,
          ParamType.int,
        ),
        'averagePortionsValue': serializeParam(
          _averagePortionsValue,
          ParamType.double,
        ),
        'averagePortionsCount': serializeParam(
          _averagePortionsCount,
          ParamType.int,
        ),
        'consistencyScoreValue': serializeParam(
          _consistencyScoreValue,
          ParamType.double,
        ),
        'consistencyScoreCount': serializeParam(
          _consistencyScoreCount,
          ParamType.int,
        ),
        'fiberTrackerValue': serializeParam(
          _fiberTrackerValue,
          ParamType.double,
        ),
        'fiberTrackerCount': serializeParam(
          _fiberTrackerCount,
          ParamType.int,
        ),
        'proteinTrackerValue': serializeParam(
          _proteinTrackerValue,
          ParamType.double,
        ),
        'proteinTrackerCount': serializeParam(
          _proteinTrackerCount,
          ParamType.int,
        ),
        'healthScoreValue': serializeParam(
          _healthScoreValue,
          ParamType.double,
        ),
        'healthScoreCount': serializeParam(
          _healthScoreCount,
          ParamType.int,
        ),
        'trendwatch': serializeParam(
          _trendwatch,
          ParamType.DataStruct,
        ),
        'rareFinds': serializeParam(
          _rareFinds,
          ParamType.DataStruct,
          isList: true,
        ),
        'frequentFive': serializeParam(
          _frequentFive,
          ParamType.DataStruct,
          isList: true,
        ),
        'colorGaps': serializeParam(
          _colorGaps,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static DashboardComIndDataTypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DashboardComIndDataTypeStruct(
        averagePlantsValue: deserializeParam(
          data['averagePlantsValue'],
          ParamType.double,
          false,
        ),
        averagePlantsCount: deserializeParam(
          data['averagePlantsCount'],
          ParamType.int,
          false,
        ),
        averagePortionsValue: deserializeParam(
          data['averagePortionsValue'],
          ParamType.double,
          false,
        ),
        averagePortionsCount: deserializeParam(
          data['averagePortionsCount'],
          ParamType.int,
          false,
        ),
        consistencyScoreValue: deserializeParam(
          data['consistencyScoreValue'],
          ParamType.double,
          false,
        ),
        consistencyScoreCount: deserializeParam(
          data['consistencyScoreCount'],
          ParamType.int,
          false,
        ),
        fiberTrackerValue: deserializeParam(
          data['fiberTrackerValue'],
          ParamType.double,
          false,
        ),
        fiberTrackerCount: deserializeParam(
          data['fiberTrackerCount'],
          ParamType.int,
          false,
        ),
        proteinTrackerValue: deserializeParam(
          data['proteinTrackerValue'],
          ParamType.double,
          false,
        ),
        proteinTrackerCount: deserializeParam(
          data['proteinTrackerCount'],
          ParamType.int,
          false,
        ),
        healthScoreValue: deserializeParam(
          data['healthScoreValue'],
          ParamType.double,
          false,
        ),
        healthScoreCount: deserializeParam(
          data['healthScoreCount'],
          ParamType.int,
          false,
        ),
        trendwatch: deserializeStructParam(
          data['trendwatch'],
          ParamType.DataStruct,
          false,
          structBuilder: DashboardTrendwatchDataTypeStruct.fromSerializableMap,
        ),
        rareFinds: deserializeStructParam<DashboardPlantPortionDataTypeStruct>(
          data['rareFinds'],
          ParamType.DataStruct,
          true,
          structBuilder:
              DashboardPlantPortionDataTypeStruct.fromSerializableMap,
        ),
        frequentFive:
            deserializeStructParam<DashboardPlantPortionDataTypeStruct>(
          data['frequentFive'],
          ParamType.DataStruct,
          true,
          structBuilder:
              DashboardPlantPortionDataTypeStruct.fromSerializableMap,
        ),
        colorGaps: deserializeStructParam<DashboardPlantPortionDataTypeStruct>(
          data['colorGaps'],
          ParamType.DataStruct,
          true,
          structBuilder:
              DashboardPlantPortionDataTypeStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'DashboardComIndDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is DashboardComIndDataTypeStruct &&
        averagePlantsValue == other.averagePlantsValue &&
        averagePlantsCount == other.averagePlantsCount &&
        averagePortionsValue == other.averagePortionsValue &&
        averagePortionsCount == other.averagePortionsCount &&
        consistencyScoreValue == other.consistencyScoreValue &&
        consistencyScoreCount == other.consistencyScoreCount &&
        fiberTrackerValue == other.fiberTrackerValue &&
        fiberTrackerCount == other.fiberTrackerCount &&
        proteinTrackerValue == other.proteinTrackerValue &&
        proteinTrackerCount == other.proteinTrackerCount &&
        healthScoreValue == other.healthScoreValue &&
        healthScoreCount == other.healthScoreCount &&
        trendwatch == other.trendwatch &&
        listEquality.equals(rareFinds, other.rareFinds) &&
        listEquality.equals(frequentFive, other.frequentFive) &&
        listEquality.equals(colorGaps, other.colorGaps);
  }

  @override
  int get hashCode => const ListEquality().hash([
        averagePlantsValue,
        averagePlantsCount,
        averagePortionsValue,
        averagePortionsCount,
        consistencyScoreValue,
        consistencyScoreCount,
        fiberTrackerValue,
        fiberTrackerCount,
        proteinTrackerValue,
        proteinTrackerCount,
        healthScoreValue,
        healthScoreCount,
        trendwatch,
        rareFinds,
        frequentFive,
        colorGaps
      ]);
}

DashboardComIndDataTypeStruct createDashboardComIndDataTypeStruct({
  double? averagePlantsValue,
  int? averagePlantsCount,
  double? averagePortionsValue,
  int? averagePortionsCount,
  double? consistencyScoreValue,
  int? consistencyScoreCount,
  double? fiberTrackerValue,
  int? fiberTrackerCount,
  double? proteinTrackerValue,
  int? proteinTrackerCount,
  double? healthScoreValue,
  int? healthScoreCount,
  DashboardTrendwatchDataTypeStruct? trendwatch,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DashboardComIndDataTypeStruct(
      averagePlantsValue: averagePlantsValue,
      averagePlantsCount: averagePlantsCount,
      averagePortionsValue: averagePortionsValue,
      averagePortionsCount: averagePortionsCount,
      consistencyScoreValue: consistencyScoreValue,
      consistencyScoreCount: consistencyScoreCount,
      fiberTrackerValue: fiberTrackerValue,
      fiberTrackerCount: fiberTrackerCount,
      proteinTrackerValue: proteinTrackerValue,
      proteinTrackerCount: proteinTrackerCount,
      healthScoreValue: healthScoreValue,
      healthScoreCount: healthScoreCount,
      trendwatch: trendwatch ??
          (clearUnsetFields ? DashboardTrendwatchDataTypeStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DashboardComIndDataTypeStruct? updateDashboardComIndDataTypeStruct(
  DashboardComIndDataTypeStruct? dashboardComIndDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dashboardComIndDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDashboardComIndDataTypeStructData(
  Map<String, dynamic> firestoreData,
  DashboardComIndDataTypeStruct? dashboardComIndDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dashboardComIndDataType == null) {
    return;
  }
  if (dashboardComIndDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      dashboardComIndDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dashboardComIndDataTypeData = getDashboardComIndDataTypeFirestoreData(
      dashboardComIndDataType, forFieldValue);
  final nestedData =
      dashboardComIndDataTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      dashboardComIndDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDashboardComIndDataTypeFirestoreData(
  DashboardComIndDataTypeStruct? dashboardComIndDataType, [
  bool forFieldValue = false,
]) {
  if (dashboardComIndDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dashboardComIndDataType.toMap());

  // Handle nested data for "trendwatch" field.
  addDashboardTrendwatchDataTypeStructData(
    firestoreData,
    dashboardComIndDataType.hasTrendwatch()
        ? dashboardComIndDataType.trendwatch
        : null,
    'trendwatch',
    forFieldValue,
  );

  // Add any Firestore field values
  dashboardComIndDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDashboardComIndDataTypeListFirestoreData(
  List<DashboardComIndDataTypeStruct>? dashboardComIndDataTypes,
) =>
    dashboardComIndDataTypes
        ?.map((e) => getDashboardComIndDataTypeFirestoreData(e, true))
        .toList() ??
    [];
