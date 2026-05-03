// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LocPlantSelectionListSchemaStruct extends FFFirebaseStruct {
  LocPlantSelectionListSchemaStruct({
    int? idLoc,
    String? plantname,
    String? climatecondition,
    String? agrimethod,
    String? origincountry,
    String? usercountry,
    String? color,
    bool? presetBool,
    bool? selected,
    double? portionsum,
    double? portionsize,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _idLoc = idLoc,
        _plantname = plantname,
        _climatecondition = climatecondition,
        _agrimethod = agrimethod,
        _origincountry = origincountry,
        _usercountry = usercountry,
        _color = color,
        _presetBool = presetBool,
        _selected = selected,
        _portionsum = portionsum,
        _portionsize = portionsize,
        super(firestoreUtilData);

  // "id_loc" field.
  int? _idLoc;
  int get idLoc => _idLoc ?? 0;
  set idLoc(int? val) => _idLoc = val;

  void incrementIdLoc(int amount) => idLoc = idLoc + amount;

  bool hasIdLoc() => _idLoc != null;

  // "plantname" field.
  String? _plantname;
  String get plantname => _plantname ?? '';
  set plantname(String? val) => _plantname = val;

  bool hasPlantname() => _plantname != null;

  // "climatecondition" field.
  String? _climatecondition;
  String get climatecondition => _climatecondition ?? '';
  set climatecondition(String? val) => _climatecondition = val;

  bool hasClimatecondition() => _climatecondition != null;

  // "agrimethod" field.
  String? _agrimethod;
  String get agrimethod => _agrimethod ?? '';
  set agrimethod(String? val) => _agrimethod = val;

  bool hasAgrimethod() => _agrimethod != null;

  // "origincountry" field.
  String? _origincountry;
  String get origincountry => _origincountry ?? '';
  set origincountry(String? val) => _origincountry = val;

  bool hasOrigincountry() => _origincountry != null;

  // "usercountry" field.
  String? _usercountry;
  String get usercountry => _usercountry ?? '';
  set usercountry(String? val) => _usercountry = val;

  bool hasUsercountry() => _usercountry != null;

  // "color" field.
  String? _color;
  String get color => _color ?? '';
  set color(String? val) => _color = val;

  bool hasColor() => _color != null;

  // "preset_bool" field.
  bool? _presetBool;
  bool get presetBool => _presetBool ?? false;
  set presetBool(bool? val) => _presetBool = val;

  bool hasPresetBool() => _presetBool != null;

  // "selected" field.
  bool? _selected;
  bool get selected => _selected ?? false;
  set selected(bool? val) => _selected = val;

  bool hasSelected() => _selected != null;

  // "portionsum" field.
  double? _portionsum;
  double get portionsum => _portionsum ?? 0.0;
  set portionsum(double? val) => _portionsum = val;

  void incrementPortionsum(double amount) => portionsum = portionsum + amount;

  bool hasPortionsum() => _portionsum != null;

  // "portionsize" field.
  double? _portionsize;
  double get portionsize => _portionsize ?? 0.0;
  set portionsize(double? val) => _portionsize = val;

  void incrementPortionsize(double amount) =>
      portionsize = portionsize + amount;

  bool hasPortionsize() => _portionsize != null;

  static LocPlantSelectionListSchemaStruct fromMap(Map<String, dynamic> data) =>
      LocPlantSelectionListSchemaStruct(
        idLoc: castToType<int>(data['id_loc']),
        plantname: data['plantname'] as String?,
        climatecondition: data['climatecondition'] as String?,
        agrimethod: data['agrimethod'] as String?,
        origincountry: data['origincountry'] as String?,
        usercountry: data['usercountry'] as String?,
        color: data['color'] as String?,
        presetBool: data['preset_bool'] as bool?,
        selected: data['selected'] as bool?,
        portionsum: castToType<double>(data['portionsum']),
        portionsize: castToType<double>(data['portionsize']),
      );

  static LocPlantSelectionListSchemaStruct? maybeFromMap(dynamic data) => data
          is Map
      ? LocPlantSelectionListSchemaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id_loc': _idLoc,
        'plantname': _plantname,
        'climatecondition': _climatecondition,
        'agrimethod': _agrimethod,
        'origincountry': _origincountry,
        'usercountry': _usercountry,
        'color': _color,
        'preset_bool': _presetBool,
        'selected': _selected,
        'portionsum': _portionsum,
        'portionsize': _portionsize,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id_loc': serializeParam(
          _idLoc,
          ParamType.int,
        ),
        'plantname': serializeParam(
          _plantname,
          ParamType.String,
        ),
        'climatecondition': serializeParam(
          _climatecondition,
          ParamType.String,
        ),
        'agrimethod': serializeParam(
          _agrimethod,
          ParamType.String,
        ),
        'origincountry': serializeParam(
          _origincountry,
          ParamType.String,
        ),
        'usercountry': serializeParam(
          _usercountry,
          ParamType.String,
        ),
        'color': serializeParam(
          _color,
          ParamType.String,
        ),
        'preset_bool': serializeParam(
          _presetBool,
          ParamType.bool,
        ),
        'selected': serializeParam(
          _selected,
          ParamType.bool,
        ),
        'portionsum': serializeParam(
          _portionsum,
          ParamType.double,
        ),
        'portionsize': serializeParam(
          _portionsize,
          ParamType.double,
        ),
      }.withoutNulls;

  static LocPlantSelectionListSchemaStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      LocPlantSelectionListSchemaStruct(
        idLoc: deserializeParam(
          data['id_loc'],
          ParamType.int,
          false,
        ),
        plantname: deserializeParam(
          data['plantname'],
          ParamType.String,
          false,
        ),
        climatecondition: deserializeParam(
          data['climatecondition'],
          ParamType.String,
          false,
        ),
        agrimethod: deserializeParam(
          data['agrimethod'],
          ParamType.String,
          false,
        ),
        origincountry: deserializeParam(
          data['origincountry'],
          ParamType.String,
          false,
        ),
        usercountry: deserializeParam(
          data['usercountry'],
          ParamType.String,
          false,
        ),
        color: deserializeParam(
          data['color'],
          ParamType.String,
          false,
        ),
        presetBool: deserializeParam(
          data['preset_bool'],
          ParamType.bool,
          false,
        ),
        selected: deserializeParam(
          data['selected'],
          ParamType.bool,
          false,
        ),
        portionsum: deserializeParam(
          data['portionsum'],
          ParamType.double,
          false,
        ),
        portionsize: deserializeParam(
          data['portionsize'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'LocPlantSelectionListSchemaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LocPlantSelectionListSchemaStruct &&
        idLoc == other.idLoc &&
        plantname == other.plantname &&
        climatecondition == other.climatecondition &&
        agrimethod == other.agrimethod &&
        origincountry == other.origincountry &&
        usercountry == other.usercountry &&
        color == other.color &&
        presetBool == other.presetBool &&
        selected == other.selected &&
        portionsum == other.portionsum &&
        portionsize == other.portionsize;
  }

  @override
  int get hashCode => const ListEquality().hash([
        idLoc,
        plantname,
        climatecondition,
        agrimethod,
        origincountry,
        usercountry,
        color,
        presetBool,
        selected,
        portionsum,
        portionsize
      ]);
}

LocPlantSelectionListSchemaStruct createLocPlantSelectionListSchemaStruct({
  int? idLoc,
  String? plantname,
  String? climatecondition,
  String? agrimethod,
  String? origincountry,
  String? usercountry,
  String? color,
  bool? presetBool,
  bool? selected,
  double? portionsum,
  double? portionsize,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LocPlantSelectionListSchemaStruct(
      idLoc: idLoc,
      plantname: plantname,
      climatecondition: climatecondition,
      agrimethod: agrimethod,
      origincountry: origincountry,
      usercountry: usercountry,
      color: color,
      presetBool: presetBool,
      selected: selected,
      portionsum: portionsum,
      portionsize: portionsize,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

LocPlantSelectionListSchemaStruct? updateLocPlantSelectionListSchemaStruct(
  LocPlantSelectionListSchemaStruct? locPlantSelectionListSchema, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    locPlantSelectionListSchema
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addLocPlantSelectionListSchemaStructData(
  Map<String, dynamic> firestoreData,
  LocPlantSelectionListSchemaStruct? locPlantSelectionListSchema,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (locPlantSelectionListSchema == null) {
    return;
  }
  if (locPlantSelectionListSchema.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      locPlantSelectionListSchema.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final locPlantSelectionListSchemaData =
      getLocPlantSelectionListSchemaFirestoreData(
          locPlantSelectionListSchema, forFieldValue);
  final nestedData = locPlantSelectionListSchemaData
      .map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      locPlantSelectionListSchema.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getLocPlantSelectionListSchemaFirestoreData(
  LocPlantSelectionListSchemaStruct? locPlantSelectionListSchema, [
  bool forFieldValue = false,
]) {
  if (locPlantSelectionListSchema == null) {
    return {};
  }
  final firestoreData = mapToFirestore(locPlantSelectionListSchema.toMap());

  // Add any Firestore field values
  locPlantSelectionListSchema.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLocPlantSelectionListSchemaListFirestoreData(
  List<LocPlantSelectionListSchemaStruct>? locPlantSelectionListSchemas,
) =>
    locPlantSelectionListSchemas
        ?.map((e) => getLocPlantSelectionListSchemaFirestoreData(e, true))
        .toList() ??
    [];
