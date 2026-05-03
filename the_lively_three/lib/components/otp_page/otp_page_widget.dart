import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.onVerify, this.codeLength = 6});

  final int codeLength;
  final void Function(String code) onVerify;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(widget.codeLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field automatically
      if (index < widget.codeLength - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    } else {
      // Move back if deleting
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }

    final code = _controllers.map((c) => c.text).join();
    if (code.length == widget.codeLength) {
      widget.onVerify(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: List.generate(widget.codeLength, (i) {
        return SizedBox(
          width: 40,
          height: 40,
          child: TextField(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            maxLength: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 24),
                fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            cursorColor: FlutterFlowTheme.of(context).primaryText,
            decoration: InputDecoration(
                counterText: "", // removes bottom counter
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primaryText,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.all(0)),
            onChanged: (val) => _onChanged(val, i),
          ),
        );
      }),
    );
  }
}
