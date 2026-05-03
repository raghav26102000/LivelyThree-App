import '../database.dart';

class UserregionTable extends SupabaseTable<UserregionRow> {
  @override
  String get tableName => 'userregion';

  @override
  UserregionRow createRow(Map<String, dynamic> data) => UserregionRow(data);
}

class UserregionRow extends SupabaseDataRow {
  UserregionRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserregionTable();

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
