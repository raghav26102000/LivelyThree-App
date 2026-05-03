import '../database.dart';

class PlantoriginTable extends SupabaseTable<PlantoriginRow> {
  @override
  String get tableName => 'plantorigin';

  @override
  PlantoriginRow createRow(Map<String, dynamic> data) => PlantoriginRow(data);
}

class PlantoriginRow extends SupabaseDataRow {
  PlantoriginRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlantoriginTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get region => getField<String>('region');
  set region(String? value) => setField<String>('region', value);

  int get population => getField<int>('population')!;
  set population(int value) => setField<int>('population', value);

  String? get area => getField<String>('area');
  set area(String? value) => setField<String>('area', value);
}
