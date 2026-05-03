// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PanelCoordinatesDataTypeStruct extends FFFirebaseStruct {
  PanelCoordinatesDataTypeStruct({
    DateTime? dateTime,
    int? coordinateX,
    int? coordinateY,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _dateTime = dateTime,
        _coordinateX = coordinateX,
        _coordinateY = coordinateY,
        super(firestoreUtilData);

  // "dateTime" field.
  DateTime? _dateTime;
  DateTime? get dateTime => _dateTime;
  set dateTime(DateTime? val) => _dateTime = val;

  bool hasDateTime() => _dateTime != null;

  // "coordinateX" field.
  int? _coordinateX;
  int get coordinateX => _coordinateX ?? 0;
  set coordinateX(int? val) => _coordinateX = val;

  void incrementCoordinateX(int amount) => coordinateX = coordinateX + amount;

  bool hasCoordinateX() => _coordinateX != null;

  // "coordinateY" field.
  int? _coordinateY;
  int get coordinateY => _coordinateY ?? 0;
  set coordinateY(int? val) => _coordinateY = val;

  void incrementCoordinateY(int amount) => coordinateY = coordinateY + amount;

  bool hasCoordinateY() => _coordinateY != null;

  static PanelCoordinatesDataTypeStruct fromMap(Map<String, dynamic> data) =>
      PanelCoordinatesDataTypeStruct(
        dateTime: data['dateTime'] as DateTime?,
        coordinateX: castToType<int>(data['coordinateX']),
        coordinateY: castToType<int>(data['coordinateY']),
      );

  static PanelCoordinatesDataTypeStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? PanelCoordinatesDataTypeStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'dateTime': _dateTime,
        'coordinateX': _coordinateX,
        'coordinateY': _coordinateY,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'dateTime': serializeParam(
          _dateTime,
          ParamType.DateTime,
        ),
        'coordinateX': serializeParam(
          _coordinateX,
          ParamType.int,
        ),
        'coordinateY': serializeParam(
          _coordinateY,
          ParamType.int,
        ),
      }.withoutNulls;

  static PanelCoordinatesDataTypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PanelCoordinatesDataTypeStruct(
        dateTime: deserializeParam(
          data['dateTime'],
          ParamType.DateTime,
          false,
        ),
        coordinateX: deserializeParam(
          data['coordinateX'],
          ParamType.int,
          false,
        ),
        coordinateY: deserializeParam(
          data['coordinateY'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'PanelCoordinatesDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PanelCoordinatesDataTypeStruct &&
        dateTime == other.dateTime &&
        coordinateX == other.coordinateX &&
        coordinateY == other.coordinateY;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([dateTime, coordinateX, coordinateY]);
}

PanelCoordinatesDataTypeStruct createPanelCoordinatesDataTypeStruct({
  DateTime? dateTime,
  int? coordinateX,
  int? coordinateY,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PanelCoordinatesDataTypeStruct(
      dateTime: dateTime,
      coordinateX: coordinateX,
      coordinateY: coordinateY,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PanelCoordinatesDataTypeStruct? updatePanelCoordinatesDataTypeStruct(
  PanelCoordinatesDataTypeStruct? panelCoordinatesDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    panelCoordinatesDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPanelCoordinatesDataTypeStructData(
  Map<String, dynamic> firestoreData,
  PanelCoordinatesDataTypeStruct? panelCoordinatesDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (panelCoordinatesDataType == null) {
    return;
  }
  if (panelCoordinatesDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      panelCoordinatesDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final panelCoordinatesDataTypeData = getPanelCoordinatesDataTypeFirestoreData(
      panelCoordinatesDataType, forFieldValue);
  final nestedData =
      panelCoordinatesDataTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      panelCoordinatesDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPanelCoordinatesDataTypeFirestoreData(
  PanelCoordinatesDataTypeStruct? panelCoordinatesDataType, [
  bool forFieldValue = false,
]) {
  if (panelCoordinatesDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(panelCoordinatesDataType.toMap());

  // Add any Firestore field values
  panelCoordinatesDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPanelCoordinatesDataTypeListFirestoreData(
  List<PanelCoordinatesDataTypeStruct>? panelCoordinatesDataTypes,
) =>
    panelCoordinatesDataTypes
        ?.map((e) => getPanelCoordinatesDataTypeFirestoreData(e, true))
        .toList() ??
    [];
