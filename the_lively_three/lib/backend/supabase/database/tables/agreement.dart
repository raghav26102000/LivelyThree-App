import '../database.dart';

class AgreementTable extends SupabaseTable<AgreementRow> {
  @override
  String get tableName => 'agreement';

  @override
  AgreementRow createRow(Map<String, dynamic> data) => AgreementRow(data);
}

class AgreementRow extends SupabaseDataRow {
  AgreementRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AgreementTable();

  // Fields
  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get rootId => getField<String>('root_id');
  set rootId(String? value) => setField<String>('root_id', value);

  int get version => getField<int>('version')!;
  set version(int value) => setField<int>('version', value);

  String get partyAId => getField<String>('party_a_id')!;
  set partyAId(String value) => setField<String>('party_a_id', value);

  String get partyBId => getField<String>('party_b_id')!;
  set partyBId(String value) => setField<String>('party_b_id', value);

  int get status => getField<int>('status')!;
  set status(int value) => setField<int>('status', value);

  DateTime? get effectiveFrom => getField<DateTime>('effective_from');
  set effectiveFrom(DateTime? value) => setField<DateTime>('effective_from', value);

  DateTime? get effectiveTo => getField<DateTime>('effective_to');
  set effectiveTo(DateTime? value) => setField<DateTime>('effective_to', value);

  String get purpose => getField<String>('purpose')!;
  set purpose(String value) => setField<String>('purpose', value);

  String? get legalBasis => getField<String>('legal_basis');
  set legalBasis(String? value) => setField<String>('legal_basis', value);

  String? get jurisdiction => getField<String>('jurisdiction');
  set jurisdiction(String? value) => setField<String>('jurisdiction', value);

  int get defaultRetentionDays => getField<int>('default_retention_days')!;
  set defaultRetentionDays(int value) => setField<int>('default_retention_days', value);

  dynamic get terms => getField<dynamic>('terms');
  set terms(dynamic value) => setField<dynamic>('terms', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);
}
