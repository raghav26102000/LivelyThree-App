import '../database.dart';

class QuestionOptionsTable extends SupabaseTable<QuestionOptionsRow> {
  @override
  String get tableName => 'question_options';

  @override
  QuestionOptionsRow createRow(Map<String, dynamic> data) => QuestionOptionsRow(data);
}

class QuestionOptionsRow extends SupabaseDataRow {
  QuestionOptionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => QuestionOptionsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int get questionId => getField<int>('questionid')!;
  set questionId(int value) => setField<int>('questionid', value);

  String get option => getField<String>('option')!;
  set option(String value) => setField<String>('option', value);

  String? get optionDesc => getField<String>('optiondesc');
  set optionDesc(String? value) => setField<String>('optiondesc', value);

  String? get optionDescription => getField<String>('optiondescription');
  set optionDescription(String? value) => setField<String>('optiondescription', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  DateTime get createdOn => getField<DateTime>('createdon')!;
  set createdOn(DateTime value) => setField<DateTime>('createdon', value);

  String get createdBy => getField<String>('createdby')!;
  set createdBy(String value) => setField<String>('createdby', value);

  DateTime get lastModifiedOn => getField<DateTime>('lastmodifiedon')!;
  set lastModifiedOn(DateTime value) => setField<DateTime>('lastmodifiedon', value);

  String? get linkedToCodeLookupId => getField<String>('linkedtocodelookupid');
  set linkedToCodeLookupId(String? value) => setField<String>('linkedtocodelookupid', value);

  int get seqno => getField<int>('seqno')!;
  set seqno(int value) => setField<int>('seqno', value);

  int get originaloptionid => getField<int>('original_option_id')!;
  set originaloptionid(int value) => setField<int>('originaloptionid', value);
}