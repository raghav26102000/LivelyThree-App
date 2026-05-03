import '../database.dart';

class ViewLocPlantDetailsTable extends SupabaseTable<ViewLocPlantDetailsRow> {
  @override
  String get tableName => 'view_loc_plant_details';

  @override
  ViewLocPlantDetailsRow createRow(Map<String, dynamic> data) =>
      ViewLocPlantDetailsRow(data);
}

class ViewLocPlantDetailsRow extends SupabaseDataRow {
  ViewLocPlantDetailsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewLocPlantDetailsTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String? get plantname => getField<String>('plantname');
  set plantname(String? value) => setField<String>('plantname', value);

  String? get climatecond => getField<String>('climatecond');
  set climatecond(String? value) => setField<String>('climatecond', value);

  String? get agrimethod => getField<String>('agrimethod');
  set agrimethod(String? value) => setField<String>('agrimethod', value);

  String? get origincountry => getField<String>('origincountry');
  set origincountry(String? value) => setField<String>('origincountry', value);

  String? get usercountry => getField<String>('usercountry');
  set usercountry(String? value) => setField<String>('usercountry', value);

  String? get color => getField<String>('color');
  set color(String? value) => setField<String>('color', value);

  double? get portionsize => getField<double>('portionsize');
  set portionsize(double? value) => setField<double>('portionsize', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  bool? get inthirdrule => getField<bool>('inthirdrule');
  set inthirdrule(bool? value) => setField<bool>('inthirdrule', value);

  bool? get oneLchfnpShort => getField<bool>('one_lchfnp_short');
  set oneLchfnpShort(bool? value) => setField<bool>('one_lchfnp_short', value);

  bool? get oneLchfnpLong => getField<bool>('one_lchfnp_long');
  set oneLchfnpLong(bool? value) => setField<bool>('one_lchfnp_long', value);

  bool? get twoLchfhpShort => getField<bool>('two_lchfhp_short');
  set twoLchfhpShort(bool? value) => setField<bool>('two_lchfhp_short', value);

  bool? get twoLchfhpLong => getField<bool>('two_lchfhp_long');
  set twoLchfhpLong(bool? value) => setField<bool>('two_lchfhp_long', value);

  bool? get threeNcnfnpShort => getField<bool>('three_ncnfnp_short');
  set threeNcnfnpShort(bool? value) =>
      setField<bool>('three_ncnfnp_short', value);

  bool? get threeNcnfnpLong => getField<bool>('three_ncnfnp_long');
  set threeNcnfnpLong(bool? value) =>
      setField<bool>('three_ncnfnp_long', value);

  bool? get fourNcnfhpShort => getField<bool>('four_ncnfhp_short');
  set fourNcnfhpShort(bool? value) =>
      setField<bool>('four_ncnfhp_short', value);

  bool? get fourNcnfhpLong => getField<bool>('four_ncnfhp_long');
  set fourNcnfhpLong(bool? value) => setField<bool>('four_ncnfhp_long', value);

  bool? get fiveNchfnpShort => getField<bool>('five_nchfnp_short');
  set fiveNchfnpShort(bool? value) =>
      setField<bool>('five_nchfnp_short', value);

  bool? get fiveNchfnpLong => getField<bool>('five_nchfnp_long');
  set fiveNchfnpLong(bool? value) => setField<bool>('five_nchfnp_long', value);

  bool? get sixNchfhpShort => getField<bool>('six_nchfhp_short');
  set sixNchfhpShort(bool? value) => setField<bool>('six_nchfhp_short', value);

  bool? get sixNchfhpLong => getField<bool>('six_nchfhp_long');
  set sixNchfhpLong(bool? value) => setField<bool>('six_nchfhp_long', value);
}
