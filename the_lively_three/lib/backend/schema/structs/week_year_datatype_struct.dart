// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WeekYearDatatypeStruct extends FFFirebaseStruct {
  WeekYearDatatypeStruct({
    int? week,
    int? year,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _week = week,
        _year = year,
        super(firestoreUtilData);

  // "week" field.
  int? _week;
  int get week => _week ?? 0;
  set week(int? val) => _week = val;

  void incrementWeek(int amount) => week = week + amount;

  bool hasWeek() => _week != null;

  // "year" field.
  int? _year;
  int get year => _year ?? 0;
  set year(int? val) => _year = val;

  void incrementYear(int amount) => year = year + amount;

  bool hasYear() => _year != null;

  static WeekYearDatatypeStruct fromMap(Map<String, dynamic> data) =>
      WeekYearDatatypeStruct(
        week: castToType<int>(data['week']),
        year: castToType<int>(data['year']),
      );

  static WeekYearDatatypeStruct? maybeFromMap(dynamic data) => data is Map
      ? WeekYearDatatypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'week': _week,
        'year': _year,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'week': serializeParam(
          _week,
          ParamType.int,
        ),
        'year': serializeParam(
          _year,
          ParamType.int,
        ),
      }.withoutNulls;

  static WeekYearDatatypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      WeekYearDatatypeStruct(
        week: deserializeParam(
          data['week'],
          ParamType.int,
          false,
        ),
        year: deserializeParam(
          data['year'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'WeekYearDatatypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WeekYearDatatypeStruct &&
        week == other.week &&
        year == other.year;
  }

  @override
  int get hashCode => const ListEquality().hash([week, year]);
}

WeekYearDatatypeStruct createWeekYearDatatypeStruct({
  int? week,
  int? year,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    WeekYearDatatypeStruct(
      week: week,
      year: year,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

WeekYearDatatypeStruct? updateWeekYearDatatypeStruct(
  WeekYearDatatypeStruct? weekYearDatatype, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    weekYearDatatype
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addWeekYearDatatypeStructData(
  Map<String, dynamic> firestoreData,
  WeekYearDatatypeStruct? weekYearDatatype,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (weekYearDatatype == null) {
    return;
  }
  if (weekYearDatatype.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && weekYearDatatype.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final weekYearDatatypeData =
      getWeekYearDatatypeFirestoreData(weekYearDatatype, forFieldValue);
  final nestedData =
      weekYearDatatypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = weekYearDatatype.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getWeekYearDatatypeFirestoreData(
  WeekYearDatatypeStruct? weekYearDatatype, [
  bool forFieldValue = false,
]) {
  if (weekYearDatatype == null) {
    return {};
  }
  final firestoreData = mapToFirestore(weekYearDatatype.toMap());

  // Add any Firestore field values
  weekYearDatatype.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getWeekYearDatatypeListFirestoreData(
  List<WeekYearDatatypeStruct>? weekYearDatatypes,
) =>
    weekYearDatatypes
        ?.map((e) => getWeekYearDatatypeFirestoreData(e, true))
        .toList() ??
    [];
