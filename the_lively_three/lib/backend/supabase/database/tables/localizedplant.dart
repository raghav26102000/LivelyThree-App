import '../database.dart';

class LocalizedplantTable extends SupabaseTable<LocalizedplantRow> {
  @override
  String get tableName => 'localizedfooditem';

  @override
  LocalizedplantRow createRow(Map<String, dynamic> data) =>
      LocalizedplantRow(data);
}

class LocalizedplantRow extends SupabaseDataRow {
  LocalizedplantRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LocalizedplantTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  int? get idBlueprint => getField<int>('id_blueprint');
  set idBlueprint(int? value) => setField<int>('id_blueprint', value);

  int? get idClimate => getField<int>('id_climate');
  set idClimate(int? value) => setField<int>('id_climate', value);

  int? get idAgro => getField<int>('id_agro');
  set idAgro(int? value) => setField<int>('id_agro', value);

  int? get idOrigin => getField<int>('id_origin');
  set idOrigin(int? value) => setField<int>('id_origin', value);

  int? get idUserregion => getField<int>('id_userregion');
  set idUserregion(int? value) => setField<int>('id_userregion', value);
}
