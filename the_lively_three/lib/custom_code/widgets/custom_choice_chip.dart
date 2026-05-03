// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// ──────────────────────────────────────────────────────────────
//  CustomChoiceChip  – responsive via String "small|medium|large"
//  • Baseline box driven by paddings/fonts (no gap inflation).
//  • “Small” factor lowered to 0 .80 and baseline numbers shrunk
//    (font 12/14, paddings 6/2, icon 18, list width 45).
// ──────────────────────────────────────────────────────────────
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

Color _darken(Color c, double amount) => Color.lerp(c, Colors.black, amount)!;

class CustomChoiceChip extends StatefulWidget {
  const CustomChoiceChip({
    Key? key,
    this.width,
    this.height,
    required this.plantName,
    required this.colorTextUntapped,
    required this.colorTextTapped,
    required this.colorChoiceChipUntapped,
    required this.colorChoiceChipTapped,
    required this.shadowColorUntapped,
    required this.shadowColorTapped,
    required this.color,
    required this.borderColorUntapped,
    required this.borderColorTapped,
    required this.listAreaTapped,
    required this.listAreaUntapped,
    required this.weekdayNumber,
    required this.week,
    required this.year,
    required this.userId,
    this.onRightSideTap,
    this.screenSize = 'medium', // "small" | "medium" | "large"
  }) : super(key: key);

  final double? width;
  final double? height;
  final String plantName;
  final Color colorTextUntapped;
  final Color colorTextTapped;
  final Color colorChoiceChipUntapped;
  final Color colorChoiceChipTapped;
  final Color shadowColorUntapped;
  final Color shadowColorTapped;
  final Color listAreaTapped;
  final Color listAreaUntapped;
  final String color;
  final Color borderColorUntapped;
  final Color borderColorTapped;
  final int weekdayNumber; // 1‥7
  final int week; // calendar week
  final int year;
  final String userId;
  final Function()? onRightSideTap;
  final String screenSize; // "small" | "medium" | "large"

  @override
  State<CustomChoiceChip> createState() => _CustomChoiceChipState();
}

class _CustomChoiceChipState extends State<CustomChoiceChip> {
  // ───────── DB & state ─────────
  final supabase = Supabase.instance.client;
  double _portionSum = 0.0;
  double _portionInGrams = 0.0;
  bool _hasPortions = false;

  bool _isFlashing = false;
  bool _isPressed = false;
  Timer? _delay;

  // animation
  final _flashDur = const Duration(milliseconds: 250);
  final _pressDur = const Duration(milliseconds: 140);

  // responsive factors
  late final double _f; // 0.80 | 1.0 | 1.15
  late final double _font12;
  late final double _font14;
  late final double _padH;
  late final double _padV;
  late final double _icon;
  late final double _listW;

  @override
  void initState() {
    super.initState();

    // choose factor
    switch (widget.screenSize.toLowerCase()) {
      case 'small':
        _f = 0.80;
        break; // ↓ a bit smaller
      case 'large':
        _f = 1.15;
        break;
      default:
        _f = 1.0; // medium
    }

    // baseline numbers (already smaller)
    _font12 = 12 * _f;
    _font14 = 14 * _f;
    _padH = 6 * _f;
    _padV = 2 * _f;
    _icon = 18 * _f;
    _listW = 45 * _f;

    _fetchInitialData();
  }

  @override
  void dispose() {
    _delay?.cancel();
    super.dispose();
  }

