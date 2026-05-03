import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_lively_three/components/portion_size_modifier/portion_size_modifier_widget.dart';
import 'package:the_lively_three/custom_code/widgets/f_f_wheel_picker.dart'
    as custom_widgets;
import 'package:the_lively_three/pages/plant_profile/plant_profile_widget.dart';
import 'package:the_lively_three/utils/consumption_service.dart';
import 'package:the_lively_three/utils/user_action_audit_service.dart';

import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeeklyItemCard extends StatefulWidget {
  final String title; // plant name
  final int portionSize; // e.g., "150 g"
  final int weeklyTotal; // initial weekly total to show
  final Color primaryColor;
  final Color bgColor;
  final int plantId;
  final String userId;
  final int weekdayNumber;
  final int week;
  final int year;
  final bool canModify;
  final bool showMainMacro;
  final bool showIcon;
  final bool boldTitle;
  final bool hideAddIcon;
  final String? colorTag;
  final int blueprintId;
  final int dietarySource;
  final String categoryIcon;
  final String actionIcon;
  final String? uom;
  final String? displayName;
  final String? calledFrom;
  final bool isConsumedToday;
  final IconData modifierIcon;
  final int? originalConsumption;
  final void Function(String plantname, String colorTag, double deltaPortions)?
      onPortionAdded;
  final VoidCallback? onActionButton;
  final bool isModificationMode; // Add this new parameter
  final VoidCallback? onConsumptionModified; // Add callback for refresh
  final void Function(double space)? onNeedBottomSpace;

  const WeeklyItemCard({
    super.key,
    required this.title,
    required this.portionSize,
    required this.weeklyTotal,
    required this.primaryColor,
    this.bgColor = const Color(0xffffffff),
    required this.plantId,
    required this.userId,
    required this.weekdayNumber,
    required this.week,
    required this.year,
    required this.canModify,
    this.showMainMacro = false,
    this.hideAddIcon = false,
    this.showIcon = true,
    this.boldTitle = true,
    this.modifierIcon = Icons.add,
    required this.blueprintId,
    required this.dietarySource,
    required this.categoryIcon,
    this.actionIcon = 'edit',
    this.colorTag,
    this.onPortionAdded,
    this.onActionButton,
    this.uom,
    this.displayName,
    this.originalConsumption,
    this.calledFrom = 'Plant_Selection',
    this.isConsumedToday = false,
    this.isModificationMode = false, // Default to false
    this.onConsumptionModified,
    this.onNeedBottomSpace,
  });

  @override
  State<WeeklyItemCard> createState() => _WeeklyItemCardState();
}

class _WeeklyItemCardState extends State<WeeklyItemCard> {
  final supabase = Supabase.instance.client;
  OverlayEntry? _overlayEntry;

  // Local UI state
  int _weeklyTotal = 0;
  bool _isPressed = false;
  bool _isFlashing = false;
  Timer? _delay;
  double _portionInGrams = 0.0;
  int colorCode = 1;
  // Flash/press animations timing (tweak if you like)
  final Duration _pressDur = const Duration(milliseconds: 120);
  final Duration _flashDur = const Duration(milliseconds: 180);
  List<String> _portionvalues = [];
  String _selectedValue = '';
  bool _isLoading = true;
  String _errorMessage = '';
  final _consumptionService = ConsumptionService();
  int _initialPortionSize = 0;

  // 🔥 FIXED: Initialize with widget.portionSize to show current value
  late int _selectedPortionSize;

  // Map FFAppState().currentDay -> per-day column name in weeklyselectedplant
  static const Map<String, String> _dayToColumn = {
    "Monday": "monportion",
    "Tuesday": "tueportion",
    "Wednesday": "wedportion",
    "Thursday": "thuportion",
    "Friday": "friportion",
    "Saturday": "satportion",
    "Sunday": "sunportion",
  };

