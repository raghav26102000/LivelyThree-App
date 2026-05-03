import '../database.dart';

class ViewNutrientperplantTable extends SupabaseTable<ViewNutrientperplantRow> {
  @override
  String get tableName => 'view_nutrientperplant';

  @override
  ViewNutrientperplantRow createRow(Map<String, dynamic> data) =>
      ViewNutrientperplantRow(data);
}

class ViewNutrientperplantRow extends SupabaseDataRow {
  ViewNutrientperplantRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewNutrientperplantTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  int? get idPlant => getField<int>('id_plant');
  set idPlant(int? value) => setField<int>('id_plant', value);

  int? get idNutrient => getField<int>('id_nutrient');
  set idNutrient(int? value) => setField<int>('id_nutrient', value);

  String? get plantname => getField<String>('plantname');
  set plantname(String? value) => setField<String>('plantname', value);

  String? get nutrientname => getField<String>('nutrientname');
  set nutrientname(String? value) => setField<String>('nutrientname', value);

  double? get nutrientvalue => getField<double>('nutrientvalue');
  set nutrientvalue(double? value) => setField<double>('nutrientvalue', value);

  String? get referenceField => getField<String>('reference');
  set referenceField(String? value) => setField<String>('reference', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get color => getField<String>('color');
  set color(String? value) => setField<String>('color', value);
}
