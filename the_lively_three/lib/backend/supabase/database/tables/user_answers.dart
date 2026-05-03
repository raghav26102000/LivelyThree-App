import '../database.dart';

class UserAnswersTable extends SupabaseTable<UserAnswersRow> {
  @override
  String get tableName => 'user_answers';

  @override
  UserAnswersRow createRow(Map<String, dynamic> data) => UserAnswersRow(data);
}

class UserAnswersRow extends SupabaseDataRow {
  UserAnswersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserAnswersTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get questionId => getField<int>('question_id')!;
  set questionId(int value) => setField<int>('question_id', value);

  int? get questionOptionId => getField<int>('question_option_id');
  set questionOptionId(int? value) => setField<int>('question_option_id', value);

  String get linkedToScreen => getField<String>('linkedtoscreen')!;
  set linkedToScreen(String value) => setField<String>('linkedtoscreen', value);

  String get textanswer => getField<String>('answer_text')!;
  set textanswer(String value) => setField<String>('textanswer', value);


  DateTime get createdOn => getField<DateTime>('createdon')!;
  set createdOn(DateTime value) => setField<DateTime>('createdon', value);

  String get createdBy => getField<String>('createdby')!;
  set createdBy(String value) => setField<String>('createdby', value);

  DateTime get lastModifiedOn => getField<DateTime>('lastmodifiedon')!;
  set lastModifiedOn(DateTime value) => setField<DateTime>('lastmodifiedon', value);

  String get lastModifiedBy => getField<String>('lastmodifiedby')!;
  set lastModifiedBy(String value) => setField<String>('lastmodifiedby', value);
}
