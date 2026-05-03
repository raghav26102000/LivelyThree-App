import 'package:flutter/material.dart';
import 'package:the_lively_three/custom_code/widgets/silver_button_widget.dart';
import 'package:the_lively_three/custom_code/widgets/switchButton.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_lively_three/pages/explore/explore_widget.dart';
import 'package:the_lively_three/pages/homepage/homepage_widget.dart';
import 'package:the_lively_three/pages/settings_new/settings_new_widget.dart';
import 'package:the_lively_three/utils/loader_util.dart';
import '/backend/supabase/supabase.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class DataContractPage extends StatefulWidget {
  final VoidCallback? onBackButton;
  final String fromPage;
  const DataContractPage(
      {super.key, this.onBackButton, this.fromPage = 'Settings'});
  static String routeName = 'DataContract';
  static String routePath = '/data-contract';

  @override
  State<DataContractPage> createState() => _DataContractPageState();
}

class _DataContractPageState extends State<DataContractPage> {
  bool showingDetailedPage = false;
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> agreements = [];
  Map<String, bool> approvalStatusCache = {}; // ✅ Cache approval status
  Map<String, Map<String, dynamic>?> approvalInfoCache =
      {}; // ✅ Cache approval info

  bool isLoading = true;
  String searchText = '';

  late String pageTitle;
  late String pageDesc;
  late List<String> whatYouShare;
  late List<String> whatYouReceive;
  late String purpose;
  late String duration;
  late String whoAsked;
  late bool status;
  String? currentAgreementId;
  late bool comingSoon;
  String? userTimezone;
  String? partyId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchAgreements();
    await _checkAndResetExpiredGracePeriods();
    userTimezone = await _getUserTimezone();
    partyId = await _getPartyIdForUser();
  }

  void _navigateBack() {
    print('_navigateBack clicked!');
    switch (widget.fromPage) {
      case 'Settings':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SettingsNewPage()),
        );
        break;

      case 'Home':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomepageWidget()),
        );
        break;

      case 'explore':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ExplorePage()),
        );
        break;

      default:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SettingsNewPage()),
        );
    }
  }

  /// ✅ OPTIMIZED: Fetch all approval statuses in one go
  Future<void> _fetchAllApprovalStatuses() async {
    try {
      final partyId = await _getPartyIdForUser();
      if (partyId == null) return;

      final agreementIds = agreements.map((a) => a['id'].toString()).toList();

      final response = await supabase
          .from('agreement_approval')
          .select(
              'agreement_id, status, deactivated_at, willing_to_participate')
          .eq('party_id', partyId)
          .filter('agreement_id', 'in', agreementIds);

      // Build cache maps
      for (final row in (response as List)) {
        final map = Map<String, dynamic>.from(row);
        final agreementId = map['agreement_id'].toString();
        approvalStatusCache[agreementId] = map['status'] == 1;
        approvalInfoCache[agreementId] = {
          'status': map['status'],
          'deactivated_at': map['deactivated_at'],
          'willing_to_participate': map['willing_to_participate']
        };
      }
    } catch (e) {
      debugPrint('Error fetching approval statuses: $e');
    }
  }

  Future<void> _fetchAgreements() async {
    try {
      final agreementResponse = await supabase.from('agreement').select('''
          id,
          name,
          purpose,
          description,
          status,
          jurisdiction,
          legal_basis,
          created_at,
          party_b_id,
          willing_to_participate,
          party_b:party_b_id (app_name, org_name)
        ''').filter('status', 'in', [3, 7]).order('status', ascending: true);

      final lookupResponse = await supabase
          .from('codelkup')
          .select('keycode, key1')
          .eq('lkcode', 'agreement_status');

      final Map<int, String> statusLookup = {};
      for (final item in (lookupResponse as List)) {
        final map = Map<String, dynamic>.from(item as Map);
        final code = int.tryParse(map['keycode'].toString());
        if (code != null) statusLookup[code] = map['key1']?.toString() ?? '';
      }

      final rows = List<Map<String, dynamic>>.from(
        (agreementResponse as List).map((r) {
          final agreement = Map<String, dynamic>.from(r as Map);
          final int statusValue = agreement['status'] ?? 0;
          agreement['status_name'] =
              statusLookup[statusValue] ?? 'Unknown Status';
          final partyData = agreement['party_b'] as Map?;
          final appName = partyData?['app_name']?.toString();
          final orgName = partyData?['org_name']?.toString();
          agreement['who_ask'] = (appName != null && appName.isNotEmpty)
              ? appName
              : (orgName ?? 'Internal');
          return agreement;
        }),
      );

      setState(() {
        agreements = rows;
      });

      // ✅ Fetch all approval statuses after agreements load
      await _fetchAllApprovalStatuses();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching agreements: $e');
      setState(() => isLoading = false);
    }
  }

  Future<Map<String, List<String>>> _fetchAgreementElements(
      String agreementId) async {
    try {
      final aseResponse = await supabase
          .from('agreement_selected_element')
          .select('mapped_element_id')
          .eq('agreement_id', agreementId);

      if (aseResponse == null || (aseResponse as List).isEmpty) {
        return {'share': [], 'receive': []};
      }

      final mappedIds = (aseResponse as List)
          .map((e) => e['mapped_element_id'])
          .whereType<String>()
          .toList();

      final demResponse = await supabase
          .from('data_element_mapping')
          .select('inbound_element_id, outbound_element_id')
          .filter('id', 'in', mappedIds)
          .eq('status', 1);

      if (demResponse == null || (demResponse as List).isEmpty) {
        return {'share': [], 'receive': []};
      }

      final inboundIds = <String>{};
      final outboundIds = <String>{};

      for (final row in (demResponse as List)) {
        final map = Map<String, dynamic>.from(row as Map);
        if (map['inbound_element_id'] != null) {
          inboundIds.add(map['inbound_element_id'].toString());
        }
        if (map['outbound_element_id'] != null) {
          outboundIds.add(map['outbound_element_id'].toString());
        }
      }

      final dataElementResponse = await supabase
          .from('data_element')
          .select('id, name')
          .filter('id', 'in', [...inboundIds, ...outboundIds]);

      final dataElementMap = {
        for (final el in (dataElementResponse as List))
          el['id'].toString(): el['name'].toString()
      };

      final inboundNames =
          inboundIds.map((id) => dataElementMap[id] ?? 'Unnamed').toList();
      final outboundNames =
          outboundIds.map((id) => dataElementMap[id] ?? 'Unnamed').toList();

      return {
        'share': inboundNames,
        'receive': outboundNames,
      };
    } catch (e) {
      debugPrint('Error fetching agreement elements: $e');
      return {'share': [], 'receive': []};
    }
  }

  Future<String?> _getPartyIdForUser() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final response = await supabase
          .from('party')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      return response?['id']?.toString();
    } catch (e) {
      debugPrint('Error fetching party id: $e');
      return null;
    }
  }

  bool _getComingSoonToggle(String agreementId) {
    final info = approvalInfoCache[agreementId];
    if (info == null) return false;
    return info['willing_to_participate'] == true;
  }

  /// ✅ OPTIMIZED: Use cache first
  bool _getCachedApprovalStatus(String agreementId) {
    return approvalStatusCache[agreementId] ?? false;
  }

  /// ✅ OPTIMIZED: Use cache first
  Map<String, dynamic>? _getCachedApprovalInfo(String agreementId) {
    return approvalInfoCache[agreementId];
  }

  DateTime _nextMondayMidnight() {
    final now = DateTime.now();
    int daysUntilMonday = (DateTime.monday - now.weekday) % 7;
    if (daysUntilMonday == 0) daysUntilMonday = 7;
    final nextMonday = now.add(Duration(days: daysUntilMonday));
    return DateTime(nextMonday.year, nextMonday.month, nextMonday.day);
  }

  Future<void> _updateComingSoon(String agreementId, bool value) async {
    final partyId = await _getPartyIdForUser();
    if (partyId == null) return;

    final existing = await supabase
        .from('agreement_approval')
        .select('id')
        .eq('agreement_id', agreementId)
        .eq('party_id', partyId)
        .maybeSingle();

    if (existing == null) {
      await supabase.from('agreement_approval').insert({
        'agreement_id': agreementId,
        'party_id': partyId,
        'willing_to_participate': value,
        'status': 0,
        'is_active': true,
        'active_since': DateTime.now().toIso8601String(),
      });
    } else {
      await supabase
          .from('agreement_approval')
          .update({'willing_to_participate': value}).eq('id', existing['id']);
    }

    // update local cache
    setState(() {
      approvalInfoCache[agreementId] = {
        ...?approvalInfoCache[agreementId],
        'willing_to_participate': value,
      };
    });
  }

  Future<void> _updateAgreementApproval(
    String agreementId,
    bool newStatus,
  ) async {
    setState(() {
      approvalStatusCache[agreementId] = newStatus;
    });

    try {
      final partyId = await _getPartyIdForUser();
      if (partyId == null) return;

      // ✅ Simply get current UTC time and add 5 minutes
      DateTime nowUtc = DateTime.now().toUtc();
      DateTime deactivateAtUtc = nowUtc.add(const Duration(minutes: 5));

      debugPrint('🕐 Setting deactivation:');
      debugPrint('   Current UTC: $nowUtc');
      debugPrint('   Deactivate at UTC: $deactivateAtUtc');

      final existing = await supabase
          .from('agreement_approval')
          .select('id, status')
          .eq('agreement_id', agreementId)
          .eq('party_id', partyId)
          .maybeSingle();

      if (newStatus) {
        if (existing == null) {
          await supabase.from('agreement_approval').insert({
            'agreement_id': agreementId,
            'party_id': partyId,
            'status': 1,
            'is_active': true,
            'active_since': nowUtc.toIso8601String(),
          });
        } else {
          await supabase.from('agreement_approval').update({
            'status': 1,
            'is_active': true,
            'active_since': nowUtc.toIso8601String(),
            'deactivated_at': null,
          }).eq('id', existing['id']);
        }
      } else {
        if (existing != null) {
          await supabase.from('agreement_approval').update({
            'status': 3,
            'is_active': false,
            'deactivated_at':
                deactivateAtUtc.toIso8601String(), // ✅ Store UTC time
          }).eq('id', existing['id']);
        }
      }

      setState(() {
        approvalInfoCache[agreementId] = {
          'status': newStatus ? 1 : 3,
          'deactivated_at':
              newStatus ? null : deactivateAtUtc.toIso8601String(),
        };
      });
    } catch (e) {
      debugPrint('Error updating agreement approval: $e');
      setState(() {
        approvalStatusCache[agreementId] = !newStatus;
      });
    }
  }