  @override
  void initState() {
    super.initState();
    _weeklyTotal = widget.weeklyTotal;
    _selectedPortionSize = widget.portionSize;
    _initialPortionSize = widget.portionSize; // Store initial value
    _fetchInitialData();
  }

  @override
  void dispose() {
    _delay?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(WeeklyItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔥 FIX: Update local state when widget props change
    if (oldWidget.weeklyTotal != widget.weeklyTotal) {
      if (mounted) {
        setState(() {
          _weeklyTotal = widget.weeklyTotal;
        });
      }
    }

    // 🔥 FIX: Trigger rebuild if isConsumedToday changes
    if (oldWidget.isConsumedToday != widget.isConsumedToday) {
      if (mounted) {
        setState(() {
          // Background color will update through _getBackgroundColor()
        });
      }
    }
  }

  Color _getBackgroundColor() {
    // 🔥 FIXED: Use widget.weeklyTotal directly instead of stale _weeklyTotal state
    if (widget.weeklyTotal == 0) return widget.bgColor;

    // 🔥 FIXED: Different opacity based on whether consumed today
    double maxFactor;
    if (widget.isConsumedToday) {
      maxFactor = 0.5; // Full intensity for today's consumption
    } else {
      maxFactor = 0.15; // Lighter for week consumption only
    }

    // 🔥 FIXED: weeklyTotal is in grams, scale it properly
    // For 500g weekly target (full week), use max opacity
    // Scale linearly: 0-500g maps to 0.05-maxFactor
    final double factor = (widget.weeklyTotal / 500.0).clamp(0.05, maxFactor);
    return Color.lerp(Colors.white, widget.primaryColor, factor)!;
  }

  _getModificationFunction() {
    switch (widget.calledFrom) {
      case 'Plant_Selection':
        return _onAddTap();
      case 'Portion_Modifier':
        return _handleModification();
      default:
        return _onAddTap();
    }
  }

  double _gramsFromLabelFallback() {
    if (_portionInGrams > 0) return _portionInGrams;
    final m =
        RegExp(r'(\d+(\.\d+)?)').firstMatch(widget.portionSize.toString());
    return m != null ? double.tryParse(m.group(1)!) ?? 0.0 : 0.0;
  }

  // === Supabase I/O ===
  Future<void> _fetchInitialData() async {
    // Pull latest total and portion size from your view (defensive sync)
    try {
      final data = await supabase
          .from('view_weeklyselectedplant')
          .select('portionsum, portionsize')
          .eq('id_user', widget.userId)
          .eq('calendarweek', FFAppState().calendarWeek)
          .eq('calendaryear', FFAppState().calendarYear)
          .eq('plantname', widget.title)
          .maybeSingle();

      if (!mounted) return;
      if (data is Map) {
        setState(() {
          _weeklyTotal =
              (data?['portionsum'] as num?)?.toInt() ?? widget.weeklyTotal;
          _portionInGrams =
              ((data?['portionsize'] as num?)?.toDouble() ?? 1.0) * 100.0;
        });
      }
    } catch (e) {
      debugPrint('WeeklyItemCard _fetchInitialData error: $e');
    }
  }

  // getColorKeyCode method use -1 as keyycode if color is null
  Future<int> getColorKeyCode(String? color) async {
    if (color == null || color.isEmpty) {
      return -1; // 🔥 CHANGED: Return -1 instead of null
    }

    try {
      final result = await supabase
          .from('codelkup')
          .select('keycode')
          .eq('lkcode', 'rainbow_color')
          .eq('key1', color)
          .eq('status', 1)
          .limit(1);

      if (result.isNotEmpty) {
        colorCode = result[0]['keycode'] as int;
        return colorCode;
      } else {
        return -1;
      }
    } catch (e) {
      print('Error fetching keycode for color $color: $e, returning -1');
      return -1;
    }
  }

// Modified _onAddTap method
  void _onAddTap() async {
    logAuditAction('Add consumption', 'weeklyItemcard');

    if (!mounted) return;
    if (widget.isModificationMode) return;

    int keyCode = await getColorKeyCode(widget.colorTag);

    setState(() {
      _isFlashing = _isPressed = true;
    });

    final grams = _selectedPortionSize.toDouble();

    try {
      final now = DateTime.now();
      final dateOnly = now.toIso8601String().split('T').first;
      int keyCode = await getColorKeyCode(widget.colorTag);

      await _consumptionService.insertDailyConsumption(
        userId: widget.userId,
        blueprintId: widget.blueprintId,
        portionToInsert: grams.toDouble(),
        quantity: 1,
        week: FFAppState().calendarWeek,
        year: FFAppState().calendarYear,
        consumptionOn: dateOnly,
        dayNumber: FFAppState().currentDayNumber,
        dietarySource: widget.dietarySource,
        plantId: widget.plantId,
        colorCode: keyCode, // Will be -1 if color was null
      );
    } catch (e) {
      print('Error inserting consumption: $e');
    }

    final newSum = await _incrementPortionAndRecalc();
    if (!mounted) return;

    setState(() {
      _weeklyTotal = newSum;
    });

    try {
      widget.onPortionAdded?.call(
          widget.title, widget.colorTag ?? '', _selectedPortionSize.toDouble());
    } catch (_) {}

    _delay?.cancel();
    _delay = Timer(_flashDur + _pressDur, () {
      if (!mounted) return;
      setState(() {
        _isFlashing = false;
        _isPressed = false;
      });
    });
  }

// Modified _handleModification method
  Future<void> _handleModification() async {
    if (_selectedPortionSize == _initialPortionSize) {
      print('No change in portion size');
      return;
    }

    try {
      int portionDifference = _selectedPortionSize - _initialPortionSize;
      int quantity = portionDifference > 0 ? 1 : -1;
      double portionToInsert = portionDifference.abs().toDouble();

      DateTime consumptionDate = _consumptionService.isoWeekDate(
        widget.year,
        widget.week,
        widget.weekdayNumber,
      );
      final dateOnly = consumptionDate.toIso8601String().split('T').first;

      // Get color code - will return -1 if null
      int keyCode = await getColorKeyCode(widget.colorTag);

      await _consumptionService.insertDailyConsumption(
        userId: widget.userId,
        blueprintId: widget.blueprintId,
        portionToInsert: portionToInsert,
        quantity: quantity,
        week: widget.week,
        year: widget.year,
        consumptionOn: dateOnly,
        dayNumber: widget.weekdayNumber,
        dietarySource: widget.dietarySource,
        plantId: widget.plantId,
        colorCode: keyCode, // Will be -1 if color was null
      );
      _initialPortionSize = _selectedPortionSize;
      widget.onConsumptionModified?.call();
    } catch (e) {
      print('Error modifying consumption: $e');
    }
  }

// Modified _handleDelete method
  Future<void> _handleDelete() async {
    try {
      final int amountToDelete = widget.originalConsumption!;

      // ✅ Prevent deletion if nothing was consumed
      if (amountToDelete <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'No consumption to remove for ${widget.title} on ${_getDayName()}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }
      DateTime consumptionDate = _consumptionService.isoWeekDate(
        widget.year,
        widget.week,
        widget.weekdayNumber,
      );
      final dateOnly = consumptionDate.toIso8601String().split('T').first;

      // Get color code - will return -1 if null
      int keyCode = await getColorKeyCode(widget.colorTag);

      await _consumptionService.insertDailyConsumption(
        userId: widget.userId,
        blueprintId: widget.blueprintId,
        portionToInsert: amountToDelete.toDouble(),
        quantity: -1,
        week: widget.week,
        year: widget.year,
        consumptionOn: dateOnly,
        dayNumber: widget.weekdayNumber,
        dietarySource: widget.dietarySource,
        plantId: widget.plantId,
        colorCode: keyCode, // Will be -1 if color was null
      );

      final newSum = await _incrementPortionAndRecalc();
      if (!mounted) return;

      setState(() {
        _weeklyTotal = newSum;
        _selectedPortionSize = widget.portionSize;
        _initialPortionSize = widget.portionSize;
      });

      widget.onConsumptionModified?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.title} removed from ${_getDayName()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error deleting consumption: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<int> _incrementPortionAndRecalc() async {
    try {
      final String currentDay = FFAppState().currentDay;
      final String? col = _dayToColumn[currentDay];

      final existingRow = await supabase
          .from('weeklyselectedplant')
          .select('$col, portionsize, color_keycode')
          .eq('id_user', widget.userId)
          .eq('week', FFAppState().calendarWeek)
          .eq('year', FFAppState().calendarYear)
          .eq('plantname', widget.title)
          .maybeSingle();

      if (existingRow == null) {
        int? colorKeyCode = await getColorKeyCode(widget.colorTag);
      }

      // rest of your logic...
    } catch (e) {
      debugPrint('🔥 [incrementPortionAndRecalc] Error: $e');
    }
    return _weeklyTotal;
  }

// Helper method to get day name
  String _getDayName() {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[widget.weekdayNumber - 1];
  }

  void logAuditAction(action, screenName) async {
    final auditService = UserActionAuditService(supabase);
    await auditService.logUserAction(
      userId: widget.userId,
      action: action,
      screenName: screenName,
      userData: {
        'plantId': widget.plantId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return AnimatedContainer(
      duration: _flashDur,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      height: 86,
      decoration: BoxDecoration(
        color: widget.isConsumedToday
            ? widget.primaryColor.withOpacity(0.5)
            : FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Section: Icon + Info
          Expanded(
            child: Row(
              children: [
                if (widget.showIcon)
                  GestureDetector(
                    onTap: () async {
                      final auditService = UserActionAuditService(
                          supabase); // Instantiate the audit service
                      await auditService.logUserAction(
                        userId: widget.userId, // User ID
                        action: 'tapped_plant_details', // Action being logged
                        screenName: 'plant selection', // Current screen name
                        userData: {
                          'plantId': widget.plantId,
                          'week': FFAppState().calendarWeek,
                          'year': FFAppState().calendarYear,
                        }, // Optional additional data
                      );
                      // Navigate to profile (unchanged)
                      context.pushNamed(
                        PlantProfileWidget.routeName,
                        extra: {
                          'userId': widget.userId,
                          'locId': widget.plantId,
                          'week': FFAppState().calendarWeek,
                          'year': FFAppState().calendarYear,
                          'categoryIcon': widget.categoryIcon,
                          'primaryColor': widget.primaryColor,
                        },
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color(0xfff6f6f6),
                      radius: 28,
                      child: widget.categoryIcon != ''
                          ?
                          // Image.asset(
                          //     'assets/icons/${widget.categoryIcon}.png',
                          //     width: 24,
                          //     height: 24,
                          //   )
                          SvgPicture.asset(
                              'assets/icons/${widget.categoryIcon}', // Use dynamic icon
                              width: 32,
                              height: 32,
                              colorFilter: ColorFilter.mode(
                                widget.primaryColor,
                                BlendMode.srcIn,
                              ),
                            )
                          : ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                widget.primaryColor,
                                BlendMode.srcIn,
                              ),
                              child: Image.asset(
                                'assets/images/LOGO.png',
                                width: 32,
                                height: 32,
                              ),
                            ),
                    ),
                  ),
                if (widget.showIcon) const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (widget.showMainMacro)
                        Container(
                          height: 16,
                          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                          decoration: BoxDecoration(
                            color: widget.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color: widget.primaryColor,
                                  size: 9,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  widget.displayName ?? 'Unknown',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 11,
                                    height: 1.2,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          fontWeight: widget.boldTitle
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: FlutterFlowTheme.adjustScale(
                              size: widget.showMainMacro ? 12 : 16),
                          color: !widget.canModify
                              ? FlutterFlowTheme.of(context)
                                  .primaryText
                                  .withOpacity(0.5)
                              : FlutterFlowTheme.of(context).primaryText,
                          height: widget.showMainMacro ? 1.65 : 1,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(
                                size: widget.showMainMacro ? 12 : 14),
                            height: 1.2,
                            color: !widget.canModify
                                ? FlutterFlowTheme.of(context)
                                    .primaryText
                                    .withOpacity(0.5)
                                : FlutterFlowTheme.of(context).primaryText,
                          ),
                          children: [
                            const TextSpan(text: 'Total: '),
                            TextSpan(
                              text: '${widget.weeklyTotal} ${widget.uom}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (widget.actionIcon == 'edit')
            Builder(
              builder: (context) => InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: !widget.canModify
                    ? null
                    : () async {
                        logAuditAction(
                            'Edit Consumption', 'portionsizemodifier');
                        await showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              // Simplified alignment - no need to resolve directionality
                              alignment: Alignment.center,
                              child: Builder(
                                builder: (builderContext) {
                                  return GestureDetector(
                                    onTap: () {
                                      try {
                                        FocusScope.of(builderContext).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      } catch (e) {
                                        print('Error unfocusing: $e');
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      }
                                    },
                                    child: SizedBox(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: PortionSizeModifierWidget(
                                          plantId: widget.plantId,
                                          userId: widget.userId,
                                          blueprintId: widget.blueprintId,
                                          primaryColor: widget.primaryColor,
                                          colorTag: widget.colorTag,
                                          uom: widget.uom,
                                          dietarySource: widget.dietarySource),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                        widget.onConsumptionModified?.call();
                      },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  child: FaIcon(
                    FontAwesomeIcons.penToSquare,
                    color: widget.primaryColor,
                    size: 12,
                  ),
                ),
              ),
            ),

          if (widget.actionIcon == 'delete')
            InkWell(
              onTap: !widget.canModify
                  ? null
                  : () async {
                      logAuditAction(
                          'delete consumption', 'portionsizemodifier');
                      await _handleDelete();
                    }, //widget.onActionButton,
              child: CircleAvatar(
                radius: 16,
                backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                child: FaIcon(
                  FontAwesomeIcons.trash,
                  color: !widget.canModify
                      ? widget.primaryColor.withOpacity(0.5)
                      : widget.primaryColor,
                  size: 12,
                ),
              ),
            ),
          SizedBox(
            width: 6,
          ),
          // Right Section: Buttons
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.weeklyTotal == 0
                        ? widget.primaryColor.withOpacity(0.15)
                        : widget.primaryColor.withOpacity(0.8),
                    border: Border.all(
                      color: widget.primaryColor.withOpacity(0.2),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTapDown: !widget.canModify
                            ? null
                            : (TapDownDetails details) {
                                final tapPosition = details.globalPosition;
                                _showCustomPopupAt(
                                    tapPosition, _selectedPortionSize);
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          height: 34,
                          width: 85,
                          decoration: BoxDecoration(
                            color: !widget.canModify
                                ? FlutterFlowTheme.of(context)
                                    .primaryBackground
                                    .withOpacity(0.5)
                                : FlutterFlowTheme.of(context)
                                    .primaryBackground,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Row(
                            spacing: 4,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_selectedPortionSize ${widget.uom}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 16),
                                  height: 0.813,
                                  fontWeight: FontWeight.w600,
                                  color: !widget.canModify
                                      ? widget.primaryColor.withOpacity(0.5)
                                      : widget.primaryColor,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.sortUp,
                                    color: !widget.canModify
                                        ? widget.primaryColor.withOpacity(0.5)
                                        : widget.primaryColor,
                                    size: 10,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.sortDown,
                                    color: !widget.canModify
                                        ? widget.primaryColor.withOpacity(0.5)
                                        : widget.primaryColor,
                                    size: 10,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),

                      // Show Save/Edit button based on modification mode
                      if (widget.isModificationMode)
                        Column(
                          children: [
                            InkWell(
                              onTap: !widget.canModify
                                  ? null
                                  : _getModificationFunction,
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: !widget.canModify
                                      ? LinearGradient(
                                          colors: widget.hideAddIcon
                                              ? [
                                                  Colors.transparent,
                                                  Colors.transparent
                                                ]
                                              : [
                                                  widget.primaryColor
                                                      .withOpacity(0.8),
                                                  widget.primaryColor
                                                ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )
                                      : LinearGradient(
                                          colors: widget.hideAddIcon
                                              ? [
                                                  Colors.transparent,
                                                  Colors.transparent
                                                ]
                                              : [
                                                  widget.primaryColor
                                                      .withOpacity(0.8),
                                                  widget.primaryColor
                                                ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                  border: Border.all(
                                    color: widget.primaryColor,
                                    width: 1.2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                padding: const EdgeInsets.all(6.7),
                                child: Icon(
                                  widget.modifierIcon,
                                  color: !widget.canModify
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.white,
                                  size: widget.hideAddIcon ? 0 : 14.67,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        // Original Add button for non-modification mode
                        Column(
                          children: [
                            InkWell(
                              onTap: _getModificationFunction,
                              borderRadius: BorderRadius.circular(25),
                              child: AnimatedContainer(
                                duration: _pressDur,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: widget.hideAddIcon
                                          ? [
                                              Colors.transparent,
                                              Colors.transparent
                                            ]
                                          : [
                                              widget.primaryColor
                                                  .withOpacity(0.8),
                                              widget.primaryColor
                                            ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    border: Border.all(
                                      color: widget.primaryColor,
                                      width: 1.2,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(6.7),
                                  child: Icon(
                                    widget.modifierIcon,
                                    color: Colors.white,
                                    size: widget.hideAddIcon ? 0 : 14.67,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _removePopup() {
    widget.onNeedBottomSpace?.call(0); // remove padding in parent

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showCustomPopupAt(Offset position, int portionsize) {
    final screenHeight = MediaQuery.of(context).size.height;

    final translatedTop = position.dy - 147;
    final overflow = (translatedTop + 294) - screenHeight;

    final double adjustedDy = overflow > 0 ? -132 - overflow - 10 : -132;

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Background tap to close
          Positioned(
            top: 0,
            child: GestureDetector(
                onTap: _removePopup,
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height +
                      MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom,
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: position.dy - 43,
                        width: MediaQuery.sizeOf(context).width,
                        color: Colors.black.withOpacity(0.38),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 12),
                        height: 86,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                      Container(
                        height: MediaQuery.sizeOf(context).height -
                            position.dy -
                            43,
                        width: MediaQuery.sizeOf(context).width,
                        color: Colors.black.withOpacity(0.38),
                      ),
                    ],
                  ),
                )),
          ),

          // The white popup
          Positioned(
            right: 7,
            top: position.dy,
            child: Transform.translate(
              offset: Offset(0, -147),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 141,
                  height: 292,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: custom_widgets.FFWheelPicker(
                    key: const ValueKey('weight_unit_picker'),
                    min: 5,
                    max: 200,
                    step: 5,
                    initialValue: portionsize,
                    width: 131,
                    suffix: widget.uom ?? ' g',
                    loadPortionSizesFromDB: true,
                    selectedChipColor: widget.primaryColor.withOpacity(0.2),
                    selectedTextColor: widget.primaryColor,
                    selectedFontSize: 22,
                    selectedItemBuilder: (value) {
                      return Container(
                        padding: const EdgeInsets.all(3),
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.weeklyTotal == 0
                              ? widget.primaryColor.withOpacity(0.15)
                              : widget.primaryColor.withOpacity(0.8),
                          border: Border.all(
                            color: widget.primaryColor.withOpacity(0.2),
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              height: 34,
                              width: 86,
                              decoration: BoxDecoration(
                                color: !widget.canModify
                                    ? FlutterFlowTheme.of(context)
                                        .primaryBackground
                                        .withOpacity(0.5)
                                    : FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Row(
                                spacing: 4,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$value',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      height: 1.2,
                                      fontWeight: FontWeight.w700,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  Text(
                                    ' ${widget.uom}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      height: 1.2,
                                      fontWeight: FontWeight.w700,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),

                            // Show Save/Edit button based on modification mode
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _getModificationFunction(); // call your function
                                    _removePopup(); // close dialog
                                  },
                                  borderRadius: BorderRadius.circular(25),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: !widget.canModify
                                          ? LinearGradient(
                                              colors: widget.hideAddIcon
                                                  ? [
                                                      Colors.transparent,
                                                      Colors.transparent
                                                    ]
                                                  : [
                                                      widget.primaryColor
                                                          .withOpacity(0.8),
                                                      widget.primaryColor
                                                    ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            )
                                          : LinearGradient(
                                              colors: widget.hideAddIcon
                                                  ? [
                                                      Colors.transparent,
                                                      Colors.transparent
                                                    ]
                                                  : [
                                                      widget.primaryColor
                                                          .withOpacity(0.8),
                                                      widget.primaryColor
                                                    ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                      border: Border.all(
                                        color: widget.primaryColor,
                                        width: 1.2,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(6.7),
                                    child: Icon(
                                      widget.modifierIcon,
                                      color: !widget.canModify
                                          ? Colors.white.withOpacity(0.5)
                                          : Colors.white,
                                      size: widget.hideAddIcon ? 0 : 14.67,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },

                    // 🔥 FIXED: Proper onTap implementation
                    onTap: (value) {
                      // Check if widget is still mounted before setState
                      if (!mounted) return;

                      // Handle tap on individual items - immediately select and close
                      int newValue;
                      if (value is String) {
                        newValue = int.tryParse(value) ?? _selectedPortionSize;
                      } else if (value is int) {
                        newValue = value;
                      } else {
                        newValue = _selectedPortionSize;
                      }

                      print("Selected portion size: $newValue");

                      // Update the selected portion size
                      setState(() {
                        _selectedPortionSize = newValue;
                      });

                      // Don't close dialog here - let the + button handle closing
                    },
                    // 🔥 OPTIONAL: Also handle onChanged for scroll selection
                    onChanged: (value) {
                      if (!mounted) return;

                      int newValue;
                      if (value is String) {
                        newValue = int.tryParse(value) ?? _selectedPortionSize;
                      } else if (value is int) {
                        newValue = value;
                      } else {
                        newValue = _selectedPortionSize;
                      }

                      // Update selection but don't close dialog (only for scrolling)
                      setState(() {
                        _selectedPortionSize = newValue;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    // 🔥 notify parent to add bottom padding if overflowed
    if (overflow > 0 && mounted) {
      widget.onNeedBottomSpace?.call(overflow + 20);
    }
  }
}

Future<List<String>> fetchPortionSizes() async {
  try {
    final response = await Supabase.instance.client
        .from('codelkup')
        .select('key1')
        .eq('lkcode', 'portionsize_value')
        .order('keycode', ascending: true);
    if (response != null && response.isNotEmpty) {
      return response
          .map<String>((item) => item['key1'].toString())
          .where((value) => value.isNotEmpty)
          .toList();
    }

    // Fallback values if database fetch fails
    return [
      '10',
      '20',
      '30',
      '40',
      '50',
      '60',
      '70',
      '80',
      '90',
      '100',
      '110',
      '120',
      '130',
      '140',
      '150'
    ];
  } catch (e) {
    print('Error fetching portion sizes: $e');
    // Return default values on error
    return [
      '10',
      '20',
      '30',
      '40',
      '50',
      '60',
      '70',
      '80',
      '90',
      '100',
      '110',
      '120',
      '130',
      '140',
      '150'
    ];
  }
}
