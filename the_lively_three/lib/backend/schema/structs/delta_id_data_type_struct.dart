// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DeltaIdDataTypeStruct extends FFFirebaseStruct {
  DeltaIdDataTypeStruct({
    int? index,
    int? idField,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _index = index,
        _idField = idField,
        super(firestoreUtilData);

  // "index" field.
  int? _index;
  int get index => _index ?? 0;
  set index(int? val) => _index = val;

  void incrementIndex(int amount) => index = index + amount;

  bool hasIndex() => _index != null;

  // "id_field" field.
  int? _idField;
  int get idField => _idField ?? 0;
  set idField(int? val) => _idField = val;

  void incrementIdField(int amount) => idField = idField + amount;

  bool hasIdField() => _idField != null;

  static DeltaIdDataTypeStruct fromMap(Map<String, dynamic> data) =>
      DeltaIdDataTypeStruct(
        index: castToType<int>(data['index']),
        idField: castToType<int>(data['id_field']),
      );

  static DeltaIdDataTypeStruct? maybeFromMap(dynamic data) => data is Map
      ? DeltaIdDataTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'index': _index,
        'id_field': _idField,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'index': serializeParam(
          _index,
          ParamType.int,
        ),
        'id_field': serializeParam(
          _idField,
          ParamType.int,
        ),
      }.withoutNulls;

  static DeltaIdDataTypeStruct fromSerializableMap(Map<String, dynamic> data) =>
      DeltaIdDataTypeStruct(
        index: deserializeParam(
          data['index'],
          ParamType.int,
          false,
        ),
        idField: deserializeParam(
          data['id_field'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DeltaIdDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DeltaIdDataTypeStruct &&
        index == other.index &&
        idField == other.idField;
  }

  @override
  int get hashCode => const ListEquality().hash([index, idField]);
}

DeltaIdDataTypeStruct createDeltaIdDataTypeStruct({
  int? index,
  int? idField,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DeltaIdDataTypeStruct(
      index: index,
      idField: idField,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DeltaIdDataTypeStruct? updateDeltaIdDataTypeStruct(
  DeltaIdDataTypeStruct? deltaIdDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    deltaIdDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDeltaIdDataTypeStructData(
  Map<String, dynamic> firestoreData,
  DeltaIdDataTypeStruct? deltaIdDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (deltaIdDataType == null) {
    return;
  }
  if (deltaIdDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && deltaIdDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final deltaIdDataTypeData =
      getDeltaIdDataTypeFirestoreData(deltaIdDataType, forFieldValue);
  final nestedData =
      deltaIdDataTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = deltaIdDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDeltaIdDataTypeFirestoreData(
  DeltaIdDataTypeStruct? deltaIdDataType, [
  bool forFieldValue = false,
]) {
  if (deltaIdDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(deltaIdDataType.toMap());

  // Add any Firestore field values
  deltaIdDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDeltaIdDataTypeListFirestoreData(
  List<DeltaIdDataTypeStruct>? deltaIdDataTypes,
) =>
    deltaIdDataTypes
        ?.map((e) => getDeltaIdDataTypeFirestoreData(e, true))
        .toList() ??
    [];
