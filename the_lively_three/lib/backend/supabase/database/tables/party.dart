import '../database.dart';

class PartyTable extends SupabaseTable<PartyRow> {
  @override
  String get tableName => 'party';

  @override
  PartyRow createRow(Map<String, dynamic> data) => PartyRow(data);
}

class PartyRow extends SupabaseDataRow {
  PartyRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PartyTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  int get type => getField<int>('type')!;
  set type(int value) => setField<int>('type', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get orgName => getField<String>('org_name');
  set orgName(String? value) => setField<String>('org_name', value);

  String? get appName => getField<String>('app_name');
  set appName(String? value) => setField<String>('app_name', value);

  String? get contactEmail => getField<String>('contact_email');
  set contactEmail(String? value) => setField<String>('contact_email', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
