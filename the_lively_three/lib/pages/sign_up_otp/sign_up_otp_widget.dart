import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:the_lively_three/components/bottom_navbar/bottom_navbar_widget.dart';
import 'package:the_lively_three/components/otp_page/otp_page_widget.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/pages/consistency/consistency_widget.dart';
import 'package:the_lively_three/pages/sign_up/sign_up_widget.dart';
import 'package:the_lively_three/pages/sign_up_otp/sign_up_otp_model.dart';
import '/l10n/app_localizations.dart';

class SignUpOtpWidget extends StatefulWidget {
  const SignUpOtpWidget({super.key});
  static String routeName = 'SignUpOtp';
  static String routePath = '/SignUpOtp';
  @override
  State<SignUpOtpWidget> createState() => _SignUpOtpWidgetState();
}

class _SignUpOtpWidgetState extends State<SignUpOtpWidget> {
  late SignUpOtpModel _model;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpOtpModel());
  }

  @override
  void dispose() {
    _model.dispose(); // important to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: const Color(0xfff8f8f8),
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          "Confirmation",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpWidget(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(12),
            height: MediaQuery.sizeOf(context).height - 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                SizedBox(
                    width: 250,
                    child: Text(
                        'Please enter the code we have send to gulfemerdogan@gmail.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: FlutterFlowTheme.of(context).primaryText,
                            height: 1.75))),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    spacing: 40,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Enter the email code',
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                                height: 40,
                                child: OtpPage(
                                  onVerify: (code) {
                                    print("Entered code: $code");
                                  },
                                ))
                          ]),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                            text: "Resending after:\n",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 2,
                            ),
                            children: [
                              TextSpan(
                                text: '01:23',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildSignUpOtpOption(
    BuildContext context, {
    IconData? icon,
    Widget? iconWidget,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: iconWidget ??
          Icon(
            icon,
            size: 24,
            color: Colors.black87,
          ),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
