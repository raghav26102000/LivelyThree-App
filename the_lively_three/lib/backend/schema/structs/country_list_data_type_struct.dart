// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CountryListDataTypeStruct extends FFFirebaseStruct {
  CountryListDataTypeStruct({
    int? id,
    String? label,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _label = label,
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

  static CountryListDataTypeStruct fromMap(Map<String, dynamic> data) =>
      CountryListDataTypeStruct(
        id: castToType<int>(data['id']),
        label: data['label'] as String?,
      );

  static CountryListDataTypeStruct? maybeFromMap(dynamic data) => data is Map
      ? CountryListDataTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'label': _label,
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
      }.withoutNulls;

  static CountryListDataTypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CountryListDataTypeStruct(
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
      );

  @override
  String toString() => 'CountryListDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CountryListDataTypeStruct &&
        id == other.id &&
        label == other.label;
  }

  @override
  int get hashCode => const ListEquality().hash([id, label]);
}

CountryListDataTypeStruct createCountryListDataTypeStruct({
  int? id,
  String? label,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CountryListDataTypeStruct(
      id: id,
      label: label,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CountryListDataTypeStruct? updateCountryListDataTypeStruct(
  CountryListDataTypeStruct? countryListDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    countryListDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCountryListDataTypeStructData(
  Map<String, dynamic> firestoreData,
  CountryListDataTypeStruct? countryListDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (countryListDataType == null) {
    return;
  }
  if (countryListDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && countryListDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final countryListDataTypeData =
      getCountryListDataTypeFirestoreData(countryListDataType, forFieldValue);
  final nestedData =
      countryListDataTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      countryListDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCountryListDataTypeFirestoreData(
  CountryListDataTypeStruct? countryListDataType, [
  bool forFieldValue = false,
]) {
  if (countryListDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(countryListDataType.toMap());

  // Add any Firestore field values
  countryListDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCountryListDataTypeListFirestoreData(
  List<CountryListDataTypeStruct>? countryListDataTypes,
) =>
    countryListDataTypes
        ?.map((e) => getCountryListDataTypeFirestoreData(e, true))
        .toList() ??
    [];
