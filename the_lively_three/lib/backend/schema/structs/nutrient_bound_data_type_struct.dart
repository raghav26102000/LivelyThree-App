// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NutrientBoundDataTypeStruct extends FFFirebaseStruct {
  NutrientBoundDataTypeStruct({
    double? fiberLower,
    double? fiberActual,
    double? fiberUpper,
    double? proteinLower,
    double? proteinActual,
    double? proteinUpper,
    double? fatLower,
    double? fatActual,
    double? fatUpper,
    double? carbsLower,
    double? carbsActual,
    double? carbsUpper,
    String? fiberPlantLower,
    String? fiberPlantUpper,
    String? proteinPlantLower,
    String? proteinPlantUpper,
    String? fatPlantLower,
    String? fatPlantUpper,
    String? carbsPlantLower,
    String? carbsPlantUpper,
    int? fiberRating,
    int? proteinRating,
    bool? inThirdRule,
    String? fiberValueReference,
    String? carbsValueReference,
    String? proteinValueReference,
    String? fatValueReference,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _fiberLower = fiberLower,
        _fiberActual = fiberActual,
        _fiberUpper = fiberUpper,
        _proteinLower = proteinLower,
        _proteinActual = proteinActual,
        _proteinUpper = proteinUpper,
        _fatLower = fatLower,
        _fatActual = fatActual,
        _fatUpper = fatUpper,
        _carbsLower = carbsLower,
        _carbsActual = carbsActual,
        _carbsUpper = carbsUpper,
        _fiberPlantLower = fiberPlantLower,
        _fiberPlantUpper = fiberPlantUpper,
        _proteinPlantLower = proteinPlantLower,
        _proteinPlantUpper = proteinPlantUpper,
        _fatPlantLower = fatPlantLower,
        _fatPlantUpper = fatPlantUpper,
        _carbsPlantLower = carbsPlantLower,
        _carbsPlantUpper = carbsPlantUpper,
        _fiberRating = fiberRating,
        _proteinRating = proteinRating,
        _inThirdRule = inThirdRule,
        _fiberValueReference = fiberValueReference,
        _carbsValueReference = carbsValueReference,
        _proteinValueReference = proteinValueReference,
        _fatValueReference = fatValueReference,
        super(firestoreUtilData);

  // "fiberLower" field.
  double? _fiberLower;
  double get fiberLower => _fiberLower ?? 0.0;
  set fiberLower(double? val) => _fiberLower = val;

  void incrementFiberLower(double amount) => fiberLower = fiberLower + amount;

  bool hasFiberLower() => _fiberLower != null;

  // "fiberActual" field.
  double? _fiberActual;
  double get fiberActual => _fiberActual ?? 0.0;
  set fiberActual(double? val) => _fiberActual = val;

  void incrementFiberActual(double amount) =>
      fiberActual = fiberActual + amount;

  bool hasFiberActual() => _fiberActual != null;

  // "fiberUpper" field.
  double? _fiberUpper;
  double get fiberUpper => _fiberUpper ?? 0.0;
  set fiberUpper(double? val) => _fiberUpper = val;

  void incrementFiberUpper(double amount) => fiberUpper = fiberUpper + amount;

  bool hasFiberUpper() => _fiberUpper != null;

  // "proteinLower" field.
  double? _proteinLower;
  double get proteinLower => _proteinLower ?? 0.0;
  set proteinLower(double? val) => _proteinLower = val;

  void incrementProteinLower(double amount) =>
      proteinLower = proteinLower + amount;

  bool hasProteinLower() => _proteinLower != null;

  // "proteinActual" field.
  double? _proteinActual;
  double get proteinActual => _proteinActual ?? 0.0;
  set proteinActual(double? val) => _proteinActual = val;

  void incrementProteinActual(double amount) =>
      proteinActual = proteinActual + amount;

  bool hasProteinActual() => _proteinActual != null;

  // "proteinUpper" field.
  double? _proteinUpper;
  double get proteinUpper => _proteinUpper ?? 0.0;
  set proteinUpper(double? val) => _proteinUpper = val;

  void incrementProteinUpper(double amount) =>
      proteinUpper = proteinUpper + amount;

  bool hasProteinUpper() => _proteinUpper != null;

  // "fatLower" field.
  double? _fatLower;
  double get fatLower => _fatLower ?? 0.0;
  set fatLower(double? val) => _fatLower = val;

  void incrementFatLower(double amount) => fatLower = fatLower + amount;

  bool hasFatLower() => _fatLower != null;

  // "fatActual" field.
  double? _fatActual;
  double get fatActual => _fatActual ?? 0.0;
  set fatActual(double? val) => _fatActual = val;

  void incrementFatActual(double amount) => fatActual = fatActual + amount;

  bool hasFatActual() => _fatActual != null;

  // "fatUpper" field.
  double? _fatUpper;
  double get fatUpper => _fatUpper ?? 0.0;
  set fatUpper(double? val) => _fatUpper = val;

  void incrementFatUpper(double amount) => fatUpper = fatUpper + amount;

  bool hasFatUpper() => _fatUpper != null;

  // "carbsLower" field.
  double? _carbsLower;
  double get carbsLower => _carbsLower ?? 0.0;
  set carbsLower(double? val) => _carbsLower = val;

  void incrementCarbsLower(double amount) => carbsLower = carbsLower + amount;

  bool hasCarbsLower() => _carbsLower != null;

  // "carbsActual" field.
  double? _carbsActual;
  double get carbsActual => _carbsActual ?? 0.0;
  set carbsActual(double? val) => _carbsActual = val;

  void incrementCarbsActual(double amount) =>
      carbsActual = carbsActual + amount;

  bool hasCarbsActual() => _carbsActual != null;

  // "carbsUpper" field.
  double? _carbsUpper;
  double get carbsUpper => _carbsUpper ?? 0.0;
  set carbsUpper(double? val) => _carbsUpper = val;

  void incrementCarbsUpper(double amount) => carbsUpper = carbsUpper + amount;

  bool hasCarbsUpper() => _carbsUpper != null;

  // "fiberPlantLower" field.
  String? _fiberPlantLower;
  String get fiberPlantLower => _fiberPlantLower ?? '';
  set fiberPlantLower(String? val) => _fiberPlantLower = val;

  bool hasFiberPlantLower() => _fiberPlantLower != null;

  // "fiberPlantUpper" field.
  String? _fiberPlantUpper;
  String get fiberPlantUpper => _fiberPlantUpper ?? '';
  set fiberPlantUpper(String? val) => _fiberPlantUpper = val;

  bool hasFiberPlantUpper() => _fiberPlantUpper != null;

  // "proteinPlantLower" field.
  String? _proteinPlantLower;
  String get proteinPlantLower => _proteinPlantLower ?? '';
  set proteinPlantLower(String? val) => _proteinPlantLower = val;

  bool hasProteinPlantLower() => _proteinPlantLower != null;

  // "proteinPlantUpper" field.
  String? _proteinPlantUpper;
  String get proteinPlantUpper => _proteinPlantUpper ?? '';
  set proteinPlantUpper(String? val) => _proteinPlantUpper = val;

  bool hasProteinPlantUpper() => _proteinPlantUpper != null;

  // "fatPlantLower" field.
  String? _fatPlantLower;
  String get fatPlantLower => _fatPlantLower ?? '';
  set fatPlantLower(String? val) => _fatPlantLower = val;

  bool hasFatPlantLower() => _fatPlantLower != null;

  // "fatPlantUpper" field.
  String? _fatPlantUpper;
  String get fatPlantUpper => _fatPlantUpper ?? '';
  set fatPlantUpper(String? val) => _fatPlantUpper = val;

  bool hasFatPlantUpper() => _fatPlantUpper != null;

  // "carbsPlantLower" field.
  String? _carbsPlantLower;
  String get carbsPlantLower => _carbsPlantLower ?? '';
  set carbsPlantLower(String? val) => _carbsPlantLower = val;

  bool hasCarbsPlantLower() => _carbsPlantLower != null;

  // "carbsPlantUpper" field.
  String? _carbsPlantUpper;
  String get carbsPlantUpper => _carbsPlantUpper ?? '';
  set carbsPlantUpper(String? val) => _carbsPlantUpper = val;

  bool hasCarbsPlantUpper() => _carbsPlantUpper != null;

  // "fiberRating" field.
  int? _fiberRating;
  int get fiberRating => _fiberRating ?? 0;
  set fiberRating(int? val) => _fiberRating = val;

  void incrementFiberRating(int amount) => fiberRating = fiberRating + amount;

  bool hasFiberRating() => _fiberRating != null;

  // "proteinRating" field.
  int? _proteinRating;
  int get proteinRating => _proteinRating ?? 0;
  set proteinRating(int? val) => _proteinRating = val;

  void incrementProteinRating(int amount) =>
      proteinRating = proteinRating + amount;

  bool hasProteinRating() => _proteinRating != null;

  // "inThirdRule" field.
  bool? _inThirdRule;
  bool get inThirdRule => _inThirdRule ?? false;
  set inThirdRule(bool? val) => _inThirdRule = val;

  bool hasInThirdRule() => _inThirdRule != null;

  // "fiberValueReference" field.
  String? _fiberValueReference;
  String get fiberValueReference => _fiberValueReference ?? '';
  set fiberValueReference(String? val) => _fiberValueReference = val;

  bool hasFiberValueReference() => _fiberValueReference != null;

  // "carbsValueReference" field.
  String? _carbsValueReference;
  String get carbsValueReference => _carbsValueReference ?? '';
  set carbsValueReference(String? val) => _carbsValueReference = val;

  bool hasCarbsValueReference() => _carbsValueReference != null;

  // "proteinValueReference" field.
  String? _proteinValueReference;
  String get proteinValueReference => _proteinValueReference ?? '';
  set proteinValueReference(String? val) => _proteinValueReference = val;

  bool hasProteinValueReference() => _proteinValueReference != null;

  // "fatValueReference" field.
  String? _fatValueReference;
  String get fatValueReference => _fatValueReference ?? '';
  set fatValueReference(String? val) => _fatValueReference = val;

  bool hasFatValueReference() => _fatValueReference != null;

  static NutrientBoundDataTypeStruct fromMap(Map<String, dynamic> data) =>
      NutrientBoundDataTypeStruct(
        fiberLower: castToType<double>(data['fiberLower']),
        fiberActual: castToType<double>(data['fiberActual']),
        fiberUpper: castToType<double>(data['fiberUpper']),
        proteinLower: castToType<double>(data['proteinLower']),
        proteinActual: castToType<double>(data['proteinActual']),
        proteinUpper: castToType<double>(data['proteinUpper']),
        fatLower: castToType<double>(data['fatLower']),
        fatActual: castToType<double>(data['fatActual']),
        fatUpper: castToType<double>(data['fatUpper']),
        carbsLower: castToType<double>(data['carbsLower']),
        carbsActual: castToType<double>(data['carbsActual']),
        carbsUpper: castToType<double>(data['carbsUpper']),
        fiberPlantLower: data['fiberPlantLower'] as String?,
        fiberPlantUpper: data['fiberPlantUpper'] as String?,
        proteinPlantLower: data['proteinPlantLower'] as String?,
        proteinPlantUpper: data['proteinPlantUpper'] as String?,
        fatPlantLower: data['fatPlantLower'] as String?,
        fatPlantUpper: data['fatPlantUpper'] as String?,
        carbsPlantLower: data['carbsPlantLower'] as String?,
        carbsPlantUpper: data['carbsPlantUpper'] as String?,
        fiberRating: castToType<int>(data['fiberRating']),
        proteinRating: castToType<int>(data['proteinRating']),
        inThirdRule: data['inThirdRule'] as bool?,
        fiberValueReference: data['fiberValueReference'] as String?,
        carbsValueReference: data['carbsValueReference'] as String?,
        proteinValueReference: data['proteinValueReference'] as String?,
        fatValueReference: data['fatValueReference'] as String?,
      );

  static NutrientBoundDataTypeStruct? maybeFromMap(dynamic data) => data is Map
      ? NutrientBoundDataTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'fiberLower': _fiberLower,
        'fiberActual': _fiberActual,
        'fiberUpper': _fiberUpper,
        'proteinLower': _proteinLower,
        'proteinActual': _proteinActual,
        'proteinUpper': _proteinUpper,
        'fatLower': _fatLower,
        'fatActual': _fatActual,
        'fatUpper': _fatUpper,
        'carbsLower': _carbsLower,
        'carbsActual': _carbsActual,
        'carbsUpper': _carbsUpper,
        'fiberPlantLower': _fiberPlantLower,
        'fiberPlantUpper': _fiberPlantUpper,
        'proteinPlantLower': _proteinPlantLower,
        'proteinPlantUpper': _proteinPlantUpper,
        'fatPlantLower': _fatPlantLower,
        'fatPlantUpper': _fatPlantUpper,
        'carbsPlantLower': _carbsPlantLower,
        'carbsPlantUpper': _carbsPlantUpper,
        'fiberRating': _fiberRating,
        'proteinRating': _proteinRating,
        'inThirdRule': _inThirdRule,
        'fiberValueReference': _fiberValueReference,
        'carbsValueReference': _carbsValueReference,
        'proteinValueReference': _proteinValueReference,
        'fatValueReference': _fatValueReference,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'fiberLower': serializeParam(
          _fiberLower,
          ParamType.double,
        ),
        'fiberActual': serializeParam(
          _fiberActual,
          ParamType.double,
        ),
        'fiberUpper': serializeParam(
          _fiberUpper,
          ParamType.double,
        ),
        'proteinLower': serializeParam(
          _proteinLower,
          ParamType.double,
        ),
        'proteinActual': serializeParam(
          _proteinActual,
          ParamType.double,
        ),
        'proteinUpper': serializeParam(
          _proteinUpper,
          ParamType.double,
        ),
        'fatLower': serializeParam(
          _fatLower,
          ParamType.double,
        ),
        'fatActual': serializeParam(
          _fatActual,
          ParamType.double,
        ),
        'fatUpper': serializeParam(
          _fatUpper,
          ParamType.double,
        ),
        'carbsLower': serializeParam(
          _carbsLower,
          ParamType.double,
        ),
        'carbsActual': serializeParam(
          _carbsActual,
          ParamType.double,
        ),
        'carbsUpper': serializeParam(
          _carbsUpper,
          ParamType.double,
        ),
        'fiberPlantLower': serializeParam(
          _fiberPlantLower,
          ParamType.String,
        ),
        'fiberPlantUpper': serializeParam(
          _fiberPlantUpper,
          ParamType.String,
        ),
        'proteinPlantLower': serializeParam(
          _proteinPlantLower,
          ParamType.String,
        ),
        'proteinPlantUpper': serializeParam(
          _proteinPlantUpper,
          ParamType.String,
        ),
        'fatPlantLower': serializeParam(
          _fatPlantLower,
          ParamType.String,
        ),
        'fatPlantUpper': serializeParam(
          _fatPlantUpper,
          ParamType.String,
        ),
        'carbsPlantLower': serializeParam(
          _carbsPlantLower,
          ParamType.String,
        ),
        'carbsPlantUpper': serializeParam(
          _carbsPlantUpper,
          ParamType.String,
        ),
        'fiberRating': serializeParam(
          _fiberRating,
          ParamType.int,
        ),
        'proteinRating': serializeParam(
          _proteinRating,
          ParamType.int,
        ),
        'inThirdRule': serializeParam(
          _inThirdRule,
          ParamType.bool,
        ),
        'fiberValueReference': serializeParam(
          _fiberValueReference,
          ParamType.String,
        ),
        'carbsValueReference': serializeParam(
          _carbsValueReference,
          ParamType.String,
        ),
        'proteinValueReference': serializeParam(
          _proteinValueReference,
          ParamType.String,
        ),
        'fatValueReference': serializeParam(
          _fatValueReference,
          ParamType.String,
        ),
      }.withoutNulls;

  static NutrientBoundDataTypeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      NutrientBoundDataTypeStruct(
        fiberLower: deserializeParam(
          data['fiberLower'],
          ParamType.double,
          false,
        ),
        fiberActual: deserializeParam(
          data['fiberActual'],
          ParamType.double,
          false,
        ),
        fiberUpper: deserializeParam(
          data['fiberUpper'],
          ParamType.double,
          false,
        ),
        proteinLower: deserializeParam(
          data['proteinLower'],
          ParamType.double,
          false,
        ),
        proteinActual: deserializeParam(
          data['proteinActual'],
          ParamType.double,
          false,
        ),
        proteinUpper: deserializeParam(
          data['proteinUpper'],
          ParamType.double,
          false,
        ),
        fatLower: deserializeParam(
          data['fatLower'],
          ParamType.double,
          false,
        ),
        fatActual: deserializeParam(
          data['fatActual'],
          ParamType.double,
          false,
        ),
        fatUpper: deserializeParam(
          data['fatUpper'],
          ParamType.double,
          false,
        ),
        carbsLower: deserializeParam(
          data['carbsLower'],
          ParamType.double,
          false,
        ),
        carbsActual: deserializeParam(
          data['carbsActual'],
          ParamType.double,
          false,
        ),
        carbsUpper: deserializeParam(
          data['carbsUpper'],
          ParamType.double,
          false,
        ),
        fiberPlantLower: deserializeParam(
          data['fiberPlantLower'],
          ParamType.String,
          false,
        ),
        fiberPlantUpper: deserializeParam(
          data['fiberPlantUpper'],
          ParamType.String,
          false,
        ),
        proteinPlantLower: deserializeParam(
          data['proteinPlantLower'],
          ParamType.String,
          false,
        ),
        proteinPlantUpper: deserializeParam(
          data['proteinPlantUpper'],
          ParamType.String,
          false,
        ),
        fatPlantLower: deserializeParam(
          data['fatPlantLower'],
          ParamType.String,
          false,
        ),
        fatPlantUpper: deserializeParam(
          data['fatPlantUpper'],
          ParamType.String,
          false,
        ),
        carbsPlantLower: deserializeParam(
          data['carbsPlantLower'],
          ParamType.String,
          false,
        ),
        carbsPlantUpper: deserializeParam(
          data['carbsPlantUpper'],
          ParamType.String,
          false,
        ),
        fiberRating: deserializeParam(
          data['fiberRating'],
          ParamType.int,
          false,
        ),
        proteinRating: deserializeParam(
          data['proteinRating'],
          ParamType.int,
          false,
        ),
        inThirdRule: deserializeParam(
          data['inThirdRule'],
          ParamType.bool,
          false,
        ),
        fiberValueReference: deserializeParam(
          data['fiberValueReference'],
          ParamType.String,
          false,
        ),
        carbsValueReference: deserializeParam(
          data['carbsValueReference'],
          ParamType.String,
          false,
        ),
        proteinValueReference: deserializeParam(
          data['proteinValueReference'],
          ParamType.String,
          false,
        ),
        fatValueReference: deserializeParam(
          data['fatValueReference'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'NutrientBoundDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NutrientBoundDataTypeStruct &&
        fiberLower == other.fiberLower &&
        fiberActual == other.fiberActual &&
        fiberUpper == other.fiberUpper &&
        proteinLower == other.proteinLower &&
        proteinActual == other.proteinActual &&
        proteinUpper == other.proteinUpper &&
        fatLower == other.fatLower &&
        fatActual == other.fatActual &&
        fatUpper == other.fatUpper &&
        carbsLower == other.carbsLower &&
        carbsActual == other.carbsActual &&
        carbsUpper == other.carbsUpper &&
        fiberPlantLower == other.fiberPlantLower &&
        fiberPlantUpper == other.fiberPlantUpper &&
        proteinPlantLower == other.proteinPlantLower &&
        proteinPlantUpper == other.proteinPlantUpper &&
        fatPlantLower == other.fatPlantLower &&
        fatPlantUpper == other.fatPlantUpper &&
        carbsPlantLower == other.carbsPlantLower &&
        carbsPlantUpper == other.carbsPlantUpper &&
        fiberRating == other.fiberRating &&
        proteinRating == other.proteinRating &&
        inThirdRule == other.inThirdRule &&
        fiberValueReference == other.fiberValueReference &&
        carbsValueReference == other.carbsValueReference &&
        proteinValueReference == other.proteinValueReference &&
        fatValueReference == other.fatValueReference;
  }

  @override
  int get hashCode => const ListEquality().hash([
        fiberLower,
        fiberActual,
        fiberUpper,
        proteinLower,
        proteinActual,
        proteinUpper,
        fatLower,
        fatActual,
        fatUpper,
        carbsLower,
        carbsActual,
        carbsUpper,
        fiberPlantLower,
        fiberPlantUpper,
        proteinPlantLower,
        proteinPlantUpper,
        fatPlantLower,
        fatPlantUpper,
        carbsPlantLower,
        carbsPlantUpper,
        fiberRating,
        proteinRating,
        inThirdRule,
        fiberValueReference,
        carbsValueReference,
        proteinValueReference,
        fatValueReference
      ]);
}

NutrientBoundDataTypeStruct createNutrientBoundDataTypeStruct({
  double? fiberLower,
  double? fiberActual,
  double? fiberUpper,
  double? proteinLower,
  double? proteinActual,
  double? proteinUpper,
  double? fatLower,
  double? fatActual,
  double? fatUpper,
  double? carbsLower,
  double? carbsActual,
  double? carbsUpper,
  String? fiberPlantLower,
  String? fiberPlantUpper,
  String? proteinPlantLower,
  String? proteinPlantUpper,
  String? fatPlantLower,
  String? fatPlantUpper,
  String? carbsPlantLower,
  String? carbsPlantUpper,
  int? fiberRating,
  int? proteinRating,
  bool? inThirdRule,
  String? fiberValueReference,
  String? carbsValueReference,
  String? proteinValueReference,
  String? fatValueReference,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    NutrientBoundDataTypeStruct(
      fiberLower: fiberLower,
      fiberActual: fiberActual,
      fiberUpper: fiberUpper,
      proteinLower: proteinLower,
      proteinActual: proteinActual,
      proteinUpper: proteinUpper,
      fatLower: fatLower,
      fatActual: fatActual,
      fatUpper: fatUpper,
      carbsLower: carbsLower,
      carbsActual: carbsActual,
      carbsUpper: carbsUpper,
      fiberPlantLower: fiberPlantLower,
      fiberPlantUpper: fiberPlantUpper,
      proteinPlantLower: proteinPlantLower,
      proteinPlantUpper: proteinPlantUpper,
      fatPlantLower: fatPlantLower,
      fatPlantUpper: fatPlantUpper,
      carbsPlantLower: carbsPlantLower,
      carbsPlantUpper: carbsPlantUpper,
      fiberRating: fiberRating,
      proteinRating: proteinRating,
      inThirdRule: inThirdRule,
      fiberValueReference: fiberValueReference,
      carbsValueReference: carbsValueReference,
      proteinValueReference: proteinValueReference,
      fatValueReference: fatValueReference,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

NutrientBoundDataTypeStruct? updateNutrientBoundDataTypeStruct(
  NutrientBoundDataTypeStruct? nutrientBoundDataType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    nutrientBoundDataType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addNutrientBoundDataTypeStructData(
  Map<String, dynamic> firestoreData,
  NutrientBoundDataTypeStruct? nutrientBoundDataType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (nutrientBoundDataType == null) {
    return;
  }
  if (nutrientBoundDataType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      nutrientBoundDataType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final nutrientBoundDataTypeData = getNutrientBoundDataTypeFirestoreData(
      nutrientBoundDataType, forFieldValue);
  final nestedData =
      nutrientBoundDataTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      nutrientBoundDataType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getNutrientBoundDataTypeFirestoreData(
  NutrientBoundDataTypeStruct? nutrientBoundDataType, [
  bool forFieldValue = false,
]) {
  if (nutrientBoundDataType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(nutrientBoundDataType.toMap());

  // Add any Firestore field values
  nutrientBoundDataType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getNutrientBoundDataTypeListFirestoreData(
  List<NutrientBoundDataTypeStruct>? nutrientBoundDataTypes,
) =>
    nutrientBoundDataTypes
        ?.map((e) => getNutrientBoundDataTypeFirestoreData(e, true))
        .toList() ??
    [];
