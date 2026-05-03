import 'package:the_lively_three/components/customize_journey_prompt/customize_journey_prompt_widget.dart';
import 'package:the_lively_three/components/fluid_bg/fluid_bg_widget.dart';
import 'package:the_lively_three/components/fluid_bg/setting_bg_widget.dart';
import 'package:the_lively_three/components/questionnaire/questionnaire_widget.dart';
import 'package:the_lively_three/utils/loader_util.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'onboarding_model.dart';
export 'onboarding_model.dart';
import '/backend/supabase/database/tables/user_answers.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/providers/locale_provider.dart' as locale_provider;
import '/custom_code/actions/setup_notification.dart' as Notifications;
import '/l10n/app_localizations.dart';
import '/utils/link_to_community.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key});

  static String routeName = 'Onboarding';
  static String routePath = '/onboarding';

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

/// Simple model for a normalized question (grouping options by question_id)
class _QuestionItem {
  final int id;
  final String text;
  final String
      rawType; // raw DB type (e.g. boolean, single_choice, number, date, text)
  final List<String> options; // only for types that use dropdown
  final Map<String, int> optionIdByText; // <-- added: map label -> option_id
  // NEW: original question_id
  final int originalQuestionId;

  // NEW: map label -> original_option_id
  final Map<String, int> originalOptionIdByText;

  final String questionDesc;

  _QuestionItem({
    required this.id,
    required this.text,
    required this.rawType,
    required this.options,
    required this.optionIdByText, // <-- added
    required this.originalQuestionId,
    required this.originalOptionIdByText,
    this.questionDesc = '',
  });
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  late PageController _pageController;
  late OnboardingModel _model;
  bool? _asBool(String? v) {
    if (v == null) return null;
    final s = v.toLowerCase().trim();
    if (s == 'yes' || s == 'true') return true;
    if (s == 'no' || s == 'false') return false;
    return null;
  }

  // --- Helpers
  String? _dropdownTextFor(_QuestionItem qi) =>
      _dropdownControllers[qi.id]?.value ?? _dropdownValues[qi.id];

  /// Raw rows from RPC
  List<Map<String, dynamic>> _rawRows = [];

  /// Grouped questions
  List<_QuestionItem> _questions = [];

  final Map<int, FormFieldController<String>> _dropdownControllers = {};

  int _currentIndex = 0;
  bool _loading = true;
  String? _loadError;
  Locale? currentLocale;
  String? userNameError;
  String? locationError;

  // Input state
  final Map<int, TextEditingController> _textControllers = {};
  final Map<int, String?> _dropdownValues = {};
  final Map<int, DateTime?> _dateValues = {};
  final Map<int, List<String>> _multiValues = {};
  final Map<int, FormFieldController<List<String>>> _multiControllers = {};
  String? userName;
  String? location;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    //_fetchQuestionsFromDB();
    _model = createModel(context, () => OnboardingModel());

