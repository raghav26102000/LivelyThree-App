import '../database.dart';

class QuestionsTable extends SupabaseTable<QuestionsRow> {
  @override
  String get tableName => 'questions';

  @override
  QuestionsRow createRow(Map<String, dynamic> data) => QuestionsRow(data);

}

class QuestionsRow extends SupabaseDataRow {
  QuestionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => QuestionsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get question => getField<String>('question')!;
  set question(String value) => setField<String>('question', value);

  String get questionType => getField<String>('questiontype')!;
  set questionType(String value) => setField<String>('questiontype', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  DateTime get createdOn => getField<DateTime>('createdon')!;
  set createdOn(DateTime value) => setField<DateTime>('createdon', value);

  String get createdBy => getField<String>('createdby')!;
  set createdBy(String value) => setField<String>('createdby', value);

  DateTime get lastModifiedOn => getField<DateTime>('lastmodifiedon')!;
  set lastModifiedOn(DateTime value) => setField<DateTime>('lastmodifiedon', value);

  String? get linkedToScreen => getField<String>('linkedtoscreen');
  set linkedToScreen(String? value) => setField<String>('linkedtoscreen', value);

  int get seqno => getField<int>('seqno')!;
  set seqno(int value) => setField<int>('seqno', value);

  int get originalquestionid => getField<int>('original_question_id')!;
  set originalquestionid(int value) => setField<int>('originalquestionid', value);
}
