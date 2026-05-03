import '../database.dart';

class DailyuserConsumptionTable
    extends SupabaseTable<DailyuserConsumptionRow> {
  @override
  String get tableName => 'dailyuserconsumption';

  @override
  DailyuserConsumptionRow createRow(Map<String, dynamic> data) =>
      DailyuserConsumptionRow(data);
}

class DailyuserConsumptionRow extends SupabaseDataRow {
  DailyuserConsumptionRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DailyuserConsumptionTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get plantId => getField<int>('plant_id')!;
  set plantId(int value) => setField<int>('plant_id', value);

  double get portionSize => getField<double>('portion_size')!;
  set portionSize(double value) =>
      setField<double>('portion_size', value);

  int get quantity => getField<int>('quantity')!;
  set quantity(int value) => setField<int>('quantity', value);

  int get calendarWeek => getField<int>('calender_week')!;
  set calendarWeek(int value) =>
      setField<int>('calender_week', value);

  int get calendarYear => getField<int>('calender_year')!;
  set calendarYear(int value) =>
      setField<int>('calender_year', value);

  DateTime get consumptionon => getField<DateTime>('consumptionon')!;
  set consumptionon(DateTime value) =>
      setField<DateTime>('consumptionon', value);

  DateTime get createdOn => getField<DateTime>('createdOn')!;
  set createdOn(DateTime value) =>
      setField<DateTime>('createdOn', value);

  String get createdby => getField<String>('createdby')!;
  set createdby(String value) => setField<String>('createdby', value);
}
