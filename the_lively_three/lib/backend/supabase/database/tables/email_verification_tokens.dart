import '../database.dart';

class EmailVerificationTokensTable
    extends SupabaseTable<EmailVerificationTokensRow> {
  @override
  String get tableName => 'email_verification_tokens';

  @override
  EmailVerificationTokensRow createRow(Map<String, dynamic> data) =>
      EmailVerificationTokensRow(data);
}

class EmailVerificationTokensRow extends SupabaseDataRow {
  EmailVerificationTokensRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => EmailVerificationTokensTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get token => getField<String>('token')!;
  set token(String value) => setField<String>('token', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);
}
