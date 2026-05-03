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

class PasswordPinVerificationWidget extends StatefulWidget {
  const PasswordPinVerificationWidget({
    Key? key,
    required this.email,
    this.pinLength = 6,
    this.width,
    this.height,
    required this.onVerificationResult,
  }) : super(key: key);

  /// The email address for which the user requested a password reset
  final String email;

  /// The total length of the PIN (default: 6)
  final int pinLength;

  /// Optional widget dimensions (not always used)
  final double? width;
  final double? height;

  /// Callback invoked once verification succeeds (or fails, if you decide to pass a fail status)
  final void Function(String verificationStatus) onVerificationResult;

  @override
  State<PasswordPinVerificationWidget> createState() =>
      _PasswordPinVerificationWidgetState();
}

class _PasswordPinVerificationWidgetState
    extends State<PasswordPinVerificationWidget> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  bool _isVerifying = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();

    // Initialize text controllers and focus nodes for each PIN digit
    _controllers =
        List.generate(widget.pinLength, (_) => TextEditingController());
    _focusNodes = List.generate(widget.pinLength, (_) => FocusNode());

    // Optional: ensure we select the text when we focus a pin field
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

  /// Returns the combined PIN digits the user has entered
  String get _enteredPin => _controllers.map((c) => c.text).join();

  /// Checks if all digits are entered (no empty fields)
  bool get _isPinComplete => _controllers.every((c) => c.text.isNotEmpty);

  /// Verifies the PIN by calling the SECURITY DEFINER function in Supabase
  Future<void> _verifyPin() async {
    if (!_isPinComplete) {
      // PIN is incomplete; optionally show an error or do nothing
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = "";
    });

    final supabase = Supabase.instance.client;
    final pin = _enteredPin;
    print(
        "DEBUG: Starting PIN verification for email: ${widget.email}, PIN: $pin");

    try {
      // 1. Call the verify_password_reset_pin function
      final response = await supabase.rpc('verify_password_reset_pin', params: {
        '_email': widget.email,
        '_pin': pin,
      });

      print("DEBUG: Response from verify_password_reset_pin: $response");

      // 2. Check success/failure in the returned JSON
      if (response == null || response['success'] == null) {
        // Something unexpected
        setState(() {
          _isVerifying = false;
          _errorMessage = "System error. Please try again later.";
        });
        return;
      }

      if (response['success'] == true) {
        // PIN verified successfully
        setState(() {
          _isVerifying = false;
        });

        // Optional: you can delete the token here in code if you prefer,
        // but typically the function or the next step might handle that.

        // 3. Invoke the callback to signal success
        widget.onVerificationResult("verified");
      } else {
        // The function returned success=false, so we have an error message
        setState(() {
          _isVerifying = false;
          _errorMessage =
              response['error'] ?? "Invalid or expired PIN. Please try again.";
        });

        // Optionally clear the PIN fields
        for (var c in _controllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } catch (e) {
      print("DEBUG: Exception during PIN verification: $e");
      setState(() {
        _isVerifying = false;
        _errorMessage = "System Error. Please try again later.";
      });
    }
  }

  /// Builds a single digit input field for the PIN
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
          fillColor: Colors.white.withOpacity(0.5),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          // Move focus to next field if user typed a digit
          if (value.length == 1) {
            if (index < widget.pinLength - 1) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus();
            }
          }
          // If user clears the field, jump back to the previous field
          else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          // Optional: auto-verify if all fields are filled
          if (_isPinComplete && !_isVerifying) {
            _verifyPin();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // You can wrap this in a container if you need specific width/height
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // PIN input row
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

        // Error message
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),

        // Optional: a manual "Verify" button instead of auto-verify
        // so the user can double-check their entry
        ElevatedButton(
          onPressed: _isVerifying ? null : _verifyPin,
          child: _isVerifying
              ? const CircularProgressIndicator()
              : const Text("Verify PIN"),
        ),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
