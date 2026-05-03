import '../database.dart';

class WeeklyselectedplantTable extends SupabaseTable<WeeklyselectedplantRow> {
  @override
  String get tableName => 'weeklyselectedplant';

  @override
  WeeklyselectedplantRow createRow(Map<String, dynamic> data) =>
      WeeklyselectedplantRow(data);
}

class WeeklyselectedplantRow extends SupabaseDataRow {
  WeeklyselectedplantRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => WeeklyselectedplantTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get idLoc => getField<int>('id_loc');
  set idLoc(int? value) => setField<int>('id_loc', value);

  int? get week => getField<int>('week');
  set week(int? value) => setField<int>('week', value);

  String? get idUser => getField<String>('id_user');
  set idUser(String? value) => setField<String>('id_user', value);

  double? get portionsum => getField<double>('portionsum');
  set portionsum(double? value) => setField<double>('portionsum', value);

  String? get color => getField<String>('color');
  set color(String? value) => setField<String>('color', value);

  String? get plantname => getField<String>('plantname');
  set plantname(String? value) => setField<String>('plantname', value);

  double? get monportion => getField<double>('monportion');
  set monportion(double? value) => setField<double>('monportion', value);

  double? get tueportion => getField<double>('tueportion');
  set tueportion(double? value) => setField<double>('tueportion', value);

  double? get wedportion => getField<double>('wedportion');
  set wedportion(double? value) => setField<double>('wedportion', value);

  double? get thuportion => getField<double>('thuportion');
  set thuportion(double? value) => setField<double>('thuportion', value);

  double? get friportion => getField<double>('friportion');
  set friportion(double? value) => setField<double>('friportion', value);

  double? get satportion => getField<double>('satportion');
  set satportion(double? value) => setField<double>('satportion', value);

  double? get sunportion => getField<double>('sunportion');
  set sunportion(double? value) => setField<double>('sunportion', value);

  int? get year => getField<int>('year');
  set year(int? value) => setField<int>('year', value);

  double? get portionsize => getField<double>('portionsize');
  set portionsize(double? value) => setField<double>('portionsize', value);

  bool? get portionsizeLocked => getField<bool>('portionsize_locked');
  set portionsizeLocked(bool? value) =>
      setField<bool>('portionsize_locked', value);
}
