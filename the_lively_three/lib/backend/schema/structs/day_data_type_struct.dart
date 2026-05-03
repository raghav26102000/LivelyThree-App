// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DayDataTypeStruct extends FFFirebaseStruct {
  DayDataTypeStruct({
    int? idx,
    String? day,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _idx = idx,
        _day = day,
        super(firestoreUtilData);

  // "idx" field.
  int? _idx;
  int get idx => _idx ?? 0;
  set idx(int? val) => _idx = val;

  void incrementIdx(int amount) => idx = idx + amount;

  bool hasIdx() => _idx != null;

  // "day" field.
  String? _day;
  String get day => _day ?? '';
  set day(String? val) => _day = val;

  bool hasDay() => _day != null;

  static DayDataTypeStruct fromMap(Map<String, dynamic> data) =>
      DayDataTypeStruct(
        idx: castToType<int>(data['idx']),
        day: data['day'] as String?,
      );

  static DayDataTypeStruct? maybeFromMap(dynamic data) => data is Map
      ? DayDataTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'idx': _idx,
        'day': _day,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'idx': serializeParam(
          _idx,
          ParamType.int,
        ),
        'day': serializeParam(
          _day,
          ParamType.String,
        ),
      }.withoutNulls;

  static DayDataTypeStruct fromSerializableMap(Map<String, dynamic> data) =>
      DayDataTypeStruct(
        idx: deserializeParam(
          data['idx'],
          ParamType.int,
          false,
        ),
        day: deserializeParam(
          data['day'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DayDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DayDataTypeStruct && idx == other.idx && day == other.day;
  }

  @override
  int get hashCode => const ListEquality().hash([idx, day]);
}

DayDataTypeStruct createDayDataTypeStruct({
  int? idx,
  String? day,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DayDataTypeStruct(
      idx: idx,
      day: day,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DayDataTypeStruct? updateDayDataTypeStruct(
  DayDataTypeStruct? dayDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dayDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDayDataTypeStructData(
  Map<String, dynamic> firestoreData,
  DayDataTypeStruct? dayDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dayDataType == null) {
    return;
  }
  if (dayDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && dayDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dayDataTypeData =
      getDayDataTypeFirestoreData(dayDataType, forFieldValue);
  final nestedData =
      dayDataTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = dayDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDayDataTypeFirestoreData(
  DayDataTypeStruct? dayDataType, [
  bool forFieldValue = false,
]) {
  if (dayDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dayDataType.toMap());

  // Add any Firestore field values
  dayDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDayDataTypeListFirestoreData(
  List<DayDataTypeStruct>? dayDataTypes,
) =>
    dayDataTypes?.map((e) => getDayDataTypeFirestoreData(e, true)).toList() ??
    [];
