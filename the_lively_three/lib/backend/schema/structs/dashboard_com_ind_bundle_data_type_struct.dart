// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DashboardComIndBundleDataTypeStruct extends FFFirebaseStruct {
  DashboardComIndBundleDataTypeStruct({
    DashboardComIndDataTypeStruct? currentWeek,
    DashboardComIndDataTypeStruct? previousWeek,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _currentWeek = currentWeek,
        _previousWeek = previousWeek,
        super(firestoreUtilData);

  // "currentWeek" field.
  DashboardComIndDataTypeStruct? _currentWeek;
  DashboardComIndDataTypeStruct get currentWeek =>
      _currentWeek ?? DashboardComIndDataTypeStruct();
  set currentWeek(DashboardComIndDataTypeStruct? val) => _currentWeek = val;

  void updateCurrentWeek(Function(DashboardComIndDataTypeStruct) updateFn) {
    updateFn(_currentWeek ??= DashboardComIndDataTypeStruct());
  }

  bool hasCurrentWeek() => _currentWeek != null;

  // "previousWeek" field.
  DashboardComIndDataTypeStruct? _previousWeek;
  DashboardComIndDataTypeStruct get previousWeek =>
      _previousWeek ?? DashboardComIndDataTypeStruct();
  set previousWeek(DashboardComIndDataTypeStruct? val) => _previousWeek = val;

  void updatePreviousWeek(Function(DashboardComIndDataTypeStruct) updateFn) {
    updateFn(_previousWeek ??= DashboardComIndDataTypeStruct());
  }

  bool hasPreviousWeek() => _previousWeek != null;

  static DashboardComIndBundleDataTypeStruct fromMap(
          Map<String, dynamic> data) =>
      DashboardComIndBundleDataTypeStruct(
        currentWeek: data['currentWeek'] is DashboardComIndDataTypeStruct
            ? data['currentWeek']
            : DashboardComIndDataTypeStruct.maybeFromMap(data['currentWeek']),
        previousWeek: data['previousWeek'] is DashboardComIndDataTypeStruct
            ? data['previousWeek']
            : DashboardComIndDataTypeStruct.maybeFromMap(data['previousWeek']),
      );

  static DashboardComIndBundleDataTypeStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? DashboardComIndBundleDataTypeStruct.fromMap(
              data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'currentWeek': _currentWeek?.toMap(),
        'previousWeek': _previousWeek?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'currentWeek': serializeParam(
          _currentWeek,
          ParamType.DataStruct,
        ),
        'previousWeek': serializeParam(
          _previousWeek,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static DashboardComIndBundleDataTypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DashboardComIndBundleDataTypeStruct(
        currentWeek: deserializeStructParam(
          data['currentWeek'],
          ParamType.DataStruct,
          false,
          structBuilder: DashboardComIndDataTypeStruct.fromSerializableMap,
        ),
        previousWeek: deserializeStructParam(
          data['previousWeek'],
          ParamType.DataStruct,
          false,
          structBuilder: DashboardComIndDataTypeStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'DashboardComIndBundleDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DashboardComIndBundleDataTypeStruct &&
        currentWeek == other.currentWeek &&
        previousWeek == other.previousWeek;
  }

  @override
  int get hashCode => const ListEquality().hash([currentWeek, previousWeek]);
}

DashboardComIndBundleDataTypeStruct createDashboardComIndBundleDataTypeStruct({
  DashboardComIndDataTypeStruct? currentWeek,
  DashboardComIndDataTypeStruct? previousWeek,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DashboardComIndBundleDataTypeStruct(
      currentWeek: currentWeek ??
          (clearUnsetFields ? DashboardComIndDataTypeStruct() : null),
      previousWeek: previousWeek ??
          (clearUnsetFields ? DashboardComIndDataTypeStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DashboardComIndBundleDataTypeStruct? updateDashboardComIndBundleDataTypeStruct(
  DashboardComIndBundleDataTypeStruct? dashboardComIndBundleDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dashboardComIndBundleDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDashboardComIndBundleDataTypeStructData(
  Map<String, dynamic> firestoreData,
  DashboardComIndBundleDataTypeStruct? dashboardComIndBundleDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dashboardComIndBundleDataType == null) {
    return;
  }
  if (dashboardComIndBundleDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      dashboardComIndBundleDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dashboardComIndBundleDataTypeData =
      getDashboardComIndBundleDataTypeFirestoreData(
          dashboardComIndBundleDataType, forFieldValue);
  final nestedData = dashboardComIndBundleDataTypeData
      .map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      dashboardComIndBundleDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDashboardComIndBundleDataTypeFirestoreData(
  DashboardComIndBundleDataTypeStruct? dashboardComIndBundleDataType, [
  bool forFieldValue = false,
]) {
  if (dashboardComIndBundleDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dashboardComIndBundleDataType.toMap());

  // Handle nested data for "currentWeek" field.
  addDashboardComIndDataTypeStructData(
    firestoreData,
    dashboardComIndBundleDataType.hasCurrentWeek()
        ? dashboardComIndBundleDataType.currentWeek
        : null,
    'currentWeek',
    forFieldValue,
  );

  // Handle nested data for "previousWeek" field.
  addDashboardComIndDataTypeStructData(
    firestoreData,
    dashboardComIndBundleDataType.hasPreviousWeek()
        ? dashboardComIndBundleDataType.previousWeek
        : null,
    'previousWeek',
    forFieldValue,
  );

  // Add any Firestore field values
  dashboardComIndBundleDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDashboardComIndBundleDataTypeListFirestoreData(
  List<DashboardComIndBundleDataTypeStruct>? dashboardComIndBundleDataTypes,
) =>
    dashboardComIndBundleDataTypes
        ?.map((e) => getDashboardComIndBundleDataTypeFirestoreData(e, true))
        .toList() ??
    [];