// ✅ Update format function to convert UTC to user's timezone for display
  String _formatDeactivationDate(String? dt) {
    if (dt == null) return '';
    final dateUtc = DateTime.tryParse(dt);
    if (dateUtc == null) return '';

    // ✅ Convert UTC to user's local timezone for display
    final userTz = userTimezone;
    final dateLocal = _convertToUserTimezone(dateUtc.toUtc(), userTz);

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final d = dateLocal.day.toString().padLeft(2, '0');
    final m = months[dateLocal.month - 1];
    final y = dateLocal.year;

    final hour = (dateLocal.hour == 0 || dateLocal.hour == 12)
        ? 12
        : dateLocal.hour % 12;
    final minute = dateLocal.minute.toString().padLeft(2, '0');
    final suffix = dateLocal.hour >= 12 ? 'PM' : 'AM';

    return "$d-$m-$y ${hour.toString().padLeft(2, '0')}:$minute $suffix";
  }

  Future<String?> _getUserTimezone() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final response = await supabase
          .from('users')
          .select('timezone')
          .eq('id', user.id)
          .maybeSingle();

      return response?['timezone']?.toString();
    } catch (e) {
      debugPrint('Error fetching user timezone: $e');
      return null;
    }
  }

  DateTime _convertToUserTimezone(DateTime utcTime, String? timezone) {
    try {
      tzdata.initializeTimeZones();
      if (timezone == null) return utcTime.toLocal();
      final location = tz.getLocation(timezone);
      final localTime = tz.TZDateTime.from(utcTime, location);
      return localTime;
    } catch (e) {
      debugPrint('Error converting time: $e');
      return utcTime.toLocal();
    }
  }

  // String _formatDeactivationDate(String? dt) {
  //   if (dt == null) return '';
  //   final date = DateTime.tryParse(dt);
  //   if (date == null) return '';

  //   // ✅ The stored date is already in user's timezone, so use it directly
  //   final months = [
  //     'Jan',
  //     'Feb',
  //     'Mar',
  //     'Apr',
  //     'May',
  //     'Jun',
  //     'Jul',
  //     'Aug',
  //     'Sep',
  //     'Oct',
  //     'Nov',
  //     'Dec'
  //   ];

  //   final d = date.day.toString().padLeft(2, '0');
  //   final m = months[date.month - 1];
  //   final y = date.year;

  //   final hour = (date.hour == 0 || date.hour == 12) ? 12 : date.hour % 12;
  //   final minute = date.minute.toString().padLeft(2, '0');
  //   final suffix = date.hour >= 12 ? 'PM' : 'AM';

  //   return "$d-$m-$y ${hour.toString().padLeft(2, '0')}:$minute $suffix";
  // }

  Future<void> _checkAndResetExpiredGracePeriods() async {
    try {
      final partyId = await _getPartyIdForUser();
      if (partyId == null) return;

      // ✅ Get current time
      final nowUtc = DateTime.now().toUtc();

      debugPrint('🕐 Current UTC time: $nowUtc');

      for (final agreementId in approvalInfoCache.keys) {
        final info = approvalInfoCache[agreementId];
        final deactivatedAtRaw = info?['deactivated_at'];

        if (deactivatedAtRaw != null) {
          // ✅ Parse the stored datetime
          final deactivatedAt = DateTime.tryParse(deactivatedAtRaw.toString());

          if (deactivatedAt != null) {
            // ✅ Convert stored time to UTC for fair comparison
            final deactivatedAtUtc = deactivatedAt.toUtc();

            debugPrint('📅 Agreement $agreementId:');
            debugPrint('   Deactivated at (raw): $deactivatedAtRaw');
            debugPrint('   Deactivated at (UTC): $deactivatedAtUtc');
            debugPrint('   Current UTC: $nowUtc');
            debugPrint('   Has expired: ${nowUtc.isAfter(deactivatedAtUtc)}');

            // ✅ Compare both times in UTC
            if (nowUtc.isAfter(deactivatedAtUtc) ||
                nowUtc.isAtSameMomentAs(deactivatedAtUtc)) {
              debugPrint(
                  '✅ Grace period expired for $agreementId - resetting...');

              await supabase
                  .from('agreement_approval')
                  .update({'deactivated_at': null})
                  .eq('agreement_id', agreementId)
                  .eq('party_id', partyId);

              setState(() {
                approvalInfoCache[agreementId] = {
                  ...?approvalInfoCache[agreementId],
                  'deactivated_at': null,
                };
              });

              debugPrint(
                  '✅ Successfully reset deactivated_at for $agreementId');
            } else {
              debugPrint('⏳ Grace period still active for $agreementId');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Failed to check/reset grace periods: $e');
    }
  }

  // String _formatDeactivationDate(String? dt) {
  //   if (dt == null) return '';
  //   final date = DateTime.tryParse(dt);
  //   if (date == null) return '';

  //   final months = [
  //     'Jan',
  //     'Feb',
  //     'Mar',
  //     'Apr',
  //     'May',
  //     'Jun',
  //     'Jul',
  //     'Aug',
  //     'Sep',
  //     'Oct',
  //     'Nov',
  //     'Dec'
  //   ];
  //   final d = date.day.toString().padLeft(2, '0');
  //   final m = months[date.month - 1];
  //   final y = date.year;
  //   final suffix = date.hour >= 12 ? 'PM' : 'AM';
  //   final hour = (date.hour == 0 || date.hour == 12) ? 12 : date.hour % 12;

  //   return "$d-$m-$y ${hour.toString().padLeft(2, '0')}:00 $suffix";
  // }

  void _switchDetailPage(bool value) {
    setState(() => showingDetailedPage = value);
  }

  void _openDetailPage(
    String title,
    String desc,
    List<String> youShare,
    List<String> youReceive,
    String purposes,
    String durations,
    String whoAsk,
    bool toggleStatus,
    String agreementId,
    bool isComingSoon,
  ) {
    setState(() {
      pageTitle = title;
      pageDesc = desc;
      whatYouShare = youShare;
      whatYouReceive = youReceive;
      purpose = purposes;
      duration = durations;
      whoAsked = whoAsk;
      status = toggleStatus;
      currentAgreementId = agreementId;
      comingSoon = isComingSoon;
      _switchDetailPage(true);
    });
  }

  void _hideDetailPage() {
    setState(() {
      pageTitle = '';
      pageDesc = '';
      whatYouShare = [];
      whatYouReceive = [];
      purpose = '';
      duration = '';
      whoAsked = '';
      status = false;
      _switchDetailPage(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: showingDetailedPage
                ? _buildDetailedPage(
                    agreementId: currentAgreementId ?? '',
                    theme: theme,
                    pageTitle: pageTitle,
                    pageDesc: pageDesc,
                    whatYouShare: whatYouShare,
                    whatYouReceive: whatYouReceive,
                    purpose: purpose,
                    duration: duration,
                    whoAsked: whoAsked,
                    status: status,
                    onBackButton: () {
                      setState(() {
                        searchText = '';
                      });
                      _hideDetailPage();
                    })
                : Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: SingleChildScrollView(
                      // ← Add this wrapper
                      child: Column(
                        spacing: 12,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: _navigateBack,
                                child: Icon(Icons.chevron_left,
                                    color: theme.primaryText),
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width - 64,
                                child: Text(
                                  'Data Transparency \n& Permissions',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 18),
                                    fontWeight: FontWeight.w700,
                                    color: theme.primaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            spacing: 12,
                            children: [
                              TextField(
                                controller: TextEditingController(
                                    text: searchText)
                                  ..selection = TextSelection.fromPosition(
                                      TextPosition(offset: searchText.length)),
                                style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 16)),
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: const Color(0xfff9f9f9),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 16),
                                      color: Colors.grey),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  prefixIcon: const Icon(Icons.search,
                                      size: 20, color: Colors.grey),
                                  prefixIconConstraints: const BoxConstraints(
                                      minWidth: 40, minHeight: 24),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (val) =>
                                    setState(() => searchText = val),
                              ),

                              // ✅ NO MORE FUTUREBUILDER - Use cached data
                              for (final agreement in agreements.where((a) =>
                                  (a['name']?.toString().toLowerCase() ?? '')
                                      .contains(searchText.toLowerCase())))
                                Builder(
                                  builder: (context) {
                                    final name =
                                        agreement['name']?.toString() ?? '';
                                    final statusName =
                                        agreement['status_name']?.toString() ??
                                            '';
                                    final agreementId =
                                        agreement['id'].toString();

                                    if (statusName == 'Coming Soon') {
                                      final bool willing =
                                          _getComingSoonToggle(agreementId);
                                      return _buildActionPermissionCard(
                                        agreementId: agreementId,
                                        onStatusChanged: (newValue) {
                                          setState(() {
                                            approvalInfoCache[agreementId] = {
                                              ...?approvalInfoCache[
                                                  agreementId],
                                              'willing_to_participate':
                                                  newValue,
                                            };
                                          });
                                        },
                                        permissionTilte: name,
                                        permissionDesc:
                                            agreement['description'] ?? 'N/A',
                                        permissionStatus: willing,
                                        whoAsk:
                                            agreement['who_ask']?.toString() ??
                                                'Internal',
                                        status: willing
                                            ? 'Willing to Participate'
                                            : 'Not Participating',
                                        seeDetails: () async {
                                          LoaderUtils.showLoader(context);
                                          final elementData =
                                              await _fetchAgreementElements(
                                                  agreementId);
                                          _openDetailPage(
                                            name,
                                            'The contract enables sharing of individual fiber and protein indicators...',
                                            elementData['share'] ?? [],
                                            elementData['receive'] ?? [],
                                            agreement['purpose'] ?? 'N/A',
                                            "Until opt-out",
                                            agreement['who_ask']?.toString() ??
                                                'Internal',
                                            willing,
                                            agreementId,
                                            true,
                                          );
                                          LoaderUtils.hideLoader(context);
                                        },
                                        switchColor: const Color(0xff4FA1FF),
                                        statusDesc: willing
                                            ? 'You have given permission for this upcoming feature to use your data.'
                                            : 'You are not participating in this upcoming feature yet.',
                                        chipColor: const Color(0xff4FA1FF),
                                        chipTextColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        chipStatus: agreement['status_name'],
                                        comingSoon: true,
                                      );
                                    }

                                    // ✅ Use cached data instead of FutureBuilder
                                    final isConsented =
                                        _getCachedApprovalStatus(agreementId);
                                    final approvalInfo =
                                        _getCachedApprovalInfo(agreementId);
                                    final deactivatedAt =
                                        approvalInfo?['deactivated_at'];

                                    String statusText;
                                    if (isConsented) {
                                      statusText = 'Consented';
                                    } else if (deactivatedAt != null) {
                                      statusText =
                                          'Opted Out (${_formatDeactivationDate(deactivatedAt)})';
                                    } else {
                                      statusText = 'Opted Out';
                                    }

                                    return _buildActionPermissionCard(
                                      agreementId: agreementId,
                                      permissionTilte: name.isNotEmpty
                                          ? name
                                          : 'Unnamed Agreement',
                                      permissionDesc:
                                          agreement['description'] ?? 'N/A',
                                      permissionStatus: isConsented,
                                      whoAsk:
                                          agreement['who_ask']?.toString() ??
                                              'Internal',
                                      status: statusText,
                                      seeDetails: () async {
                                        LoaderUtils.showLoader(context);
                                        final elementData =
                                            await _fetchAgreementElements(
                                                agreementId);
                                        final currentApproval =
                                            _getCachedApprovalStatus(
                                                agreementId);

                                        _openDetailPage(
                                            name,
                                            'The contract enables sharing of individual fiber and protein indicators in exchange for community fiber and protein daily and weekly indicators and how they benchmark against official recommendations.',
                                            elementData['share'] ?? [],
                                            elementData['receive'] ?? [],
                                            agreement['purpose'] ?? 'N/A',
                                            "Until opt-out",
                                            agreement['who_ask']?.toString() ??
                                                'Internal',
                                            currentApproval,
                                            agreementId,
                                            false);
                                        LoaderUtils.hideLoader(context);
                                      },
                                      statusDesc: (agreement['status'] == 3)
                                          ? 'You have consented to share your weekly "Color Gaps" and "Consistency Score".'
                                          : 'Your data sharing for this agreement is opted out.',
                                      chipColor: (agreement['status'] == 3)
                                          ? const Color(0xffbababa)
                                          : const Color(0xfff28b82),
                                      chipStatus: agreement['status_name'],
                                      chipTextColor: const Color(0xffffffff),
                                      comingSoon: false,
                                      onStatusChanged: (newValue) {},
                                    );
                                  },
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
          )),
    );
  }

  Widget _buildDetailedPage({
    required theme,
    required String agreementId,
    required String pageTitle,
    required String pageDesc,
    required List<String> whatYouShare,
    required List<String> whatYouReceive,
    required String purpose,
    required String duration,
    required String whoAsked,
    required bool status,
    required VoidCallback onBackButton,
  }) {
    return StatefulBuilder(
      builder: (context, setDetailState) {
        // ✅ Always read from cache for current state
        final toggleValue = comingSoon
            ? _getComingSoonToggle(agreementId)
            : _getCachedApprovalStatus(agreementId);

        final approvalInfo = _getCachedApprovalInfo(agreementId);
        final deactivatedAt = approvalInfo?['deactivated_at'];

        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: SingleChildScrollView(
            child: Column(
              spacing: 40,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: onBackButton,
                      child: Icon(Icons.chevron_left, color: theme.primaryText),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width - 64,
                      child: Text(
                        pageTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(size: 18),
                          fontWeight: FontWeight.w700,
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pageDesc,
                      style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 12),
                        height: 1.67,
                        color: FlutterFlowTheme.of(context).textGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InfoBox(title: "What You Share:", items: whatYouShare),
                    const SizedBox(height: 12),
                    _InfoBox(title: "What You Receive:", items: whatYouReceive),
                    const SizedBox(height: 12),
                    _SimpleInfoBox(title: "Purpose:", description: purpose),
                    const SizedBox(height: 8),
                    _SimpleInfoBox(title: "Duration:", description: duration),
                    const SizedBox(height: 8),
                    _SimpleInfoBox(title: "Who Asked:", description: whoAsked),
                    const SizedBox(height: 30),
                    Row(
                      spacing: 14,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SwitchButton(
                          value: toggleValue,
                          switchOnColor: comingSoon
                              ? const Color(0xff4FA1FF)
                              : (toggleValue
                                  ? const Color(0xffa8e6cf) // Green when ON
                                  : (deactivatedAt != null
                                      ? const Color(
                                          0xffffa726) // Orange when OFF with grace period
                                      : const Color(
                                          0xfff28b82))), // Red when OFF completely
                          onChanged: (value) async {
                            if (comingSoon) {
                              await _updateComingSoon(agreementId, value);

                              setState(() {});
                              setDetailState(() {}); // Refresh detail page
                            } else {
                              await _updateAgreementApproval(
                                  agreementId, value);
                              setDetailState(
                                  () {}); // Refresh detail page with new cache values
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  comingSoon
                                      ? (value
                                          ? "🚀 You’re now participating in this upcoming feature."
                                          : "🛑 You’ve opted out of participating in this upcoming feature.")
                                      : (value
                                          ? "✅ Consent activated successfully."
                                          : "❌ Consent withdrawn — effective next Monday."),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: value
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                          height: 30,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (comingSoon) ...[
                                Text(
                                  'Would you like to participate?',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 16),
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
                                  ),
                                ),
                                Text(
                                  toggleValue
                                      ? 'You allowed your data to be included in testing the upcoming feature.'
                                      : 'You have chosen not to participate in this upcoming feature.',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                    height: 1.5,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  toggleValue
                                      ? 'Data Sharing Enabled'
                                      : (deactivatedAt != null
                                          ? 'Data Sharing Turned Off (${_formatDeactivationDate(deactivatedAt)})'
                                          : 'Data Sharing Turned Off'),
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 16),
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
                                  ),
                                ),
                                Text(
                                  toggleValue
                                      ? 'You allowed this feature to share certain data as described in your settings.'
                                      : (deactivatedAt != null
                                          ? 'You have withdrawn consent. Data sharing will stop after next Monday 12:00 AM.'
                                          : 'You have chosen not to share your data. You can turn this back on anytime in your settings.'),
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                    height: 1.5,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionPermissionCard({
    required String agreementId,
    required String permissionTilte,
    required String permissionDesc,
    required bool permissionStatus,
    required String whoAsk,
    required String status,
    required String statusDesc,
    required Color chipColor,
    required String chipStatus,
    required VoidCallback seeDetails,
    required bool comingSoon,
    required Function(bool) onStatusChanged,
    Color chipTextColor = const Color(0xfff9f9f9),
    Color switchColor = const Color(0xffa8e6cf),
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        // ✅ Always read current state from cache
        bool toggleValue = comingSoon
            ? _getComingSoonToggle(agreementId)
            : _getCachedApprovalStatus(agreementId);

        // ✅ Use cached data
        final approvalInfo = _getCachedApprovalInfo(agreementId);
        final deactivatedAtRaw = approvalInfo?['deactivated_at'];

        DateTime? deactivatedAt;
        if (deactivatedAtRaw != null) {
          try {
            deactivatedAt = DateTime.parse(deactivatedAtRaw.toString());
          } catch (e) {
            debugPrint('⚠️ Error parsing deactivatedAt: $e');
          }
        }

        // ✅ Compare in UTC
        final nowUtc = DateTime.now().toUtc();

        bool isGracePeriod = false;
        if (deactivatedAt != null) {
          final deactivatedAtUtc = deactivatedAt.toUtc();
          // final parsed = DateTime.parse(deactivatedAtRaw.toString());
          // final localDeactivated = parsed; // already stored in user’s local tz
          isGracePeriod = deactivatedAtUtc.isAfter(nowUtc);
          debugPrint('🔍 Grace period check for $agreementId:');
          debugPrint('   Now (UTC): $nowUtc');
          debugPrint('   Deactivated at (UTC): $deactivatedAtUtc');
          debugPrint('   Is grace period active: $isGracePeriod');
        }

        // Auto-cleanup expired deactivations
        if (deactivatedAt != null && !isGracePeriod) {
          Future.microtask(() async {
            try {
              await supabase
                  .from('agreement_approval')
                  .update({'deactivated_at': null})
                  .eq('agreement_id', agreementId)
                  .eq('party_id', partyId as Object);

              this.setState(() {
                approvalInfoCache[agreementId] = {
                  ...?approvalInfoCache[agreementId],
                  'deactivated_at': null,
                };
              });
              debugPrint('✅ Grace period expired — reset for $agreementId');
            } catch (e) {
              debugPrint('❌ Failed to reset deactivated_at: $e');
            }
          });
        }

        // ✅ FIXED: Switch color based on CURRENT toggle state
        Color currentSwitchColor;
        if (comingSoon) {
          currentSwitchColor = const Color(0xFF4FA1FF); // Blue
        } else if (toggleValue) {
          currentSwitchColor = const Color(0xffa8e6cf); // 🟢 Green - Consented
        } else if (!toggleValue && isGracePeriod) {
          currentSwitchColor =
              const Color(0xffffa726); // 🟠 Orange - Grace period
        } else {
          currentSwitchColor = const Color(0xfff28b82); // 🔴 Red - Opted out
        }

        // ✅ Status text logic
        String finalStatusText;
        if (comingSoon) {
          finalStatusText =
              toggleValue ? 'Willing to Participate' : 'Not Participating';
        } else if (toggleValue) {
          finalStatusText = 'Consented';
        } else if (!toggleValue && isGracePeriod) {
          final formatted = _formatDeactivationDate(deactivatedAtRaw);
          finalStatusText = 'Opted Out ($formatted)';
        } else {
          finalStatusText = 'Opted Out';
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xfff9f9f9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xffe1e1e1),
              width: 1,
              style: BorderStyle.solid,
            ),
            boxShadow: toggleValue
                ? [
                    const BoxShadow(
                      color: Color.fromRGBO(249, 249, 249, 1),
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                    ),
                    const BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      offset: Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                permissionTilte,
                style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 16),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: FlutterFlowTheme.of(context).textGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                permissionDesc,
                style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 12),
                  height: 1.5,
                  color: FlutterFlowTheme.of(context).textGrey,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: 'Who asked: ',
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    fontWeight: FontWeight.w700,
                    color: FlutterFlowTheme.of(context).textGrey,
                  ),
                  children: [
                    TextSpan(
                      text: whoAsk,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      offset: Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: comingSoon
                        ? const Color(0xFFFFD54F)
                        : currentSwitchColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SwitchButton(
                      value: toggleValue,
                      switchOnColor: currentSwitchColor,
                      switchOffColor: const Color(0xfff28b82),
                      height: 30,
                      onChanged: (value) async {
                        try {
                          if (comingSoon) {
                            await _updateComingSoon(agreementId, value);
                          } else {
                            await _updateAgreementApproval(agreementId, value);
                          }

                          // ✅ Refresh the card UI
                          setState(() {});
                          onStatusChanged(value);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                comingSoon
                                    ? (value
                                        ? "✅ You're now willing to participate in this upcoming feature."
                                        : "❌ You've withdrawn from participating in this feature.")
                                    : (value
                                        ? "✅ Consent activated successfully."
                                        : "❌ Consent withdrawn — effective next Monday."),
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: value
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } catch (e) {
                          debugPrint('❌ ERROR updating toggle: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "❌ Failed to update. Please try again.",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red.shade600,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                          // ✅ Refresh to show correct state
                          setState(() {});
                        }
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            finalStatusText,
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              color: FlutterFlowTheme.of(context).textGrey,
                            ),
                          ),
                          Text(
                            statusDesc,
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              height: 1.5,
                              color: FlutterFlowTheme.of(context).textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: chipColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      chipStatus,
                      style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 12),
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: chipTextColor,
                      ),
                    ),
                  ),
                  SilverButton(
                    buttonFunction: seeDetails,
                    buttonTitle: 'See Details',
                    iconPlacement: 'right',
                    hasIcon: true,
                    borderRadius: 99,
                    iconWidget: const Icon(Icons.chevron_right, size: 16),
                    paddingHorizontal: 12,
                    paddingVertical: 4,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final List<String> items;
  const _InfoBox({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff9f9f9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffececec)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: FlutterFlowTheme.adjustScale(size: 13),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Color(0xffececec),
            width: double.infinity,
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                spacing: 4,
                children: [
                  for (final item in items)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 20),
                              height: 1,
                              color: FlutterFlowTheme.of(context).textGrey,
                              fontWeight: FontWeight.w700),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: FlutterFlowTheme.adjustScale(size: 13),
                              color: FlutterFlowTheme.of(context).textGrey,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              )),
        ],
      ),
    );
  }
}

class _SimpleInfoBox extends StatelessWidget {
  final String title;
  final String description;
  const _SimpleInfoBox({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xfff9f9f9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffececec)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: FlutterFlowTheme.adjustScale(size: 13),
                ),
              )),
          Container(
            height: 1,
            color: Color(0xffececec),
            width: double.infinity,
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: FlutterFlowTheme.adjustScale(size: 13),
                  height: 1.3,
                ),
              )),
        ],
      ),
    );
  }
}
