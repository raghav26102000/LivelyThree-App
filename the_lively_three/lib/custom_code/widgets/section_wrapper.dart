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

import 'package:flutter/widgets.dart';

/// In-file registry so we can look up each section’s GlobalKey
class GlobalKeyRegistry {
  static final Map<String, GlobalKey> _keys = {};
  static GlobalKey registerKey(String name) =>
      _keys.putIfAbsent(name, () => GlobalKey());
  static GlobalKey? getKey(String name) => _keys[name];
}

class SectionWrapper extends StatefulWidget {
  const SectionWrapper({
    super.key,
    this.width,
    this.height,
    required this.sectionName,
    required this.childBuilder, // note renamed
  });

  final double? width;
  final double? height;

  /// Unique ID (e.g. "redSection")
  final String sectionName;

  /// Use Widget Builder as the input type in FF UI
  final WidgetBuilder childBuilder;

  @override
  State<SectionWrapper> createState() => _SectionWrapperState();
}

class _SectionWrapperState extends State<SectionWrapper> {
  @override
  Widget build(BuildContext context) {
    // get or create the GlobalKey
    final key = GlobalKeyRegistry.registerKey(widget.sectionName);

    // build the actual child subtree
    final child = widget.childBuilder(context);

    // wrap it so we can scroll to it later
    return Container(
      key: key,
      width: widget.width,
      height: widget.height,
      child: child,
    );
  }
}
