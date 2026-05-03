import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_lively_three/components/fluid_bg/setting_bg_widget.dart';
import 'package:the_lively_three/custom_code/widgets/silver_button_widget.dart';
import 'package:the_lively_three/custom_code/widgets/switchButton.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_widgets.dart';
import 'package:the_lively_three/pages/delete_account/delete_account_reason_widget.dart';
import 'package:the_lively_three/utils/loader_util.dart';
import '/backend/supabase/supabase.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({
    super.key,
  });
  static String routeName = 'DeleteAccount';
  static String routePath = '/delete-account';

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool showingDetailedPage = false;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // Set this to your app's background color
      statusBarIconBrightness: Brightness.dark, // For light icons in status bar
    ));
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: FlutterFlowTheme.of(context).textGrey,
            size: 24.0,
          ),
        ),
        centerTitle: true,
        titleSpacing: 16,
        title: Text(
          'Delete Account',
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).primary,
                fontSize: FlutterFlowTheme.adjustScale(size: 18.0),
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.0),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          const SettingsBG(),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(14),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: RichText(
                        text: TextSpan(
                          text:
                              'This will delete your personal data and your account from ',
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            height: 1.62,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: 'The Lively Three',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' forever.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 12, left: 10, right: 10),
                      margin: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Color.fromRGBO(230, 57, 73, 1)),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        spacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: const Icon(Icons.warning_amber,
                                color: Colors.white, size: 18),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: const Color.fromRGBO(255, 255, 255,
                                        1), // rgba(255, 255, 255, 1)
                                    offset: const Offset(0, 0), // x=0, y=0
                                    blurRadius: 0, // no blur
                                    spreadRadius:
                                        0.66, // equivalent to the 0.66px "outline" effect
                                  ),
                                  BoxShadow(
                                    color: const Color.fromRGBO(129, 129, 129,
                                        0.2), // rgba(129, 129, 129, 0.2)
                                    offset: const Offset(0, 2), // x=0, y=2
                                    blurRadius: 5, // blur radius
                                    spreadRadius: 0, // no spread
                                  ),
                                ],
                                color: Color.fromRGBO(230, 57, 73, 1)),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Please note that you need to ',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                    height: 1.62,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          'cancel your The Lively Three subscription separately ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'if you choose to delete your account.',
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 25),
                      decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          border: Border.all(
                              width: 1,
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0),
                              spreadRadius: 1,
                              blurRadius: 0,
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                            ),
                            BoxShadow(
                              offset: Offset(0, 3),
                              spreadRadius: 0,
                              blurRadius: 7,
                              color: Color(0xff818181),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        spacing: 18.5,
                        children: [
                          _buildDeleteItemList(
                              isChecked: true,
                              title:
                                  'Delete personal data, fully anonymize and keep the consumption data for community analytics.',
                              desc:
                                  'If selected, we’ll permanently delete your personal information and irreversibly anonymize your remaining consumption data (removing identifiers like your name, email, and device IDs). The de-identified data may be retained and combined with others’ to power community analytics and improve features. It cannot be linked back to you.'),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Color(0xff979797).withOpacity(0.18),
                          ),
                          _buildDeleteItemList(
                              isChecked: false,
                              title:
                                  'Delete all data, including personal data and consumption data.',
                              desc:
                                  'If selected, we will permanently delete all data associated with your account—including personal information and all consumption/activity records—from our active systems. This action is irreversible and will remove your history, saved items, recommendations, and any contributions to analytics. Minimal records that we’re legally required to retain (e.g., security or billing logs) may be stored separately until they expire under our retention policy and won’t be used to provide features. '),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: _buildTNCCard(
                          tncStatus: true,
                          tncTilte:
                              'I accept the terms, and I’m willing to delete this account permanently.'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DeleteAccountReasonPage(),
                          ),
                        );
                      },
                      text: 'Continue',
                      options: FFButtonOptions(
                        width: MediaQuery.sizeOf(context).width - 68,
                        height: 50,
                        color: FlutterFlowTheme.of(context).primaryText,
                        textStyle: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          fontSize: FlutterFlowTheme.adjustScale(size: 12),
                        ),
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteItemList(
      {bool isChecked = false, required String title, required String desc}) {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 8,
          children: [
            Checkbox(
              checkColor: Colors.white,
              splashRadius: 10,
              fillColor: isChecked
                  ? MaterialStateProperty.all(Colors.black)
                  : MaterialStateProperty.all(Color(0xfff9f9f9)),
              value: isChecked,
              shape: CircleBorder(),
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    height: 1.5,
                    color: FlutterFlowTheme.of(context).textGrey,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Text(
          desc,
          style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 12),
              height: 1.667,
              color: FlutterFlowTheme.of(context).textGrey,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildTNCCard({
    required String tncTilte,
    required bool tncStatus,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xfff9f9f9),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(249, 249, 249, 1),
              offset: Offset(0, 0),
              spreadRadius: 1),
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              offset: Offset(0, 2),
              blurRadius: 8),
        ],
        border:
            tncStatus ? Border.all(width: 1, color: Color(0xff81c995)) : null,
      ),
      child: Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SwitchButton(
              value: tncStatus,
              onChanged: (value) {
                setState(() {
                  tncStatus = value;
                });
              },
              height: 30,
            ),
            Expanded(
              child: Text(
                tncTilte,
                style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 12),
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ),
          ]),
    );
  }
}
