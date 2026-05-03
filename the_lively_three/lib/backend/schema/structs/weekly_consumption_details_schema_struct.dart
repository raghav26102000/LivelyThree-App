// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WeeklyConsumptionDetailsSchemaStruct extends FFFirebaseStruct {
  WeeklyConsumptionDetailsSchemaStruct({
    int? week,
    int? calendarYear,
    String? plantname,
    String? color,
    String? day,
    double? portionPlant,
    int? portionWater,
    int? portionUpf,
    int? dateDay,
    int? dateMonth,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _week = week,
        _calendarYear = calendarYear,
        _plantname = plantname,
        _color = color,
        _day = day,
        _portionPlant = portionPlant,
        _portionWater = portionWater,
        _portionUpf = portionUpf,
        _dateDay = dateDay,
        _dateMonth = dateMonth,
        super(firestoreUtilData);

  // "week" field.
  int? _week;
  int get week => _week ?? 0;
  set week(int? val) => _week = val;

  void incrementWeek(int amount) => week = week + amount;

  bool hasWeek() => _week != null;

  // "calendarYear" field.
  int? _calendarYear;
  int get calendarYear => _calendarYear ?? 0;
  set calendarYear(int? val) => _calendarYear = val;

  void incrementCalendarYear(int amount) =>
      calendarYear = calendarYear + amount;

  bool hasCalendarYear() => _calendarYear != null;

  // "plantname" field.
  String? _plantname;
  String get plantname => _plantname ?? '';
  set plantname(String? val) => _plantname = val;

  bool hasPlantname() => _plantname != null;

  // "color" field.
  String? _color;
  String get color => _color ?? '';
  set color(String? val) => _color = val;

  bool hasColor() => _color != null;

  // "day" field.
  String? _day;
  String get day => _day ?? '';
  set day(String? val) => _day = val;

  bool hasDay() => _day != null;

  // "portionPlant" field.
  double? _portionPlant;
  double get portionPlant => _portionPlant ?? 0.0;
  set portionPlant(double? val) => _portionPlant = val;

  void incrementPortionPlant(double amount) =>
      portionPlant = portionPlant + amount;

  bool hasPortionPlant() => _portionPlant != null;

  // "portionWater" field.
  int? _portionWater;
  int get portionWater => _portionWater ?? 0;
  set portionWater(int? val) => _portionWater = val;

  void incrementPortionWater(int amount) =>
      portionWater = portionWater + amount;

  bool hasPortionWater() => _portionWater != null;

  // "portionUpf" field.
  int? _portionUpf;
  int get portionUpf => _portionUpf ?? 0;
  set portionUpf(int? val) => _portionUpf = val;

  void incrementPortionUpf(int amount) => portionUpf = portionUpf + amount;

  bool hasPortionUpf() => _portionUpf != null;

  // "dateDay" field.
  int? _dateDay;
  int get dateDay => _dateDay ?? 0;
  set dateDay(int? val) => _dateDay = val;

  void incrementDateDay(int amount) => dateDay = dateDay + amount;

  bool hasDateDay() => _dateDay != null;

  // "dateMonth" field.
  int? _dateMonth;
  int get dateMonth => _dateMonth ?? 0;
  set dateMonth(int? val) => _dateMonth = val;

  void incrementDateMonth(int amount) => dateMonth = dateMonth + amount;

  bool hasDateMonth() => _dateMonth != null;

  static WeeklyConsumptionDetailsSchemaStruct fromMap(
          Map<String, dynamic> data) =>
      WeeklyConsumptionDetailsSchemaStruct(
        week: castToType<int>(data['week']),
        calendarYear: castToType<int>(data['calendarYear']),
        plantname: data['plantname'] as String?,
        color: data['color'] as String?,
        day: data['day'] as String?,
        portionPlant: castToType<double>(data['portionPlant']),
        portionWater: castToType<int>(data['portionWater']),
        portionUpf: castToType<int>(data['portionUpf']),
        dateDay: castToType<int>(data['dateDay']),
        dateMonth: castToType<int>(data['dateMonth']),
      );

  static WeeklyConsumptionDetailsSchemaStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? WeeklyConsumptionDetailsSchemaStruct.fromMap(
              data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'week': _week,
        'calendarYear': _calendarYear,
        'plantname': _plantname,
        'color': _color,
        'day': _day,
        'portionPlant': _portionPlant,
        'portionWater': _portionWater,
        'portionUpf': _portionUpf,
        'dateDay': _dateDay,
        'dateMonth': _dateMonth,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'week': serializeParam(
          _week,
          ParamType.int,
        ),
        'calendarYear': serializeParam(
          _calendarYear,
          ParamType.int,
        ),
        'plantname': serializeParam(
          _plantname,
          ParamType.String,
        ),
        'color': serializeParam(
          _color,
          ParamType.String,
        ),
        'day': serializeParam(
          _day,
          ParamType.String,
        ),
        'portionPlant': serializeParam(
          _portionPlant,
          ParamType.double,
        ),
        'portionWater': serializeParam(
          _portionWater,
          ParamType.int,
        ),
        'portionUpf': serializeParam(
          _portionUpf,
          ParamType.int,
        ),
        'dateDay': serializeParam(
          _dateDay,
          ParamType.int,
        ),
        'dateMonth': serializeParam(
          _dateMonth,
          ParamType.int,
        ),
      }.withoutNulls;

  static WeeklyConsumptionDetailsSchemaStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      WeeklyConsumptionDetailsSchemaStruct(
        week: deserializeParam(
          data['week'],
          ParamType.int,
          false,
        ),
        calendarYear: deserializeParam(
          data['calendarYear'],
          ParamType.int,
          false,
        ),
        plantname: deserializeParam(
          data['plantname'],
          ParamType.String,
          false,
        ),
        color: deserializeParam(
          data['color'],
          ParamType.String,
          false,
        ),
        day: deserializeParam(
          data['day'],
          ParamType.String,
          false,
        ),
        portionPlant: deserializeParam(
          data['portionPlant'],
          ParamType.double,
          false,
        ),
        portionWater: deserializeParam(
          data['portionWater'],
          ParamType.int,
          false,
        ),
        portionUpf: deserializeParam(
          data['portionUpf'],
          ParamType.int,
          false,
        ),
        dateDay: deserializeParam(
          data['dateDay'],
          ParamType.int,
          false,
        ),
        dateMonth: deserializeParam(
          data['dateMonth'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'WeeklyConsumptionDetailsSchemaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WeeklyConsumptionDetailsSchemaStruct &&
        week == other.week &&
        calendarYear == other.calendarYear &&
        plantname == other.plantname &&
        color == other.color &&
        day == other.day &&
        portionPlant == other.portionPlant &&
        portionWater == other.portionWater &&
        portionUpf == other.portionUpf &&
        dateDay == other.dateDay &&
        dateMonth == other.dateMonth;
  }

  @override
  int get hashCode => const ListEquality().hash([
        week,
        calendarYear,
        plantname,
        color,
        day,
        portionPlant,
        portionWater,
        portionUpf,
        dateDay,
        dateMonth
      ]);
}

WeeklyConsumptionDetailsSchemaStruct
    createWeeklyConsumptionDetailsSchemaStruct({
  int? week,
  int? calendarYear,
  String? plantname,
  String? color,
  String? day,
  double? portionPlant,
  int? portionWater,
  int? portionUpf,
  int? dateDay,
  int? dateMonth,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
        WeeklyConsumptionDetailsSchemaStruct(
          week: week,
          calendarYear: calendarYear,
          plantname: plantname,
          color: color,
          day: day,
          portionPlant: portionPlant,
          portionWater: portionWater,
          portionUpf: portionUpf,
          dateDay: dateDay,
          dateMonth: dateMonth,
          firestoreUtilData: FirestoreUtilData(
            clearUnsetFields: clearUnsetFields,
            create: create,
            delete: delete,
            fieldValues: fieldValues,
          ),
        );

WeeklyConsumptionDetailsSchemaStruct?
    updateWeeklyConsumptionDetailsSchemaStruct(
  WeeklyConsumptionDetailsSchemaStruct? weeklyConsumptionDetailsSchema, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
        weeklyConsumptionDetailsSchema
          ?..firestoreUtilData = FirestoreUtilData(
            clearUnsetFields: clearUnsetFields,
            create: create,
          );

void addWeeklyConsumptionDetailsSchemaStructData(
  Map<String, dynamic> firestoreData,
  WeeklyConsumptionDetailsSchemaStruct? weeklyConsumptionDetailsSchema,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (weeklyConsumptionDetailsSchema == null) {
    return;
  }
  if (weeklyConsumptionDetailsSchema.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      weeklyConsumptionDetailsSchema.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final weeklyConsumptionDetailsSchemaData =
      getWeeklyConsumptionDetailsSchemaFirestoreData(
          weeklyConsumptionDetailsSchema, forFieldValue);
  final nestedData = weeklyConsumptionDetailsSchemaData
      .map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      weeklyConsumptionDetailsSchema.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getWeeklyConsumptionDetailsSchemaFirestoreData(
  WeeklyConsumptionDetailsSchemaStruct? weeklyConsumptionDetailsSchema, [
  bool forFieldValue = false,
]) {
  if (weeklyConsumptionDetailsSchema == null) {
    return {};
  }
  final firestoreData = mapToFirestore(weeklyConsumptionDetailsSchema.toMap());

  // Add any Firestore field values
  weeklyConsumptionDetailsSchema.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getWeeklyConsumptionDetailsSchemaListFirestoreData(
  List<WeeklyConsumptionDetailsSchemaStruct>? weeklyConsumptionDetailsSchemas,
) =>
    weeklyConsumptionDetailsSchemas
        ?.map((e) => getWeeklyConsumptionDetailsSchemaFirestoreData(e, true))
        .toList() ??
    [];
