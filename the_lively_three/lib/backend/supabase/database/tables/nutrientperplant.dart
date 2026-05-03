import '../database.dart';

class NutrientperplantTable extends SupabaseTable<NutrientperplantRow> {
  @override
  String get tableName => 'nutrientperplant';

  @override
  NutrientperplantRow createRow(Map<String, dynamic> data) =>
      NutrientperplantRow(data);
}

class NutrientperplantRow extends SupabaseDataRow {
  NutrientperplantRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NutrientperplantTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int get idPlant => getField<int>('id_plant')!;
  set idPlant(int value) => setField<int>('id_plant', value);

  int get idNutrient => getField<int>('id_nutrient')!;
  set idNutrient(int value) => setField<int>('id_nutrient', value);

  double? get value => getField<double>('value');
  set value(double? value) => setField<double>('value', value);

  String? get referenceField => getField<String>('reference');
  set referenceField(String? value) => setField<String>('reference', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);
}
