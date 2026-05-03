import '../database.dart';

class UserVitalsTable extends SupabaseTable<UserVitalsRow> {
  @override
  String get tableName => 'user_vitals';

  @override
  UserVitalsRow createRow(Map<String, dynamic> data) => UserVitalsRow(data);
}

class UserVitalsRow extends SupabaseDataRow {
  UserVitalsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserVitalsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get vitalType => getField<String>('vital_type');
  set vitalType(String? value) => setField<String>('vital_type', value);

  double? get value => getField<double>('value');
  set value(double? value) => setField<double>('value', value);

  String? get unit => getField<String>('unit');
  set unit(String? value) => setField<String>('unit', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get currentday => getField<String>('currentday');
  set currentday(String? value) => setField<String>('currentday', value);

  int? get calendarweek => getField<int>('calendarweek');
  set calendarweek(int? value) => setField<int>('calendarweek', value);

  int? get calendaryear => getField<int>('calendaryear');
  set calendaryear(int? value) => setField<int>('calendaryear', value);
}
