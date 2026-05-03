import '../database.dart';

class BlueprintplantTable extends SupabaseTable<BlueprintplantRow> {
  @override
  String get tableName => 'blueprintfooditem';

  @override
  BlueprintplantRow createRow(Map<String, dynamic> data) =>
      BlueprintplantRow(data);
}

class BlueprintplantRow extends SupabaseDataRow {
  BlueprintplantRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BlueprintplantTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get priority => getField<String>('priority');
  set priority(String? value) => setField<String>('priority', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get species => getField<String>('species');
  set species(String? value) => setField<String>('species', value);

  String? get color => getField<String>('color');
  set color(String? value) => setField<String>('color', value);

  int? get kcal => getField<int>('kcal');
  set kcal(int? value) => setField<int>('kcal', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  double? get portionsize => getField<double>('portionsize');
  set portionsize(double? value) => setField<double>('portionsize', value);

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
