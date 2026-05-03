import '../database.dart';

class BlueprintplantStagingTable
    extends SupabaseTable<BlueprintplantStagingRow> {
  @override
  String get tableName => 'blueprintplant_staging';

  @override
  BlueprintplantStagingRow createRow(Map<String, dynamic> data) =>
      BlueprintplantStagingRow(data);
}

class BlueprintplantStagingRow extends SupabaseDataRow {
  BlueprintplantStagingRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BlueprintplantStagingTable();

  String? get oneLchfnpShort => getField<String>('one_lchfnp_short');
  set oneLchfnpShort(String? value) =>
      setField<String>('one_lchfnp_short', value);

  String? get oneLchfnpLong => getField<String>('one_lchfnp_long');
  set oneLchfnpLong(String? value) =>
      setField<String>('one_lchfnp_long', value);

  String? get twoLchfhpShort => getField<String>('two_lchfhp_short');
  set twoLchfhpShort(String? value) =>
      setField<String>('two_lchfhp_short', value);

  String? get twoLchfhpLong => getField<String>('two_lchfhp_long');
  set twoLchfhpLong(String? value) =>
      setField<String>('two_lchfhp_long', value);

  String? get threeNcnfnpShort => getField<String>('three_ncnfnp_short');
  set threeNcnfnpShort(String? value) =>
      setField<String>('three_ncnfnp_short', value);

  String? get threeNcnfnpLong => getField<String>('three_ncnfnp_long');
  set threeNcnfnpLong(String? value) =>
      setField<String>('three_ncnfnp_long', value);

  String? get fourNcnfhpShort => getField<String>('four_ncnfhp_short');
  set fourNcnfhpShort(String? value) =>
      setField<String>('four_ncnfhp_short', value);

  String? get fourNcnfhpLong => getField<String>('four_ncnfhp_long');
  set fourNcnfhpLong(String? value) =>
      setField<String>('four_ncnfhp_long', value);

  String? get fiveNchfnpShort => getField<String>('five_nchfnp_short');
  set fiveNchfnpShort(String? value) =>
      setField<String>('five_nchfnp_short', value);

  String? get fiveNchfnpLong => getField<String>('five_nchfnp_long');
  set fiveNchfnpLong(String? value) =>
      setField<String>('five_nchfnp_long', value);

  String? get sixNchfhpShort => getField<String>('six_nchfhp_short');
  set sixNchfhpShort(String? value) =>
      setField<String>('six_nchfhp_short', value);

  String? get sixNchfhpLong => getField<String>('six_nchfhp_long');
  set sixNchfhpLong(String? value) =>
      setField<String>('six_nchfhp_long', value);
}
