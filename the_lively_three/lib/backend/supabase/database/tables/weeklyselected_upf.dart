import '../database.dart';

class WeeklyselectedUpfTable extends SupabaseTable<WeeklyselectedUpfRow> {
  @override
  String get tableName => 'weeklyselected_upf';

  @override
  WeeklyselectedUpfRow createRow(Map<String, dynamic> data) =>
      WeeklyselectedUpfRow(data);
}

class WeeklyselectedUpfRow extends SupabaseDataRow {
  WeeklyselectedUpfRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => WeeklyselectedUpfTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get calendarweek => getField<int>('calendarweek');
  set calendarweek(int? value) => setField<int>('calendarweek', value);

  String? get idUser => getField<String>('id_user');
  set idUser(String? value) => setField<String>('id_user', value);

  int? get portionsum => getField<int>('portionsum');
  set portionsum(int? value) => setField<int>('portionsum', value);

  int? get monportion => getField<int>('monportion');
  set monportion(int? value) => setField<int>('monportion', value);

  int? get tueportion => getField<int>('tueportion');
  set tueportion(int? value) => setField<int>('tueportion', value);

  int? get wedportion => getField<int>('wedportion');
  set wedportion(int? value) => setField<int>('wedportion', value);

  int? get thuportion => getField<int>('thuportion');
  set thuportion(int? value) => setField<int>('thuportion', value);

  int? get friportion => getField<int>('friportion');
  set friportion(int? value) => setField<int>('friportion', value);

  int? get satportion => getField<int>('satportion');
  set satportion(int? value) => setField<int>('satportion', value);

  int? get sunportion => getField<int>('sunportion');
  set sunportion(int? value) => setField<int>('sunportion', value);

  int? get calendaryear => getField<int>('calendaryear');
  set calendaryear(int? value) => setField<int>('calendaryear', value);
}