  // ───────────────────────── UI ─────────────────────────
  @override
  Widget build(BuildContext context) {
    final active = _hasPortions;

    final bg = _isFlashing
        ? Color.lerp(
            active
                ? _darken(widget.colorChoiceChipTapped, .1)
                : widget.colorChoiceChipUntapped,
            Colors.white,
            .75)!
        : active
            ? _darken(widget.colorChoiceChipTapped, .1)
            : widget.colorChoiceChipUntapped;

    final border = _isFlashing
        ? Colors.blueAccent
        : active
            ? widget.borderColorTapped
            : widget.borderColorUntapped;

    final txt = _isFlashing
        ? Colors.blueAccent
        : active
            ? _darken(widget.colorTextTapped, .1)
            : widget.colorTextUntapped;

    return AnimatedScale(
      // baseline 1.0 => no extra gaps; pop anim only
      scale: _isPressed ? 1.05 : 1.0,
      duration: _pressDur,
      curve: Curves.easeInOut,
      child: AnimatedContainer(
        duration: _pressDur,
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: _padH, vertical: _padV),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24 * _f),
          border: Border.all(color: border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: active
                  ? widget.shadowColorTapped.withOpacity(.9)
                  : widget.shadowColorUntapped.withOpacity(.4),
              blurRadius: active ? 5 : 2.5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // left tap
            GestureDetector(
              onTap: _onLeftTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.plantName,
                      style: TextStyle(
                        fontSize: _font14,
                        fontWeight:
                            active ? FontWeight.bold : FontWeight.normal,
                        color: txt,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '(${_portionInGrams.toStringAsFixed(0)}g) ',
                            style: TextStyle(fontSize: _font12, color: txt),
                          ),
                          TextSpan(
                            text: _portionSum % 1 == 0
                                ? _portionSum.toStringAsFixed(0)
                                : _portionSum.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: _font14,
                              fontWeight: FontWeight.bold,
                              color: txt.withOpacity(.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8 * _f),
            // right tap
            GestureDetector(
              onTap: widget.onRightSideTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: _listW,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      active ? widget.listAreaTapped : widget.listAreaUntapped,
                  borderRadius: BorderRadius.circular(24 * _f),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 8 * _f,
                  vertical: 6 * _f,
                ),
                child: Icon(Icons.list_alt,
                    size: _icon, color: txt.withOpacity(.8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── interaction / DB logic (unchanged) ─────────
  void _onLeftTap() async {
    setState(() => _isFlashing = _isPressed = true);

    final newSum = await _incrementPortion();
    if (!mounted) return;
    setState(() {
      _portionSum = newSum;
      _hasPortions = newSum > 0;
    });

    _delay?.cancel();
    _delay = Timer(_flashDur + _pressDur, () {
      if (!mounted) return;
      setState(() {
        _isFlashing = false;
        _isPressed = false;
      });
    });
  }

  Future<void> _fetchInitialData() async {
    try {
      final data = await supabase
          .from('view_weeklyselectedplant')
          .select('portionsum, portionsize')
          .eq('id_user', widget.userId)
          .eq('calendarweek', widget.week)
          .eq('calendaryear', widget.year)
          .eq('plantname', widget.plantName)
          .single();

      if (!mounted) return;
      if (data is Map) {
        setState(() {
          _portionSum = (data['portionsum'] as num?)?.toDouble() ?? 0.0;
          _portionInGrams =
              ((data['portionsize'] as num?)?.toDouble() ?? 1.0) * 100.0;
          _hasPortions = _portionSum > 0;
        });
      }
    } catch (e) {
      debugPrint('fetch error: $e');
    }
  }

  Future<double> _incrementPortion() async {
    try {
      const cols = [
        'monportion',
        'tueportion',
        'wedportion',
        'thuportion',
        'friportion',
        'satportion',
        'sunportion'
      ];
      final col = cols[(widget.weekdayNumber - 1).clamp(0, 6)];

      final row = await supabase
          .from('weeklyselectedplant')
          .select(col)
          .eq('id_user', widget.userId)
          .eq('week', widget.week)
          .eq('year', widget.year)
          .eq('plantname', widget.plantName)
          .single();

      final current =
          (row is Map && row[col] != null) ? (row[col] as num).toDouble() : 0.0;

      await supabase
          .from('weeklyselectedplant')
          .update({col: current + 1})
          .eq('id_user', widget.userId)
          .eq('week', widget.week)
          .eq('year', widget.year)
          .eq('plantname', widget.plantName);

      final rpc = await supabase.rpc('recalc_portionsum', params: {
        '_user_id': widget.userId,
        '_calendarweek': widget.week,
        '_calendaryear': widget.year,
        '_plantname': widget.plantName,
      });

      if (rpc is Map && rpc.containsKey('portionsum')) {
        return (rpc['portionsum'] as num).toDouble();
      }
    } catch (e) {
      debugPrint('increment error: $e');
    }
    return _portionSum;
  }
}
