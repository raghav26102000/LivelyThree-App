import '../database.dart';

class WeeklyselectedPhysicalpanelTable
    extends SupabaseTable<WeeklyselectedPhysicalpanelRow> {
  @override
  String get tableName => 'weeklyselected_physicalpanel';

  @override
  WeeklyselectedPhysicalpanelRow createRow(Map<String, dynamic> data) =>
      WeeklyselectedPhysicalpanelRow(data);
}

class WeeklyselectedPhysicalpanelRow extends SupabaseDataRow {
  WeeklyselectedPhysicalpanelRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => WeeklyselectedPhysicalpanelTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get weekday => getField<int>('weekday');
  set weekday(int? value) => setField<int>('weekday', value);

  int? get calendarweek => getField<int>('calendarweek');
  set calendarweek(int? value) => setField<int>('calendarweek', value);

  int? get calendaryear => getField<int>('calendaryear');
  set calendaryear(int? value) => setField<int>('calendaryear', value);

  String? get idUser => getField<String>('id_user');
  set idUser(String? value) => setField<String>('id_user', value);

  dynamic? get period1 => getField<dynamic>('period_1');
  set period1(dynamic? value) => setField<dynamic>('period_1', value);

  dynamic? get period2 => getField<dynamic>('period_2');
  set period2(dynamic? value) => setField<dynamic>('period_2', value);

  dynamic? get period3 => getField<dynamic>('period_3');
  set period3(dynamic? value) => setField<dynamic>('period_3', value);

  dynamic? get period4 => getField<dynamic>('period_4');
  set period4(dynamic? value) => setField<dynamic>('period_4', value);

  dynamic? get period5 => getField<dynamic>('period_5');
  set period5(dynamic? value) => setField<dynamic>('period_5', value);

  dynamic? get period6 => getField<dynamic>('period_6');
  set period6(dynamic? value) => setField<dynamic>('period_6', value);

  dynamic? get period7 => getField<dynamic>('period_7');
  set period7(dynamic? value) => setField<dynamic>('period_7', value);

  dynamic? get period8 => getField<dynamic>('period_8');
  set period8(dynamic? value) => setField<dynamic>('period_8', value);

  dynamic? get period9 => getField<dynamic>('period_9');
  set period9(dynamic? value) => setField<dynamic>('period_9', value);

  dynamic? get period10 => getField<dynamic>('period_10');
  set period10(dynamic? value) => setField<dynamic>('period_10', value);

  dynamic? get period11 => getField<dynamic>('period_11');
  set period11(dynamic? value) => setField<dynamic>('period_11', value);

  dynamic? get period12 => getField<dynamic>('period_12');
  set period12(dynamic? value) => setField<dynamic>('period_12', value);
}
