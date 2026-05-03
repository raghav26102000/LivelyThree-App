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

import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
import '/auth/supabase_auth/auth_util.dart';

class SignupPinVerificationWidget extends StatefulWidget {
  const SignupPinVerificationWidget({
    Key? key,
    required this.email,
    required this.password,
    this.pinLength = 6,
    this.width, // total width the parent gives
    this.height, // total height the parent gives (optional)
    required this.onVerificationResult,
  }) : super(key: key);

  final String email;
  final String password;
  final int pinLength;
  final double? width;
  final double? height;
  final void Function(bool verificationStatus) onVerificationResult;

  @override
  State<SignupPinVerificationWidget> createState() =>
      _SignupPinVerificationWidgetState();
}

class _SignupPinVerificationWidgetState
    extends State<SignupPinVerificationWidget> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  bool _isVerifying = false;
  String _errorMessage = "";

  // ------------------------------------------ lifecycle
  @override
  void initState() {
    super.initState();
    print(
        'DEBUG initState: email=${widget.email}, pinLength=${widget.pinLength}');
    _controllers =
        List.generate(widget.pinLength, (_) => TextEditingController());
    _focusNodes = List.generate(widget.pinLength, (_) => FocusNode());
    for (int i = 0; i < widget.pinLength; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          print('DEBUG focus gained on field $i');
          _controllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[i].text.length,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    print('DEBUG dispose: cleaning up controllers and focus nodes');
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  // ------------------------------------------ helpers
  String get _enteredPin {
    final pin = _controllers.map((c) => c.text).join();
    print('DEBUG entered PIN: $pin');
    return pin;
  }

  bool get _isPinComplete {
    final complete = _controllers.every((c) => c.text.isNotEmpty);
    print('DEBUG isPinComplete: $complete');
    return complete;
  }

  Future<void> _verifyPin() async {
    print('DEBUG _verifyPin called: isVerifying=$_isVerifying');
    if (!_isPinComplete || _isVerifying) {
      print('DEBUG _verifyPin aborted: incomplete or already verifying');
      return;
    }
    setState(() {
      _isVerifying = true;
      _errorMessage = "";
    });
    print('DEBUG verifyPin start: email=${widget.email}, pin=$_enteredPin');

    final supabase = Supabase.instance.client;
    print('DEBUG currentSession before RPC: ${supabase.auth.currentSession}');

    try {
      // RPC verification
      print('DEBUG calling RPC verify_signup_token');
      final dbResp = await supabase.rpc('verify_signup_token', params: {
        '_email': widget.email,
        '_pin_code': _enteredPin,
      });
      print('DEBUG RPC response: ${dbResp.toString()}');
      if (dbResp == null || dbResp['success'] != true) {
        final err = dbResp?['error'] ?? 'Invalid or expired verification PIN.';
        print('DEBUG RPC failure: $err');
        setState(() {
          _isVerifying = false;
          _errorMessage = err;
        });
        for (final c in _controllers) c.clear();
        _focusNodes.first.requestFocus();
        return;
      }
      // Auth signUp
      suppressAuthNavigation = true;
      print('Otp flag updated = $suppressAuthNavigation');
      final cleanEmail = widget.email.trim().toLowerCase();
      print('DEBUG: email="$cleanEmail", length=${cleanEmail.length}');
      print('DEBUG RPC success, calling supabase.auth.signUp');
      final authRes = await supabase.auth
          .signUp(email: cleanEmail, password: widget.password);

      //final authRes = await supabase.auth.signUp(email: widget.email, password: widget.password);
      print('DEBUG signUp response: $authRes');
      print('DEBUG currentUser: ${supabase.auth.currentUser}');
      print('DEBUG currentSession: ${supabase.auth.currentSession}');
      if (authRes.user == null) {
        print('DEBUG signUp failed, user is null');
        setState(() {
          _isVerifying = false;
          _errorMessage = 'Failed to create user account.';
        });
        return;
      }
      // Insert into users
      print('DEBUG inserting public.users for id=${authRes.user!.id}');
      final insertRes = await supabase.from('users').insert({
        'id': authRes.user!.id,
        'email': widget.email,
        'email_verified': true,
        'country': 'Undefined',
      });
      
      print('DEBUG users insert response: ${insertRes.toString()}');
      setState(() => _isVerifying = false);
      print('DEBUG verification succeeded, invoking callback');
      widget.onVerificationResult(true);
    } catch (e) {
      print('DEBUG exception during verification: ${e.toString()}');
      setState(() {
        _isVerifying = false;
        _errorMessage = 'System error. Please try again later.';
      });
    }
  }

  // ------------------------------------------ digit box UI
  Widget _digitBox(int i, double w, double h) => SizedBox(
        width: w,
        height: h,
        child: TextField(
          expands: true,
          maxLines: null,
          controller: _controllers[i],
          focusNode: _focusNodes[i],
          keyboardType: TextInputType.number,
          maxLength: 1,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          scrollPadding: EdgeInsets.zero,
          style: TextStyle(fontSize: w * 0.7),
          decoration: InputDecoration(
            counterText: "",
            isDense: true,
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            border: const OutlineInputBorder(),
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (v) {
            print('DEBUG field $i changed to "$v"');
            if (v.length == 1) {
              print('DEBUG field $i complete, moving focus');
              if (i < widget.pinLength - 1) {
                _focusNodes[i + 1].requestFocus();
              } else {
                _focusNodes[i].unfocus();
              }
            } else if (v.isEmpty && i > 0) {
              print('DEBUG field $i cleared, moving back focus');
              _focusNodes[i - 1].requestFocus();
            }
            if (_isPinComplete) {
              print('DEBUG PIN complete, calling _verifyPin');
              _verifyPin();
            }
          },
        ),
      );

  // ------------------------------------------ layout
  @override
  Widget build(BuildContext context) {
    print('DEBUG build: width=${widget.width}, height=${widget.height}');
    const double sidePad = 4, gap = 8, ratio = 2;
    final errHeight = (Theme.of(context).textTheme.bodySmall?.fontSize ?? 12) *
            MediaQuery.of(context).textScaleFactor +
        12;
    final double outerW = widget.width ?? MediaQuery.of(context).size.width;
    final double outerH = widget.height ?? MediaQuery.of(context).size.height;
    print(
        'DEBUG layout dims outerW=$outerW, outerH=$outerH, errHeight=$errHeight');
    final double usableW = outerW - 2 * sidePad;
    final double boxW =
        (usableW - (widget.pinLength - 1) * gap) / widget.pinLength;
    double boxH = boxW * ratio;
    if (outerH.isFinite && boxH + errHeight > outerH) {
      print('DEBUG adjusting boxH from $boxH to fit height');
      boxH = outerH - errHeight;
    }
    print('DEBUG calculated boxW=$boxW, boxH=$boxH');
    final row = List.generate(
        widget.pinLength,
        (i) => Padding(
            padding:
                EdgeInsets.only(right: i == widget.pinLength - 1 ? 0 : gap),
            child: _digitBox(i, boxW, boxH)));
    return SizedBox(
      width: outerW,
      height: outerH,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: sidePad),
            child: Row(mainAxisSize: MainAxisSize.min, children: row),
          ),
          SizedBox(
            height: errHeight,
            child: _errorMessage.isEmpty
                ? null
                : Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
