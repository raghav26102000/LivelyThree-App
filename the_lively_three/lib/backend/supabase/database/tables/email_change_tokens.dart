import '../database.dart';

class EmailChangeTokensTable extends SupabaseTable<EmailChangeTokensRow> {
  @override
  String get tableName => 'email_change_tokens';

  @override
  EmailChangeTokensRow createRow(Map<String, dynamic> data) =>
      EmailChangeTokensRow(data);
}

class EmailChangeTokensRow extends SupabaseDataRow {
  EmailChangeTokensRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => EmailChangeTokensTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String get oldEmail => getField<String>('old_email')!;
  set oldEmail(String value) => setField<String>('old_email', value);

  String get newEmail => getField<String>('new_email')!;
  set newEmail(String value) => setField<String>('new_email', value);

  String get token => getField<String>('token')!;
  set token(String value) => setField<String>('token', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);
}
