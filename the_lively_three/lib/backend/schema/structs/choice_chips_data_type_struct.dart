// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChoiceChipsDataTypeStruct extends FFFirebaseStruct {
  ChoiceChipsDataTypeStruct({
    int? id,
    String? label,
    String? color,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _label = label,
        _color = color,
        super(firestoreUtilData);

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "label" field.
  String? _label;
  String get label => _label ?? '';
  set label(String? val) => _label = val;

  bool hasLabel() => _label != null;

  // "color" field.
  String? _color;
  String get color => _color ?? '';
  set color(String? val) => _color = val;

  bool hasColor() => _color != null;

  static ChoiceChipsDataTypeStruct fromMap(Map<String, dynamic> data) =>
      ChoiceChipsDataTypeStruct(
        id: castToType<int>(data['id']),
        label: data['label'] as String?,
        color: data['color'] as String?,
      );

  static ChoiceChipsDataTypeStruct? maybeFromMap(dynamic data) => data is Map
      ? ChoiceChipsDataTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'label': _label,
        'color': _color,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'label': serializeParam(
          _label,
          ParamType.String,
        ),
        'color': serializeParam(
          _color,
          ParamType.String,
        ),
      }.withoutNulls;

  static ChoiceChipsDataTypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ChoiceChipsDataTypeStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        label: deserializeParam(
          data['label'],
          ParamType.String,
          false,
        ),
        color: deserializeParam(
          data['color'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ChoiceChipsDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ChoiceChipsDataTypeStruct &&
        id == other.id &&
        label == other.label &&
        color == other.color;
  }

  @override
  int get hashCode => const ListEquality().hash([id, label, color]);
}

ChoiceChipsDataTypeStruct createChoiceChipsDataTypeStruct({
  int? id,
  String? label,
  String? color,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ChoiceChipsDataTypeStruct(
      id: id,
      label: label,
      color: color,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ChoiceChipsDataTypeStruct? updateChoiceChipsDataTypeStruct(
  ChoiceChipsDataTypeStruct? choiceChipsDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    choiceChipsDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addChoiceChipsDataTypeStructData(
  Map<String, dynamic> firestoreData,
  ChoiceChipsDataTypeStruct? choiceChipsDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (choiceChipsDataType == null) {
    return;
  }
  if (choiceChipsDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && choiceChipsDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final choiceChipsDataTypeData =
      getChoiceChipsDataTypeFirestoreData(choiceChipsDataType, forFieldValue);
  final nestedData =
      choiceChipsDataTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      choiceChipsDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getChoiceChipsDataTypeFirestoreData(
  ChoiceChipsDataTypeStruct? choiceChipsDataType, [
  bool forFieldValue = false,
]) {
  if (choiceChipsDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(choiceChipsDataType.toMap());

  // Add any Firestore field values
  choiceChipsDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getChoiceChipsDataTypeListFirestoreData(
  List<ChoiceChipsDataTypeStruct>? choiceChipsDataTypes,
) =>
    choiceChipsDataTypes
        ?.map((e) => getChoiceChipsDataTypeFirestoreData(e, true))
        .toList() ??
    [];
