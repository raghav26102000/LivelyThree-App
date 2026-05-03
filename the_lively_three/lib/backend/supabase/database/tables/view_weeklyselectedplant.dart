import '../database.dart';

class ViewWeeklyselectedplantTable
    extends SupabaseTable<ViewWeeklyselectedplantRow> {
  @override
  String get tableName => 'view_weeklyselectedplant';

  @override
  ViewWeeklyselectedplantRow createRow(Map<String, dynamic> data) =>
      ViewWeeklyselectedplantRow(data);
}

class ViewWeeklyselectedplantRow extends SupabaseDataRow {
  ViewWeeklyselectedplantRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewWeeklyselectedplantTable();

  int? get idLoc => getField<int>('id_loc');
  set idLoc(int? value) => setField<int>('id_loc', value);

  String? get idUser => getField<String>('id_user');
  set idUser(String? value) => setField<String>('id_user', value);

  String? get plantname => getField<String>('plantname');
  set plantname(String? value) => setField<String>('plantname', value);

  String? get color => getField<String>('color');
  set color(String? value) => setField<String>('color', value);

  int? get calendaryear => getField<int>('calendaryear');
  set calendaryear(int? value) => setField<int>('calendaryear', value);

  int? get calendarweek => getField<int>('calendarweek');
  set calendarweek(int? value) => setField<int>('calendarweek', value);

  double? get portionsum => getField<double>('portionsum');
  set portionsum(double? value) => setField<double>('portionsum', value);

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

  double? get portionsize => getField<double>('portionsize');
  set portionsize(double? value) => setField<double>('portionsize', value);

  bool? get in3rdrule => getField<bool>('in3rdrule');
  set in3rdrule(bool? value) => setField<bool>('in3rdrule', value);
}
