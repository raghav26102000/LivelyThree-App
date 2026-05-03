import '../database.dart';

class UserindicatorvaluesTable extends SupabaseTable<UserindicatorvaluesRow> {
  @override
  String get tableName => 'userindicatorvalues';

  @override
  UserindicatorvaluesRow createRow(Map<String, dynamic> data) =>
      UserindicatorvaluesRow(data);
}

class UserindicatorvaluesRow extends SupabaseDataRow {
  UserindicatorvaluesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserindicatorvaluesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get idIndicator => getField<int>('id_indicator');
  set idIndicator(int? value) => setField<int>('id_indicator', value);

  double? get value => getField<double>('value');
  set value(double? value) => setField<double>('value', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get idUser => getField<String>('id_user');
  set idUser(String? value) => setField<String>('id_user', value);

  int? get calendarweek => getField<int>('calendarweek');
  set calendarweek(int? value) => setField<int>('calendarweek', value);

  int? get month => getField<int>('month');
  set month(int? value) => setField<int>('month', value);

  int? get calendaryear => getField<int>('calendaryear');
  set calendaryear(int? value) => setField<int>('calendaryear', value);

  dynamic? get jsonbValue => getField<dynamic>('jsonb_value');
  set jsonbValue(dynamic? value) => setField<dynamic>('jsonb_value', value);
}
