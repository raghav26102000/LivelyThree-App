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

import 'package:supabase_flutter/supabase_flutter.dart';

class EmailChangePinWidget extends StatefulWidget {
  final String oldEmail; // kept for signature, not used for token lookup
  final String newEmail;
  final String userId;
  final int pinLength;
  final double? width;
  final double? height;
  final void Function(String verificationStatus) onVerificationResult;

  const EmailChangePinWidget({
    Key? key,
    required this.oldEmail,
    required this.newEmail,
    required this.userId,
    this.pinLength = 6,
    this.width,
    this.height,
    required this.onVerificationResult,
  }) : super(key: key);

  @override
  State<EmailChangePinWidget> createState() => _EmailChangePinWidgetState();
}

class _EmailChangePinWidgetState extends State<EmailChangePinWidget> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  bool _isVerifying = false;
  String _errorMessage = "";
  String _successMessage = "";

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.pinLength, (_) => TextEditingController());
    _focusNodes = List.generate(widget.pinLength, (_) => FocusNode());

    for (var i = 0; i < widget.pinLength; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
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
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredPin => _controllers.map((c) => c.text).join();
  bool get _isPinComplete => _controllers.every((c) => c.text.isNotEmpty);

  Future<void> _verifyPin() async {
    if (!_isPinComplete) {
      return;
    }
    setState(() {
      _isVerifying = true;
      _errorMessage = "";
      _successMessage = "";
    });

    final supabase = Supabase.instance.client;

    try {
      print("DEBUG: Checking for matching token in email_change_tokens.");
      final tokenResponse = await supabase
          .from('email_change_tokens')
          .select('token')
          .eq('user_id', widget.userId)
          .maybeSingle();

      if (tokenResponse == null) {
        print("DEBUG: No matching token found. PIN expired or incorrect.");
        setState(() {
          _isVerifying = false;
          _errorMessage = "Invalid or expired verification PIN.";
        });
        return;
      }

      final storedPin = tokenResponse['token'];
      print("DEBUG: Stored PIN: $storedPin, Entered PIN: $_enteredPin");

      if (storedPin != _enteredPin) {
        print("DEBUG: PIN mismatch. Resetting fields.");
        setState(() {
          _isVerifying = false;
          _errorMessage = "Invalid verification PIN.";
          for (var c in _controllers) c.clear();
          _focusNodes[0].requestFocus();
        });
        return;
      }

      // Call the RPC that updates both auth.users and public.users
      print("DEBUG: Updating email in auth.users & public.users via RPC.");
      final rpcResult = await supabase.rpc(
        'update_user_email_both',
        params: {
          '_user_id': widget.userId,
          '_new_email': widget.newEmail,
        },
      );

      print("DEBUG: rpcResult => $rpcResult");

      if (rpcResult is Map<String, dynamic>) {
        if (rpcResult['success'] == true) {
          print("DEBUG: Email update successful (no automated email).");

          setState(() {
            _isVerifying = false;
            _successMessage = "Email changed successfully!";
          });

          // Delete the used token now that we've succeeded
          print("DEBUG: Deleting used email change token.");
          await supabase
              .from('email_change_tokens')
              .delete()
              .eq('user_id', widget.userId);

          // Wait 2 seconds to show success, then callback (no pop here)
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            widget.onVerificationResult("verified");
          }
          return;
        } else {
          // Show any error from the function
          print("DEBUG: RPC indicated error => ${rpcResult['error']}");
          setState(() {
            _isVerifying = false;
            _errorMessage = rpcResult['error'] ?? "Unknown error via RPC.";
          });
          return;
        }
      } else {
        // Unexpected format or null
        print("DEBUG: Unexpected or null RPC result.");
        setState(() {
          _isVerifying = false;
          _errorMessage = "Failed to update. Invalid RPC response.";
        });
        return;
      }
    } catch (e) {
      print("DEBUG: Exception in _verifyPin => $e");
      setState(() {
        _isVerifying = false;
        _errorMessage = "System error. Please try again later.";
      });
    }
  }

  Widget _buildPinField(int index) {
    return SizedBox(
      width: 40,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white.withOpacity(0.4),
          border: OutlineInputBorder(
            borderSide: _controllers[index].text.isNotEmpty
                ? const BorderSide(color: Colors.blueAccent, width: 2)
                : const BorderSide(color: Colors.transparent, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            if (index < widget.pinLength - 1) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus();
            }
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          if (_isPinComplete && !_isVerifying) {
            _verifyPin();
          }

          setState(() {}); // updates border color if digit typed/erased
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
      height: widget.height ?? 150,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.pinLength,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildPinField(index),
              ),
            ),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else if (_successMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _successMessage,
                style: const TextStyle(color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
