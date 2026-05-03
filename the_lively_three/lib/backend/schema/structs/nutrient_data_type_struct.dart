// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NutrientDataTypeStruct extends FFFirebaseStruct {
  NutrientDataTypeStruct({
    int? idNutrient,
    int? idBlueprint,
    String? nutrientLabel,
    double? nutrientValue,
    String? nutrientDescription,
    String? nutrientReference,
    int? id,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _idNutrient = idNutrient,
        _idBlueprint = idBlueprint,
        _nutrientLabel = nutrientLabel,
        _nutrientValue = nutrientValue,
        _nutrientDescription = nutrientDescription,
        _nutrientReference = nutrientReference,
        _id = id,
        super(firestoreUtilData);

  // "id_nutrient" field.
  int? _idNutrient;
  int get idNutrient => _idNutrient ?? 0;
  set idNutrient(int? val) => _idNutrient = val;

  void incrementIdNutrient(int amount) => idNutrient = idNutrient + amount;

  bool hasIdNutrient() => _idNutrient != null;

  // "id_blueprint" field.
  int? _idBlueprint;
  int get idBlueprint => _idBlueprint ?? 0;
  set idBlueprint(int? val) => _idBlueprint = val;

  void incrementIdBlueprint(int amount) => idBlueprint = idBlueprint + amount;

  bool hasIdBlueprint() => _idBlueprint != null;

  // "nutrientLabel" field.
  String? _nutrientLabel;
  String get nutrientLabel => _nutrientLabel ?? '';
  set nutrientLabel(String? val) => _nutrientLabel = val;

  bool hasNutrientLabel() => _nutrientLabel != null;

  // "nutrientValue" field.
  double? _nutrientValue;
  double get nutrientValue => _nutrientValue ?? 0.0;
  set nutrientValue(double? val) => _nutrientValue = val;

  void incrementNutrientValue(double amount) =>
      nutrientValue = nutrientValue + amount;

  bool hasNutrientValue() => _nutrientValue != null;

  // "nutrientDescription" field.
  String? _nutrientDescription;
  String get nutrientDescription => _nutrientDescription ?? '';
  set nutrientDescription(String? val) => _nutrientDescription = val;

  bool hasNutrientDescription() => _nutrientDescription != null;

  // "nutrientReference" field.
  String? _nutrientReference;
  String get nutrientReference => _nutrientReference ?? '';
  set nutrientReference(String? val) => _nutrientReference = val;

  bool hasNutrientReference() => _nutrientReference != null;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  static NutrientDataTypeStruct fromMap(Map<String, dynamic> data) =>
      NutrientDataTypeStruct(
        idNutrient: castToType<int>(data['id_nutrient']),
        idBlueprint: castToType<int>(data['id_blueprint']),
        nutrientLabel: data['nutrientLabel'] as String?,
        nutrientValue: castToType<double>(data['nutrientValue']),
        nutrientDescription: data['nutrientDescription'] as String?,
        nutrientReference: data['nutrientReference'] as String?,
        id: castToType<int>(data['id']),
      );

  static NutrientDataTypeStruct? maybeFromMap(dynamic data) => data is Map
      ? NutrientDataTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id_nutrient': _idNutrient,
        'id_blueprint': _idBlueprint,
        'nutrientLabel': _nutrientLabel,
        'nutrientValue': _nutrientValue,
        'nutrientDescription': _nutrientDescription,
        'nutrientReference': _nutrientReference,
        'id': _id,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id_nutrient': serializeParam(
          _idNutrient,
          ParamType.int,
        ),
        'id_blueprint': serializeParam(
          _idBlueprint,
          ParamType.int,
        ),
        'nutrientLabel': serializeParam(
          _nutrientLabel,
          ParamType.String,
        ),
        'nutrientValue': serializeParam(
          _nutrientValue,
          ParamType.double,
        ),
        'nutrientDescription': serializeParam(
          _nutrientDescription,
          ParamType.String,
        ),
        'nutrientReference': serializeParam(
          _nutrientReference,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
      }.withoutNulls;

  static NutrientDataTypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      NutrientDataTypeStruct(
        idNutrient: deserializeParam(
          data['id_nutrient'],
          ParamType.int,
          false,
        ),
        idBlueprint: deserializeParam(
          data['id_blueprint'],
          ParamType.int,
          false,
        ),
        nutrientLabel: deserializeParam(
          data['nutrientLabel'],
          ParamType.String,
          false,
        ),
        nutrientValue: deserializeParam(
          data['nutrientValue'],
          ParamType.double,
          false,
        ),
        nutrientDescription: deserializeParam(
          data['nutrientDescription'],
          ParamType.String,
          false,
        ),
        nutrientReference: deserializeParam(
          data['nutrientReference'],
          ParamType.String,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'NutrientDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NutrientDataTypeStruct &&
        idNutrient == other.idNutrient &&
        idBlueprint == other.idBlueprint &&
        nutrientLabel == other.nutrientLabel &&
        nutrientValue == other.nutrientValue &&
        nutrientDescription == other.nutrientDescription &&
        nutrientReference == other.nutrientReference &&
        id == other.id;
  }

  @override
  int get hashCode => const ListEquality().hash([
        idNutrient,
        idBlueprint,
        nutrientLabel,
        nutrientValue,
        nutrientDescription,
        nutrientReference,
        id
      ]);
}

NutrientDataTypeStruct createNutrientDataTypeStruct({
  int? idNutrient,
  int? idBlueprint,
  String? nutrientLabel,
  double? nutrientValue,
  String? nutrientDescription,
  String? nutrientReference,
  int? id,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    NutrientDataTypeStruct(
      idNutrient: idNutrient,
      idBlueprint: idBlueprint,
      nutrientLabel: nutrientLabel,
      nutrientValue: nutrientValue,
      nutrientDescription: nutrientDescription,
      nutrientReference: nutrientReference,
      id: id,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

NutrientDataTypeStruct? updateNutrientDataTypeStruct(
  NutrientDataTypeStruct? nutrientDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    nutrientDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addNutrientDataTypeStructData(
  Map<String, dynamic> firestoreData,
  NutrientDataTypeStruct? nutrientDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (nutrientDataType == null) {
    return;
  }
  if (nutrientDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && nutrientDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final nutrientDataTypeData =
      getNutrientDataTypeFirestoreData(nutrientDataType, forFieldValue);
  final nestedData =
      nutrientDataTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = nutrientDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getNutrientDataTypeFirestoreData(
  NutrientDataTypeStruct? nutrientDataType, [
  bool forFieldValue = false,
]) {
  if (nutrientDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(nutrientDataType.toMap());

  // Add any Firestore field values
  nutrientDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getNutrientDataTypeListFirestoreData(
  List<NutrientDataTypeStruct>? nutrientDataTypes,
) =>
    nutrientDataTypes
        ?.map((e) => getNutrientDataTypeFirestoreData(e, true))
        .toList() ??
    [];