    //_loadSavedPageIndex(); // Load saved state if any
    _initializeOnboarding();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          _model.defaultBirthdayOutput =
              await actions.fetchBirthdayOfSomeoneTurning35Now();
          FFAppState().birthday = _model.defaultBirthdayOutput;
          safeSetState(() {});
        }),
        Future(() async {
          // Sets calendar week and calendar year immediately into FFAppstate variables.
          await actions.calculateWeekAndYear(
            getCurrentTimestamp,
          );
        }),
      ]);
    });

    _model.heightTextFieldTextController ??= TextEditingController();
    _model.heightTextFieldFocusNode ??= FocusNode();

    _model.weightTextFieldTextController ??= TextEditingController();
    _model.weightTextFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _initializeOnboarding() async {
    await _fetchQuestionsFromDB();
    if (onboardingFromSettings == true) {
      // Wait for UI to settle
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        //await Future.delayed(const Duration(seconds: 2));

        await _loadSavedAnswers(currentUserUid);
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access the FFAppState locale here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentLocale =
          Provider.of<locale_provider.FFAppState>(context, listen: false)
              .locale;
      _fetchQuestionsFromDB();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadSavedPageIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPageIndex =
        prefs.getInt('savedPageIndex') ?? 0; // Default to 0 if no saved index

    setState(() {
      _currentIndex = savedPageIndex;
      _pageController = PageController(
          initialPage: _currentIndex); // Set PageController to saved index
    });
  }

  // Save page index when user navigates
  Future<void> _savePageIndex(int pageIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('savedPageIndex', pageIndex);
  }

  Future<void> _fetchQuestionsFromDB() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });

    try {
      final data = await Supabase.instance.client.rpc(
        'get_screen_questions',
        params: {
          'stringname': 'Onboarding',
          'p_locale': currentLocale.toString()
        },
      );

      if (data == null) {
        throw Exception("RPC returned null (no data from Supabase)");
      }
      if (data is! List) {
        throw Exception("Unexpected RPC response type: ${data.runtimeType}");
      }

      final list = (data as List)
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      if (list.isEmpty) {
        // If questions are empty, redirect to the Homepage
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(
              context, HomepageWidget.routeName); // Navigate to Homepage
        });
        return; // Exit the function early
      }

      // Group rows (one row per option) -> one question with options[] and optionIdByText{}
      final Map<int, _QuestionItem> grouped = {};

      for (final row in list) {
        final int id = (row['question_id'] as num).toInt();
        final int originalQuestionId =
            (row['original_question_id'] as num).toInt();
        final String text = (row['question_text'] ?? '').toString();
        final String rawType =
            (row['question_type'] ?? '').toString().toLowerCase();

        // Option pieces (may be null)
        final String? optRaw = row['option_text']?.toString();
        final String? opt = optRaw?.trim(); // normalize label
        final int? optId =
            row['option_id'] == null ? null : (row['option_id'] as num).toInt();

        final int? originalOptionId = row['original_option_id'] == null
            ? null
            : (row['original_option_id'] as num).toInt();

        final String questionDesc = (row['question_desc'] ?? '').toString();

        // Ensure the question exists in the map
        final item = grouped.putIfAbsent(
          id,
          () => _QuestionItem(
            id: id,
            text: text,
            rawType: rawType,
            options: <String>[],
            optionIdByText: <String, int>{},
            originalQuestionId: originalQuestionId,
            originalOptionIdByText: <String, int>{},
            questionDesc: questionDesc,
          ),
        );

        // If this row has an option, capture BOTH the label and its id
        if (opt != null && opt.isNotEmpty) {
          if (!item.options.contains(opt)) {
            item.options.add(opt);
          }
          if (optId != null) {
            item.optionIdByText[opt] = optId; // <-- populate the mapping
          }
          if (originalOptionId != null) {
            item.originalOptionIdByText[opt] = originalOptionId;
          }
        }
      }

      setState(() {
        _rawRows = list;
        _questions = grouped.values.toList();
        _loading = false;
      });
    } catch (e, st) {
      print("Exception in _fetchQuestionsFromDB: $e");
      print(st);
      setState(() {
        _loading = false;
        _loadError = e.toString();
      });
    }
  }

  Future<void> _loadSavedAnswers(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('user_answers')
          .select('question_id, question_option_id, answer_text')
          .eq('user_id', userId);

      if (response.isEmpty) {
        print('ℹ️ No saved answers found for $userId');
        return;
      }

      for (final record in response) {
        final qid = record['question_id'];
        final optionId = record['question_option_id'];
        final text = record['answer_text']?.toString();

        // ✅ Safe lookup (avoids Null type error)
        final matchList =
            _questions.where((q) => q.originalQuestionId == qid).toList();
        if (matchList.isEmpty) continue;
        final match = matchList.first;

        final qType = match.rawType.toLowerCase();
        final qText = match.text.toLowerCase();

        // ✅ Handle DATE type - store as DateTime
        if (qType == 'date' ||
            qText.contains('date') ||
            qText.contains('birth')) {
          if (text != null && text.isNotEmpty) {
            try {
              _dateValues[qid] = DateTime.parse(text);
            } catch (e) {
              print('❌ Error parsing date for Q$qid: $e');
            }
          }
        }
        // ✅ Handle WEIGHT - store as text for initialValue (wheel picker will parse it)
        else if (qText.contains('weigh')) {
          if (text != null && text.isNotEmpty) {
            _textControllers[qid] ??= TextEditingController();
            _textControllers[qid]!.text = text;
          }
        }
        // ✅ Handle HEIGHT - store as text for initialValue (wheel picker will parse it)
        else if (qText.contains('height')) {
          if (text != null && text.isNotEmpty) {
            _textControllers[qid] ??= TextEditingController();
            _textControllers[qid]!.text = text;
          }
        }
        // ✅ Handle TEXT and NUMBER types
        else if (qType == 'text' || qType == 'number') {
          if (text != null && text.isNotEmpty) {
            _textControllers[qid] ??= TextEditingController();
            _textControllers[qid]!.text = text;
          }
        }
        // ✅ Handle SINGLE_CHOICE and BOOLEAN (dropdowns)
        else if (qType == 'single_choice' || qType == 'boolean') {
          // Find the option text by matching optionId
          final selectedText = match.originalOptionIdByText.entries
              .firstWhere(
                (entry) => entry.value == optionId,
                orElse: () => const MapEntry('', 0),
              )
              .key;

          if (selectedText.isNotEmpty) {
            _dropdownValues[qid] = selectedText;
          }
        }
        // ✅ Handle MULTI_CHOICE
        else if (qType == 'multi_choice' || qType == 'multi') {
          final selectedText = match.originalOptionIdByText.entries
              .firstWhere(
                (entry) => entry.value == optionId,
                orElse: () => const MapEntry('', 0),
              )
              .key;

          if (selectedText.isNotEmpty) {
            _multiValues[qid] ??= [];
            if (!_multiValues[qid]!.contains(selectedText)) {
              _multiValues[qid]!.add(selectedText);
            }
          }
        }
      }
      // ✅ Force UI update to reflect loaded values
      if (mounted) setState(() {});
    } catch (e, st) {
      print('❌ Error loading saved answers: $e');
      print(st);
    }
  }

  String _normalizedType(_QuestionItem q) {
    final t = q.rawType.toLowerCase();
    if (t == 'text' || t == 'number' || t == 'date') return t;
    if (t == 'multi_choice') return 'multi';
    // If non-input type but no options, infer from question text, otherwise dropdown.
    if (q.options.isEmpty) {
      final s = q.text.toLowerCase();
      if (s.contains('date') ||
          s.contains('birth') ||
          s.contains('birthday') ||
          s.contains('dob')) {
        return 'date';
      }
      if (s.contains('height') ||
          s.contains('weight') ||
          s.contains('age') ||
          s.contains('year') ||
          s.contains('number')) {
        return 'number';
      }
      return 'text';
    }

    return 'dropdown'; // boolean, single_choice, etc. with options -> dropdown
  }

  // -------------------- QUESTION PAGES --------------------
  Widget _buildQuestionPage(BuildContext context, _QuestionItem q) {
    final theme = FlutterFlowTheme.of(context);
    final finalType = _normalizedType(
        q); // returns one of: dropdown | multi | date | number | text | boolean(single)

    Widget input;
    switch (finalType) {
      case 'multi': // multi_select (select all that apply) with real checkboxes
        final List<String> selected =
            _multiValues.putIfAbsent(q.originalQuestionId, () => <String>[]);

        input = ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.85,
            maxHeight: MediaQuery.sizeOf(context).height * 0.35,
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: q.options.length,
              itemBuilder: (context, idx) {
                final opt = q.options[idx];
                final isChecked = selected.contains(opt);
                return CheckboxListTile(
                  dense: true,
                  title:
                      Text(opt, style: FlutterFlowTheme.of(context).bodyMedium),
                  value: isChecked,
                  onChanged: (bool? v) {
                    setState(() {
                      if (v == true) {
                        if (!selected.contains(opt)) selected.add(opt);
                      } else {
                        selected.remove(opt);
                      }
                      _multiValues[q.originalQuestionId] =
                          List<String>.from(selected);

                      final ctrl = _multiControllers[q.originalQuestionId];
                      if (ctrl != null)
                        ctrl.value = List<String>.from(selected);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                );
              },
            ),
          ),
        );
        break;

      case 'dropdown': // single_choice (or your yes/no boolean presented as dropdown)
        final String? initialValue = _dropdownValues.putIfAbsent(
          q.originalQuestionId,
          () => (q.options.isNotEmpty ? q.options.first : 'Yes'),
        );

        final FormFieldController<String> ddController =
            _dropdownControllers.putIfAbsent(
          q.originalQuestionId,
          () => FormFieldController<String>(initialValue ?? ''),
        );

        input = FlutterFlowDropDown<String>(
          controller: ddController,
          options: q.options.isNotEmpty ? q.options : <String>['Yes', 'No'],
          onChanged: (val) {
            if (val == null) return;
            setState(() {
              _dropdownValues[q.originalQuestionId] = val;
              ddController.value = val;
            });
          },
          width: MediaQuery.sizeOf(context).width * 0.6,
          height: MediaQuery.sizeOf(context).height * 0.06,
          textStyle: theme.bodyMedium.override(
            fontFamily: theme.bodyMediumFamily,
            fontSize: FlutterFlowTheme.adjustScale(size: 14),
            useGoogleFonts: !theme.bodyMediumIsCustom,
          ),
          hintText: 'Select...',
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: theme.primaryText, size: 24),
          fillColor: theme.secondaryBackground,
          elevation: 2.0,
          borderColor: theme.secondaryText,
          borderWidth: 1.0,
          borderRadius: 8.0,
          margin: const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
          hidesUnderline: true,
          isOverButton: false,
          isSearchable: false,
          isMultiSelect: false,
        );
        break;

      case 'date':
        input = FFButtonWidget(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _dateValues[q.originalQuestionId] ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() => _dateValues[q.originalQuestionId] = picked);
            }
          },
          text: _dateValues[q.originalQuestionId] == null
              ? 'Pick a date'
              : DateFormat('yyyy-MM-dd')
                  .format(_dateValues[q.originalQuestionId]!),
          options: FFButtonOptions(
            width: 220,
            height: 48,
            color: theme.secondary,
            textStyle: theme.titleSmall.override(
              fontFamily: theme.titleSmallFamily,
              color: Colors.white,
              fontSize: FlutterFlowTheme.adjustScale(size: 16),
              useGoogleFonts: !theme.titleSmallIsCustom,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
        );
        break;

      case 'number':
        input = ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
          child: TextField(
            controller: _textControllers[q.originalQuestionId] ??=
                TextEditingController(),
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: false),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
            decoration: const InputDecoration(
              hintText: 'Enter a number',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        );
        break;

      case 'text':
      default:
        input = ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
          child: TextField(
            controller: _textControllers[q.originalQuestionId] ??=
                TextEditingController(),
            decoration: const InputDecoration(
              hintText: 'Enter your answer',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        );
        break;
    }

    // --- Page nav flags (unchanged)
    final totalPages = (onboardingFromSettings ? 0 : 5) + _questions.length;
    final isLastPage = _currentIndex == totalPages - 1;

    bool? _asBool(String? v) {
      if (v == null) return null;
      final s = v.toLowerCase().trim();
      if (s == 'yes' || s == 'true') return true;
      if (s == 'no' || s == 'false') return false;
      return null;
    }

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            // Rainbow gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x58FFFFFF),
                    Color(0x2DF83B46),
                    Color(0x3DFF8700),
                    Color(0x43FBE403),
                    Color(0x2400E4FF),
                    Color(0x226D00FF),
                    Color(0x2AF500FF),
                    Color(0x31FFFFFF),
                    Color(0x27F0F5F9)
                  ],
                  stops: [0.2, 0.32, 0.37, 0.42, 0.49, 0.56, 0.61, 0.75, 1.0],
                  begin: AlignmentDirectional(0.34, -1.0),
                  end: AlignmentDirectional(-0.34, 1.0),
                ),
              ),
            ),

            Column(
              children: [
                const SizedBox(height: 40),

                // Centered logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Rainbow_Icon-removebg-preview.png',
                        width: MediaQuery.sizeOf(context).width * 0.3,
                        height: MediaQuery.sizeOf(context).height * 0.15,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),

                // Center question + input vertically
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoSizeText(
                          q.text,
                          textAlign: TextAlign.center,
                          minFontSize: FlutterFlowTheme.adjustScale(size: 12),
                          style: theme.bodyMedium.override(
                            fontFamily: theme.bodyMediumFamily,
                            fontSize: FlutterFlowTheme.adjustScale(size: 22),
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: !theme.bodyMediumIsCustom,
                          ),
                        ),
                        const SizedBox(height: 16),
                        input,
                      ],
                    ),
                  ),
                ),

                // Bottom buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentIndex > 0)
                        FFButtonWidget(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          text: 'Previous',
                          options: FFButtonOptions(
                            width: 140,
                            height: 48,
                            color: theme.secondary,
                            textStyle: theme.titleSmall.override(
                              fontFamily: theme.titleSmallFamily,
                              color: Colors.white,
                              fontSize: FlutterFlowTheme.adjustScale(size: 16),
                              useGoogleFonts: !theme.titleSmallIsCustom,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      const SizedBox(width: 10),
                      if (isLastPage)
                        FFButtonWidget(
                          onPressed: () async {
                            // ===== INSERT into user_answers for each question =====
                            await processOnboardingAnswers(
                                context, currentUserUid, _questions, _model);

                            safeSetState(() {});
                            // ===== END: Create Selection logic =====
                          },
                          text: 'Create Selection',
                          options: FFButtonOptions(
                            width: 180,
                            height: 48,
                            color: theme.secondary,
                            textStyle: theme.titleSmall.override(
                              fontFamily: theme.titleSmallFamily,
                              color: Colors.white,
                              fontSize: FlutterFlowTheme.adjustScale(size: 16),
                              useGoogleFonts: !theme.titleSmallIsCustom,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        )
                      else
                        FFButtonWidget(
                          onPressed: () async {
                            await _saveAnswerForCurrentQuestion(q);
                            if (_currentIndex < totalPages - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                          },
                          text: 'Next',
                          options: FFButtonOptions(
                            width: 140,
                            height: 48,
                            color: theme.secondary,
                            textStyle: theme.titleSmall.override(
                              fontFamily: theme.titleSmallFamily,
                              color: Colors.white,
                              fontSize: FlutterFlowTheme.adjustScale(size: 16),
                              useGoogleFonts: !theme.titleSmallIsCustom,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteExistingAnswers(String userId, int qid) async {
    await UserAnswersTable().delete(
      matchingRows: (rows) =>
          rows.eqOrNull('user_id', userId).eqOrNull('question_id', qid),
    );
  }

  Future<void> _saveAnswerForCurrentQuestion(_QuestionItem qi) async {
    final String qt = _normalizedType(qi);
    final String lt = qi.text.toLowerCase();
    final now = getCurrentTimestamp;
    final List<int> selectedOptionIds = <int>[];
    String? freeTextToSave;
    DateTime? pickedBirthdate;
    int? enteredHeight;
    double? enteredWeight;
    String? _dropdownTextFor(_QuestionItem qi) =>
        _dropdownControllers[qi.id]?.value ?? _dropdownValues[qi.id];

    //_deleteExistingAnswers(currentUserUid, qi.id);

    if (qt == 'multi') {
      final selected = _multiControllers[qi.originalQuestionId]?.value ??
          _multiValues[qi.originalQuestionId] ??
          <String>[];
      for (final s in selected) {
        final id = qi.originalOptionIdByText[s];
        if (id != null) selectedOptionIds.add(id);
      }
    } else if (qt == 'dropdown' || qt == 'boolean') {
      final s = _dropdownTextFor(qi);
      if (s != null && s.isNotEmpty) {
        final id = qi.originalOptionIdByText[s];
        if (id != null) selectedOptionIds.add(id);
      }
    } else if (qt == 'date') {
      final d = _dateValues[qi.id];
      if (d != null) {
        pickedBirthdate = d;
        FFAppState().birthday = d; // keep prior behavior
        freeTextToSave = DateFormat('yyyy-MM-dd').format(d);
      }
    } else if (qt == 'number') {
      final txt = _textControllers[qi.id]?.text?.trim();
      if ((txt ?? '').isNotEmpty) {
        freeTextToSave = txt;
        // derive known numeric fields
        if (lt.contains('height')) {
          enteredHeight = int.tryParse(txt!);
          if (enteredHeight != null) _model.height = enteredHeight;
        }
        if (lt.contains('weight')) {
          enteredWeight = double.tryParse(txt!);
          if (enteredWeight != null) _model.weight = enteredWeight;
        }
      }
    } else {
      // 'text'
      final txt = _textControllers[qi.id]?.text?.trim();
      if ((txt ?? '').isNotEmpty) {
        freeTextToSave = txt;
        // derive known textual fields if any appear in text type
        if (lt.contains('do you weigh') || lt.contains('weight')) {
          // Regex to capture value + unit
          final match =
              RegExp(r'^(\d+(?:\.\d+)?)\s*([a-zA-Z]+)?$').firstMatch(txt!);

          if (match != null) {
            final valStr = match.group(1); // e.g. "54"
            final unitStr = match.group(2)?.toLowerCase(); // e.g. "kg" or "lbs"

            if (valStr != null) {
              enteredWeight = double.tryParse(valStr);
              if (enteredWeight != null) {
                _model.weight = enteredWeight;
                _model.weightUnit =
                    unitStr ?? "kg"; // default to kg if not specified
              }
            }
          }
        }
        if (lt.contains('height')) {
          final match =
              RegExp(r'^(\d+(?:\.\d+)?)\s*([a-zA-Z]+)?$').firstMatch(txt!);

          if (match != null) {
            final valStr = match.group(1); // e.g. "170"
            final unitStr = match.group(2)?.toLowerCase(); // e.g. "cm" or "ft"

            if (valStr != null) {
              enteredHeight = int.tryParse(valStr);
              if (enteredHeight != null) {
                _model.height = enteredHeight;
                _model.heightUnit =
                    unitStr ?? "cm"; // default to cm if not specified
              }
            }
          }
        }
      }
    }

    final existingAnswer = await SupaFlow.client
        .from('user_answers')
        .select('id, answer_text, question_option_id')
        .eq('user_id', currentUserUid)
        .eq('question_id', qi.originalQuestionId)
        .maybeSingle();

    if (existingAnswer != null) {
      // 1) If an existing answer is found, update it with the new data
      if (freeTextToSave != null && freeTextToSave.isNotEmpty) {
        await UserAnswersTable().update(
          data: {
            'answer_text': freeTextToSave, // Update the answer text
            'lastmodifiedon': supaSerialize<DateTime>(now), // Update timestamp
            'lastmodifiedby': currentUserUid, // User performing the update
          },
          matchingRows: (rows) => rows
              .eqOrNull('user_id',
                  currentUserUid) // Ensure it matches the current user
              .eqOrNull('question_id',
                  qi.originalQuestionId), // Ensure it matches the correct question_id
        );
      } else {
        if (selectedOptionIds.isNotEmpty) {
          for (final oid in selectedOptionIds) {
            await UserAnswersTable().update(
              data: {
                'question_option_id': oid,
                'lastmodifiedon':
                    supaSerialize<DateTime>(now), // Update timestamp
                'lastmodifiedby': currentUserUid, // User performing the update
              },
              matchingRows: (rows) => rows
                  .eqOrNull('user_id',
                      currentUserUid) // Ensure it matches the current user
                  .eqOrNull('question_id',
                      qi.originalQuestionId), // Ensure it matches the correct question_id
            );
          }
        }
      }
    } else {
      // 2) If no existing answer is found, handle insertion logic
      if (selectedOptionIds.isNotEmpty) {
        for (final oid in selectedOptionIds) {
          await UserAnswersTable().insert({
            'user_id': currentUserUid,
            'question_id': qi.originalQuestionId,
            'question_option_id': oid,
            'answer_text': null, // since option stored
            'linkedtoscreen': 'Onboarding',
            'createdon': supaSerialize<DateTime>(now),
            'createdby': currentUserUid,
            'lastmodifiedon': supaSerialize<DateTime>(now),
            'lastmodifiedby': currentUserUid,
          });
        }
      } else {
        // 3) If there's free text, insert a new row
        if (freeTextToSave != null && freeTextToSave.isNotEmpty) {
          await UserAnswersTable().insert({
            'user_id': currentUserUid,
            'question_id': qi.originalQuestionId,
            'question_option_id': null,
            'answer_text': freeTextToSave, // Free text answer
            'linkedtoscreen': 'Onboarding',
            'createdon': supaSerialize<DateTime>(now),
            'createdby': currentUserUid,
            'lastmodifiedon': supaSerialize<DateTime>(now),
            'lastmodifiedby': currentUserUid,
          });
        }
      }
    }
  }

  Future<void> processOnboardingAnswers(
    BuildContext context,
    String currentUserUid,
    List<_QuestionItem> questions,
    OnboardingModel _model, // replace with your actual model class
  ) async {
    // Derived fields captured from answers
    String? selectedGender;
    String? selectedEthnicity;
    String? selectedActivityLevel;
    String? selectedFiberSource;
    String? selectedProteinSource;
    String? selectedUPFKnowledge;
    String? selectedEnvironmentalInterest;
    String? selectedTipsInterest;
    String? selectedFruitsVeggies;
    bool? healthyEating;
    bool? newFoods;
    bool? differentPlants;
    DateTime? pickedBirthdate;
    int? enteredHeight;
    double? enteredWeight;
    String? primaryGoal;
    String? secondaryGoal;
    String? firstName;
    String? lastName;
    String? phoneNumber;

    int? ethnicityCode;

    for (final qi in questions) {
      final String lt = qi.text.toLowerCase();
      final String qt = _normalizedType(qi);

      final List<int> selectedOptionIds = <int>[];
      String? freeTextToSave;

      // Handle based on type
      if (qt == 'date') {
        final d = _dateValues[qi.originalQuestionId];
        if (d != null) {
          pickedBirthdate = d;
          FFAppState().birthday = d;
          freeTextToSave = DateFormat('yyyy-MM-dd').format(d);
        }
      } else if (qt == 'number' || qt == 'text') {
        final txt = _textControllers[qi.originalQuestionId]?.text?.trim();
        if ((txt ?? '').isNotEmpty) {
          freeTextToSave = txt;

          // Handle specific text fields
          if (lt.contains('first name')) {
            firstName = txt;
          } else if (lt.contains('last name')) {
            lastName = txt;
          } else if (lt.contains('phone')) {
            phoneNumber = txt;
          }

          // parse weight
          if (lt.contains('weight') || lt.contains('do you weigh')) {
            final match =
                RegExp(r'^(\d+(?:\.\d+)?)\s*([a-zA-Z]+)?$').firstMatch(txt!);
            if (match != null) {
              final valStr = match.group(1);
              final unitStr = match.group(2)?.toLowerCase();
              if (valStr != null) {
                enteredWeight = double.tryParse(valStr);
                if (enteredWeight != null) {
                  _model.weight = enteredWeight;
                  _model.weightUnit = unitStr ?? "kg";
                }
              }
            }
          }

          // parse height
          if (lt.contains('height')) {
            final match =
                RegExp(r'^(\d+(?:\.\d+)?)\s*([a-zA-Z]+)?$').firstMatch(txt!);
            if (match != null) {
              final valStr = match.group(1);
              final unitStr = match.group(2)?.toLowerCase();
              if (valStr != null) {
                enteredHeight = int.tryParse(valStr);
                if (enteredHeight != null) {
                  _model.height = enteredHeight;
                  _model.heightUnit = unitStr ?? "cm";
                }
              }
            }
          }
        }
      }

      // Handle all dropdown/choice values (both dropdown and single_choice/multiple_choice)
      final String? selectedTextForThisQ =
          _dropdownValues[qi.originalQuestionId];

      if (selectedTextForThisQ != null) {
        // Map to specific fields based on question content
        if (lt.contains('gender')) {
          selectedGender = selectedTextForThisQ;
        } else if (lt.contains('ethnicity')) {
          selectedEthnicity = selectedTextForThisQ;
        } else if (lt.contains('activity level')) {
          selectedActivityLevel = selectedTextForThisQ;
        } else if (lt.contains('fiber') && lt.contains('source')) {
          selectedFiberSource = selectedTextForThisQ;
        } else if (lt.contains('protein') && lt.contains('source')) {
          selectedProteinSource = selectedTextForThisQ;
        } else if (lt.contains('ultra-processed') || lt.contains('upf')) {
          selectedUPFKnowledge = selectedTextForThisQ;
        } else if (lt.contains('environmental')) {
          selectedEnvironmentalInterest = selectedTextForThisQ;
        } else if (lt.contains('tips') || lt.contains('recipes')) {
          selectedTipsInterest = selectedTextForThisQ;
        } else if (lt.contains('fruits and vegetables') ||
            lt.contains('portions') ||
            lt.contains('500g')) {
          selectedFruitsVeggies = selectedTextForThisQ;
        } else if (lt.contains('primary goal')) {
          primaryGoal = selectedTextForThisQ;
        } else if (lt.contains('secondary goal')) {
          secondaryGoal = selectedTextForThisQ;
        } else if (lt.contains('eat healthy')) {
          healthyEating = _asBool(selectedTextForThisQ);
        } else if (lt.contains('new foods')) {
          newFoods = _asBool(selectedTextForThisQ);
        } else if (lt.contains('different plants')) {
          differentPlants = _asBool(selectedTextForThisQ);
        }
      }
    }

    // ===== Save derived values with fallbacks =====
    final genderToSave =
        selectedGender ?? _model.genderDropDownValue ?? 'Female';
    final healthyToSave = healthyEating ??
        (_model.healthyQuantityDropDownValue == 'no' ? false : true);
    final newFoodsToSave =
        newFoods ?? (_model.newFoodsDropDownValue == 'no' ? false : true);
    final diffPlantsToSave = differentPlants ??
        (_model.varietyFoodDropDownValue == 'no' ? false : true);
    final birthdateToSave = pickedBirthdate ?? FFAppState().birthday;
    final heightToSave = enteredHeight ?? _model.height ?? 170;
    final weightToSave = enteredWeight ?? _model.weight ?? 65.0;
    final primaryGoalToSave =
        primaryGoal ?? _model.primaryGoalDropDownValue ?? 'General Health';
    final secondaryGoalToSave =
        secondaryGoal ?? _model.secondaryGoalDropDownValue ?? 'Longevity';
    final activityLevelToSave = selectedActivityLevel ??
        _model.activityLevelDropDownValue ??
        'Low (less than 45 min a day of movement)';

    if (selectedEthnicity != null && selectedEthnicity.trim().isNotEmpty) {
      try {
        final codeLookup = await Supabase.instance.client
            .from('codelkup')
            .select('keycode')
            .eq('lkcode', 'ethnicity')
            .eq('key1', selectedEthnicity)
            .maybeSingle();

        ethnicityCode = codeLookup?['keycode'];

        // Step 3️⃣: Fallback if null → default to Caucasian
        if (ethnicityCode == null) {
          final fallback = await Supabase.instance.client
              .from('codelkup')
              .select('keycode')
              .eq('lkcode', 'ethnicity')
              .eq('key1', 'Caucasian')
              .maybeSingle();

          ethnicityCode = fallback?['keycode'];
        }
      } catch (e) {
        print('❌ Error resolving ethnicity keycode: $e');
      }
    } else {
      // Optional: fallback directly to Caucasian if needed
      final fallback = await Supabase.instance.client
          .from('codelkup')
          .select('keycode')
          .eq('lkcode', 'ethnicity')
          .eq('key1', 'Caucasian')
          .maybeSingle();

      ethnicityCode = fallback?['keycode'];
    }

    // ===== Database writes =====

    final birthdateString =
        birthdateToSave; // Assuming it's stored as ISO string or DateTime
    final birthdate = DateTime.parse(birthdateString.toString());

    // Calculate age
    final now = DateTime.now();
    int age = now.year - birthdate.year;
    if (now.month < birthdate.month ||
        (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }

    final existingReason;
    try {
      // Prepare user table data
      Map<String, dynamic> userData = {
        'gender': genderToSave,
        'height': heightToSave,
        'birthdate': supaSerialize<DateTime>(birthdateToSave),
        'age': age,
        'ethnicity': ethnicityCode,
      };

      // Prepare onboarding table data
      Map<String, dynamic> onboardingData = {
        'q_healthyeating': healthyToSave,
        'q_newfoods': newFoodsToSave,
        'q_differentplants': diffPlantsToSave,
        'q_activitylevel': activityLevelToSave,
        'q_changewillingness':
            _model.changeReadinessDropDownValue == 'no' ? false : true,
        'q_changeto': _model.changeToDropDownValue,
        'q_goal_one': primaryGoalToSave,
        'q_goal_two': secondaryGoalToSave,
        'user_id': currentUserUid,
      };

      Map<String, dynamic>? existingData;
      try {
        existingData = await Supabase.instance.client
            .from('users')
            .select('age, gender, ethnicity, country')
            .eq('id', currentUserUid)
            .maybeSingle();
      } catch (e) {
        print('⚠️ Failed to fetch existing user data: $e');
      }

      existingReason =
          "Existing → Age: ${existingData?['age'] ?? 'N/A'}, Gender: ${existingData?['gender'] ?? 'N/A'}, Ethnicity: ${existingData?['ethnicity'] ?? 'N/A'}, Location: ${existingData?['country'] ?? 'N/A'}";

      await Future.wait([
        UsersTable().update(
          data: userData,
          matchingRows: (rows) => rows.eqOrNull('id', currentUserUid),
        ),
        OnboardingTable().insert(onboardingData),
        UserVitalsTable().insert({
          'value': weightToSave,
          'vital_type': 'Weight',
          'unit': _model.weightUnit,
          'currentday': FFAppState().currentDay,
          'calendarweek': FFAppState().calendarWeek,
          'user_id': currentUserUid,
          'calendaryear': FFAppState().calendarYear,
        }),
      ]);
    } catch (e) {
      print('❌ Error in initial database writes: $e');
      rethrow;
    }

    try {
      _model.plantpresetconfigOutput = await PlantpresetconfigurationTable()
          .queryRows(
              queryFn: (q) => q
                  .eqOrNull('exploratory', _model.isExploratory ?? false)
                  .eqOrNull('is_below_sixtyfive', _model.isOlderThan65 ?? true)
                  .eqOrNull('primary_goal', primaryGoalToSave)
                  .eqOrNull('secondary_goal', secondaryGoalToSave));

      FFAppState().onboardPreset =
          _model.plantpresetconfigOutput?.firstOrNull?.presetLabel ??
              'three_ncnfnp_short';
    } catch (e) {
      print('❌ Error in preset lookup: $e');
      FFAppState().onboardPreset = 'three_ncnfnp_short'; // fallback
      print('🌱 Using fallback preset: ${FFAppState().onboardPreset}');
    }

    if (context.mounted) {
      try {
        final fiberValue =
            _model.plantpresetconfigOutput?.firstOrNull?.fiberValue ?? 40.0;
        final proteinValue =
            _model.plantpresetconfigOutput?.firstOrNull?.proteinValue ?? 0.8;
        final presetLabel =
            _model.plantpresetconfigOutput?.firstOrNull?.presetLabel ??
                'three_ncnfnp_short';

        await UsersTable().update(
          data: {
            'current_fiber_value': fiberValue,
            'current_protein_value': proteinValue,
          },
          matchingRows: (rows) => rows.eqOrNull('id', currentUserUid),
        );

        await OnboardingTable().insert({
          'q_healthyeating': healthyToSave,
          'q_newfoods': newFoodsToSave,
          'q_differentplants': diffPlantsToSave,
          'q_activitylevel': _model.activityLevelDropDownValue,
          'q_changewillingness':
              _model.changeReadinessDropDownValue == 'no' ? false : true,
          'q_changeto': _model.changeToDropDownValue,
          'q_goal_one': primaryGoalToSave,
          'q_goal_two': secondaryGoalToSave,
          'user_id': currentUserUid,
          'plantpreset': presetLabel,
        });
      } catch (e) {
        print('❌ Error in preset configuration updates: $e');
      }
    }

    try {
      await actions.bulkInsertPresetPlants(
        currentUserUid,
        FFAppState().calendarWeek.toString(),
        FFAppState().calendarYear.toString(),
        FFAppState().onboardPreset,
      );
    } catch (e) {
      print('❌ Error inserting preset plants: $e');
    }

    try {
      await UsersTable().update(
        data: {
          'is_onboarded': true,
          'onboarded_at': DateTime.now().toUtc().toIso8601String(),
        },
        matchingRows: (rows) => rows.eqOrNull('id', currentUserUid),
      );
      await CommunityJoinService().ensurePartyAndJoinCommunity(existingReason);
    } catch (e) {
      print('❌ Error marking user as onboarded: $e');
    }

    // Confirmation dialog
    if (context.mounted) {
      await Future.delayed(const Duration(milliseconds: 2000));
      await Notifications.requestNotificationPermission();
      print('Homepage loading');
      context.goNamed(HomepageWidget.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 2 intro pages + N question pages
    final localization = AppLocalizations.of(context)!;
    final totalPages = (onboardingFromSettings ? 0 : 5) + _questions.length;

    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Failed to load questions:\n$_loadError',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SafeArea(
                  child: Stack(children: [
                  const SettingsBG(),
                  PageView.builder(
                    controller: _pageController,
                    // keep it non-scrollable to force buttons
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) {
                      setState(() {
                        _currentIndex = i;
                      });
                      if (onboardingFromSettings == false) {
                        _savePageIndex(i);
                      }
                      // Save page index whenever the page changes
                    },
                    itemCount: totalPages,
                    itemBuilder: (context, index) {
                      if (onboardingFromSettings == false) {
                        if (index == 0) {
                          return DynamicFormField(
                            title: localization.tellUsAboutYourself,
                            placeholder: localization.enterUsername,
                            description: localization.question_username,
                            inputType: 'text',
                            options: null,
                            showSkipAll: false,
                            currentQuestions: _currentIndex,
                            totalQuestions: 5,
                            isSkipVisible: false,
                            showBack: false, // 🔑 hide back button
                            errorText: userNameError,
                            onChanged: (value) {
                              //setState(() {
                              userName = value?.toString();
                              if ((userName?.trim().isNotEmpty ?? false)) {
                                userNameError =
                                    null; // ✅ clear error as soon as valid
                              }
                              //});
                            },
                            onNext: () async {
                              FocusScope.of(context).unfocus();
                              if ((userName?.trim().isEmpty ?? true)) {
                                setState(() {
                                  userNameError = localization
                                      .enterUsername; // ✅ triggers red border + text
                                });
                                return;
                              }
                              try {
                                await UsersTable().update(
                                  data: {
                                    'user_name': userName,
                                  },
                                  matchingRows: (rows) =>
                                      rows.eqOrNull('id', currentUserUid),
                                );
                              } catch (e) {
                                print("❌ Error updating user text: $e");
                              }
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                          );
                        }

                        if (index == 1) {
                          return DynamicFormField(
                            title: localization.tellUsAboutYourself,
                            description: localization.question_usage,
                            inputType: 'location',
                            options: null,
                            currentQuestions: _currentIndex,
                            totalQuestions: 5,
                            isSkipVisible: false,
                            showSkipAll: false,
                            errorText: locationError, // 👈 pass error to field
                            onChanged: (value) {
                              setState(() {
                                location = value?.toString() ?? '';
                                if ((location?.trim().isNotEmpty ?? false)) {
                                  locationError =
                                      null; // ✅ clear error once user selects
                                }
                              });
                            },
                            onNext: () async {
                              FocusScope.of(context).unfocus();
                              if ((location?.trim().isEmpty ?? true)) {
                                setState(() {
                                  locationError = localization
                                      .selectCountry; // 👈 show under dropdown
                                });
                                return;
                              }
                              try {
                                await UsersTable().update(
                                  data: {
                                    'country': location,
                                  },
                                  matchingRows: (rows) =>
                                      rows.eqOrNull('id', currentUserUid),
                                );
                              } catch (e) {
                                print("❌ Error updating country text: $e");
                              }
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                            onBack: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                          );
                        }
                        if (index == 2) {
                          return DynamicFormField(
                            title: 'Data Ownership',
                            description: '',
                            inputType: 'dataOwnership',
                            options: null,
                            currentQuestions: _currentIndex,
                            totalQuestions: 5,
                            isSkipVisible: true,
                            showSkipAll: false,
                            skipButtonBorder: true,
                            skipText: 'Skip for Now',
                            continueButtonText: 'I Consent',
                            errorText: locationError, // 👈 pass error to field
                            onChanged: (value) {},
                            onNext: () async {
                              try {
                                LoaderUtils.showLoader(context);

                                // Handle data ownership consent
                                await handleDataOwnershipConsent(
                                    context, currentUserUid);

                                LoaderUtils.hideLoader(context);

                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              } catch (e) {
                                LoaderUtils.hideLoader(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                            onSkip: () async {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                            onBack: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                          );
                        }

                        if (index == 3) {
                          return DynamicFormField(
                            title: 'We are not a medical application',
                            description: '',
                            inputType: 'medicalAppication',
                            options: null,
                            currentQuestions: _currentIndex,
                            totalQuestions: 5,
                            isSkipVisible: true,
                            showSkipAll: false,
                            skipButtonBorder: true,
                            skipText: 'No',
                            continueButtonText: 'I Consent',
                            errorText: locationError, // 👈 pass error to field
                            onChanged: (value) {},
                            onSkip: () async {
                              try {
                                await handleMedicalConsent(
                                    context, currentUserUid, false);
                                // Don't add any navigation here - deleteUserAccount handles it
                              } catch (e) {
                                // Error already shown in deleteUserAccount, just log
                                print('Error in onSkip: $e');
                              }
                            },
                            onNext: () async {
                              // User consented
                              try {
                                LoaderUtils.showLoader(context);

                                await handleMedicalConsent(
                                    context, currentUserUid, true);

                                LoaderUtils.hideLoader(context);

                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                                //Navigator.pop(context);
                              } catch (e) {
                                LoaderUtils.hideLoader(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error: ${e.toString()}')),
                                );
                                Navigator.pop(context);
                              }
                            },
                            onBack: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                          );
                        }
                        if (index == 4) {
                          return DynamicFormField(
                            title:
                                'Would you like to personalise your app experience?',
                            description: '',
                            inputType: 'personliseExperience',
                            options: null,
                            currentQuestions: _currentIndex,
                            totalQuestions: 5,
                            isSkipVisible: true,
                            showSkipAll: false,
                            errorText: locationError, // 👈 pass error to field
                            onChanged: (value) {},
                            onSkip: () async {
                              FocusScope.of(context).unfocus();
                              LoaderUtils.showLoader(context);
                              // ✅ Also call function if skipping
                              await processOnboardingAnswers(
                                context,
                                currentUserUid,
                                _questions,
                                _model,
                              );

                              saveDefaultAnswers(_questions);

                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                              // Navigator.pop(context);
                            },
                            skipButtonBorder: true,
                            skipText: 'Use Default Settings',
                            onNext: () async {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                              // Navigator.pop(context);
                            },
                            onBack: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                          );
                        }

                        // if (index == 4) {
                        //   return CustomizeJourneyPrompt(
                        //     title: localization.personalized_experienceTitle,
                        //     showBack: false, // 🔑 hide back button
                        //     onNext: () {
                        //       FocusScope.of(context).unfocus();
                        //       _pageController.nextPage(
                        //         duration: const Duration(milliseconds: 300),
                        //         curve: Curves.ease,
                        //       );
                        //     },
                        //     onSkip: () async {
                        //       FocusScope.of(context).unfocus();
                        //       LoaderUtils.showLoader(context);
                        //       // ✅ Also call function if skipping
                        //       await processOnboardingAnswers(
                        //         context,
                        //         currentUserUid,
                        //         _questions,
                        //         _model,
                        //       );

                        //       saveDefaultAnswers(_questions);

                        //       _pageController.nextPage(
                        //         duration: const Duration(milliseconds: 300),
                        //         curve: Curves.ease,
                        //       );
                        //     },
                        //   );
                        // }
                      }

                      // When onboardingFromSettings == true → start from 0
// When false → skip the first 3 intro pages
                      final adjustedIndex =
                          onboardingFromSettings ? index : index - 5;

// Prevent out-of-range access
                      if (adjustedIndex < 0 ||
                          adjustedIndex >= _questions.length) {
                        return const SizedBox.shrink();
                      }

                      final qi = _questions[adjustedIndex];

                      return DynamicFormField(
                        title: qi.text,
                        inputType: qi.rawType,
                        description: qi.questionDesc,
                        options: qi.options,
                        currentQuestions: adjustedIndex,
                        totalQuestions: onboardingFromSettings
                            ? totalPages
                            : totalPages - 5,
                        onSkipAll: () async {
                          FocusScope.of(context).unfocus();
                          // ✅ Also call function if skipping
                          LoaderUtils.showLoader(context);
                          await processOnboardingAnswers(
                            context,
                            currentUserUid,
                            _questions,
                            _model,
                          );
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                          saveDefaultAnswers(_questions);
                          if (onboardingFromSettings == true) {
                            onboardingFromSettings == false;
                            //context.go('/settings-new');
                          }
                        },
                        showBack: true, // ✅ show back button
                        initialValue: qi.rawType == 'multi'
                            ? _multiValues[qi.id]
                            : qi.rawType == 'single_choice' ||
                                    qi.rawType == 'boolean'
                                ? _dropdownValues[qi.id]
                                : qi.rawType == 'date'
                                    ? _dateValues[qi.id]
                                    : _textControllers[qi.id]?.text,
                        onChanged: (value) {
                          if (qi.rawType == 'multi') {
                            _multiValues[qi.id] = List<String>.from(value);
                          } else if (qi.rawType == 'single_choice' ||
                              qi.rawType == 'boolean') {
                            _dropdownValues[qi.id] = value;
                          } else if (qi.rawType == 'date') {
                            _dateValues[qi.id] = value;
                          } else {
                            _textControllers[qi.originalQuestionId] ??=
                                TextEditingController();
                            _textControllers[qi.originalQuestionId]!.text =
                                value?.toString() ?? '';
                          }
                        },
                        onNext: adjustedIndex == _questions.length - 1
                            ? () async {
                                print(
                                    'adjusted index last page $adjustedIndex');
                                FocusScope.of(context).unfocus();
                                await processOnboardingAnswers(context,
                                    currentUserUid, _questions, _model);
                                await _saveAnswerForCurrentQuestion(qi);
                                onboardingFromSettings == false;
                                safeSetState(() {});
                              }
                            : () async {
                                print('adjusted index $adjustedIndex');
                                FocusScope.of(context).unfocus();
                                await _saveAnswerForCurrentQuestion(qi);
                                if (adjustedIndex < _questions.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                }
                              },
                        onBack: () {
                          FocusScope.of(context).unfocus();
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        onSkip: _currentIndex == totalPages - 1
                            ? () async {
                                FocusScope.of(context).unfocus();
                                await processOnboardingAnswers(context,
                                    currentUserUid, _questions, _model);
                                safeSetState(() {});
                              }
                            : () {
                                FocusScope.of(context).unfocus();
                                if (_currentIndex < totalPages - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                }
                              },
                      );
                    },
                  ),
                ])),
    );
  }

  final nowUtc = DateTime.now().toUtc();

  Future<void> insertIfMissing({
    required int questionId,
    int? optionId,
    String? answerText,
  }) async {
    final existing = await Supabase.instance.client
        .from('user_answers')
        .select('id')
        .eq('user_id', currentUserUid)
        .eq('question_id', questionId)
        .maybeSingle();

    if (existing == null) {
      await UserAnswersTable().insert({
        'user_id': currentUserUid,
        'question_id': questionId,
        'question_option_id': optionId,
        'answer_text': answerText,
        'linkedtoscreen': 'Onboarding',
        'createdon': supaSerialize<DateTime>(nowUtc),
        'createdby': currentUserUid,
        'lastmodifiedon': supaSerialize<DateTime>(nowUtc),
        'lastmodifiedby': currentUserUid,
      });
    }
  }

  Future<void> saveDefaultAnswers(List<_QuestionItem> questions) async {
    try {
      // Loop through all questions dynamically
      for (final qi in _questions) {
        final qText = qi.text.toLowerCase();
        final qType = qi.rawType.toLowerCase();
        final qid = qi.originalQuestionId;

        // Skip if already answered
        final existing = await Supabase.instance.client
            .from('user_answers')
            .select('id')
            .eq('user_id', currentUserUid)
            .eq('question_id', qid)
            .maybeSingle();

        if (existing != null) continue;

        String? answerText;
        int? optionId;

        // 🎯 Set dynamic defaults based on question type/text
        if (qText.contains('gender')) {
          // dropdown → default Female if not answered
          optionId = qi.originalOptionIdByText['Female'] ??
              qi.originalOptionIdByText.values.firstOrNull;
          answerText = 'Female';
        } else if (qText.contains('ethnicity')) {
          // dropdown → default Caucasian
          optionId = qi.originalOptionIdByText['Caucasian'] ??
              qi.originalOptionIdByText.values.firstOrNull;
          answerText = 'Caucasian';
        } else if (qText.contains('primary goal')) {
          // dropdown → default General Health
          optionId = qi.originalOptionIdByText['General Health'] ??
              qi.originalOptionIdByText.values.firstOrNull;
          answerText = 'General Health';
        } else if (qText.contains('secondary goal')) {
          // dropdown → default Healthy Aging
          optionId = qi.originalOptionIdByText['Healthy Aging'] ??
              qi.originalOptionIdByText.values.firstOrNull;
          answerText = 'Healthy Aging';
        } else if (qText.contains('birthdate') || qType == 'date') {
          // date picker → today
          final birthdateToSave = FFAppState().birthday;
          answerText = supaSerialize<DateTime>(birthdateToSave);
        } else if (qText.contains('weigh')) {
          // text → 65 kg
          answerText = '65 kg';
        } else if (qText.contains('height')) {
          // text → 170 cm
          answerText = '170 cm';
        }

        // only insert if we found a meaningful default
        if (optionId != null || (answerText != null && answerText.isNotEmpty)) {
          await insertIfMissing(
            questionId: qid,
            optionId: optionId,
            answerText: answerText,
          );
        } else {
          print('⚠️ Skipped Q$qid - no default mapping found.');
        }
      }
    } catch (e, st) {
      print('❌ Error inserting dynamic default user_answers: $e');
      print(st);
    }
  }

  // Add this method in your state class or create a separate service file

  Future<void> handleDataOwnershipConsent(
      BuildContext context, String userId) async {
    try {
      final supabase = Supabase.instance.client;

      // Step 1: Get or create party record
      print('👤 Checking/Creating party record for user $userId');

      var partyResult = await supabase
          .from('party')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      String partyId;

      if (partyResult == null) {
        // Create new party record
        print('👤 Creating new party record for user $userId');
        final insertedParty = await supabase
            .from('party')
            .insert({
              'type': 1,
              'user_id': userId,
              'created_at': DateTime.now().toUtc().toIso8601String(),
            })
            .select('id')
            .single();

        partyId = insertedParty['id'] as String;
        print('✅ Party created with ID: $partyId');
      } else {
        partyId = partyResult['id'] as String;
        print('✅ Party already exists with ID: $partyId');
      }

      // Step 2: Fetch all agreements with status 3
      print('📜 Fetching agreements with status 3');
      final agreements =
          await supabase.from('agreement').select('id').eq('status', 3);

      if (agreements.isEmpty) {
        print('⚠️ No agreements found with status 3');
        return;
      }

      print('📜 Found ${agreements.length} agreements');

      // Step 3: Process each agreement
      for (var agreement in agreements) {
        final agreementId = agreement['id'] as String;
        print('🔍 Processing agreement: $agreementId');

        // Check if approval already exists
        final existingApproval = await supabase
            .from('agreement_approval')
            .select('id, status, is_active')
            .eq('agreement_id', agreementId)
            .eq('party_id', partyId)
            .maybeSingle();

        final now = DateTime.now().toUtc().toIso8601String();

        if (existingApproval != null) {
          // Entry exists - check status and is_active
          final status = existingApproval['status'] as int;
          // final isActive = existingApproval['is_active'] as bool?;

          if (status == 3) {
            // Update to make it active
            print('🔄 Updating existing approval to active');
            await supabase.from('agreement_approval').update({
              'is_active': true,
              'status': 1,
              'active_since': now,
              'occurred_at': now,
            }).eq('id', existingApproval['id']);

            print('✅ Approval updated for agreement: $agreementId');
          } else {
            print(
                '✅ Approval already in correct state for agreement: $agreementId');
          }
        } else {
          // Create new approval entry
          print('➕ Creating new approval entry');
          await supabase.from('agreement_approval').insert({
            'agreement_id': agreementId,
            'party_id': partyId,
            'status': 1,
            'is_active': true,
            'active_since': now,
            'occurred_at': now,
          });

          print('✅ New approval created for agreement: $agreementId');
        }
      }

      print('🎉 Data ownership consent processed successfully');
    } catch (e) {
      print('❌ Error handling data ownership consent: $e');
      rethrow;
    }
  }

  Future<void> deleteUserAccount(BuildContext context, String userEmail) async {
    try {
      final supabase = Supabase.instance.client;

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // Delete user
      await supabase.rpc(
        'delete_user_by_email',
        params: {'p_email': userEmail},
      );

      print('🗑️ User deleted successfully');

      // Close dialog BEFORE signOut
      navigatorKey.currentState?.pop();

      // Small delay to let dialog close
      await Future.delayed(const Duration(milliseconds: 700));

      // Sign out
      await supabase.auth.signOut();

      // Navigate using navigatorKey
      // navigatorKey.currentState?.pushNamedAndRemoveUntil(
      //   '/login',
      //   (route) => false,
      // );

      context.pushNamed(
        LoginWidget.routeName,
        extra: <String, dynamic>{
          kTransitionInfoKey: TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.fade,
          ),
        },
      );

      print('✅ Navigation completed');
    } catch (e) {
      print("❌ Error deleting user: $e");

      // Close dialog
      navigatorKey.currentState?.pop();

      // Show error
      final context = navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error deleting user: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> handleMedicalConsent(
      BuildContext context, String userId, bool isConsent) async {
    try {
      final supabase = Supabase.instance.client;

      if (isConsent) {
        // User consented - update users table
        print('✅ User consented to medical disclaimer');
        await supabase.from('users').update({
          'is_medical_consent': true,
        }).eq('id', userId);

        print('✅ Medical consent updated in database');
      } else {
        // User declined - delete account
        print('❌ User declined medical consent - deleting account');
        await deleteUserAccount(context, currentUserEmail);
        // No need to return - navigation happens in deleteUserAccount
      }
    } catch (e) {
      print('❌ Error handling medical consent: $e');
      rethrow;
    }
  }
}
