import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_lively_three/components/fluid_bg/setting_bg_widget.dart';
import 'package:the_lively_three/custom_code/widgets/silver_button_widget.dart';
import 'package:the_lively_three/custom_code/widgets/switchButton.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_widgets.dart';
import 'package:the_lively_three/l10n/app_localizations.dart';
import 'package:the_lively_three/pages/login/login_widget.dart';
import 'package:the_lively_three/pages/sign_up/sign_up_widget.dart';
import 'package:the_lively_three/utils/loader_util.dart';
import '/backend/supabase/supabase.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class DeleteAccountReasonPage extends StatefulWidget {
  const DeleteAccountReasonPage({
    super.key,
  });
  static String routeName = 'DeleteAccountReason';
  static String routePath = '/delete-account-reason';

  @override
  State<DeleteAccountReasonPage> createState() =>
      _DeleteAccountReasonPageState();
}

class _DeleteAccountReasonPageState extends State<DeleteAccountReasonPage> {
  bool showingDetailedPage = false;
  final supabase = Supabase.instance.client;

  final reasonsList = [
    'I don’t use Pro features ',
    'Technical Issues',
    'I wanted to try temporarily',
    'Out of my price range',
    'Technical Issues',
    'I wanted to try temporarily',
    'Out of my price range',
    'Other',
  ];
  String? _selectedReason;

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
    var l10n = AppLocalizations.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: Text(
          l10n.appName,
          style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 18),
              fontWeight: FontWeight.w700,
              color: FlutterFlowTheme.of(context).primaryText,
              fontFamily: 'KoHo'),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            }, //Navigator.pop(context)
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.close,
                size: 16,
                color: FlutterFlowTheme.of(context).primaryText,
                weight: 700,
              ),
            ),
          ),
        ],
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.0),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          const SettingsBG(),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Deleteing your\n',
                      style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 24),
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: FlutterFlowTheme.of(context).blackText,
                      ),
                      children: [
                        TextSpan(
                            text: 'The Lively T',
                            style: TextStyle(fontFamily: 'KoHo')),
                        TextSpan(
                            text: 'h',
                            style: TextStyle(
                              fontFamily: 'KoHo',
                              fontWeight: FontWeight.w400,
                            )),
                        TextSpan(
                            text: 'ree', style: TextStyle(fontFamily: 'KoHo')),
                        TextSpan(
                          text: ' account',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We're sorry to see you go. We'd like to know why you're deleting your account as we may be able to help with common issues.",
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 12),
                      height: 1.667,
                      color: FlutterFlowTheme.of(context).textGrey,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildRadioButtonList(),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () => showModalBottomSheet<Map<String, dynamic>>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => deleteConfirmationPopup(),
                    ),
                    text: 'Delete',
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
        ],
      ),
    );
  }

  Widget _buildRadioButtonList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reasonsList?.length ?? 0,
      itemBuilder: (context, index) {
        final value = reasonsList![index];
        return RadioListTile<String>(
          title: Text(value),
          value: value,
          activeColor: FlutterFlowTheme.of(context).primaryText,
          groupValue: _selectedReason,
          onChanged: (val) {
            setState(() => _selectedReason = val);
          },
        );
      },
    );
  }

  Widget deleteConfirmationPopup() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return SafeArea(
            child: Container(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 1.0,
          decoration: BoxDecoration(
            color: Color(0x37000000),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.cancel,
                          color: FlutterFlowTheme.of(context).textGrey,
                          size: 24.0,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 24.0, 0.0),
                          child: Text(
                            "Delete Account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 16),
                              fontWeight: FontWeight.w700,
                              color: FlutterFlowTheme.of(context).primaryText,
                              height: 1.2,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                decoration: BoxDecoration(
                  color: Color(0xFF979797),
                ),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height * 0.68,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  spacing: 20,
                  children: [
                    Text(
                      'Confirm permanent account deletion',
                      style: TextStyle(
                          fontSize: 16,
                          color: FlutterFlowTheme.of(context).textGrey,
                          fontWeight: FontWeight.w700,
                          height: 1.25),
                    ),
                    Text(
                      "If you continue with account deletion, your account and account details will be deleted on Nov 19, 2025. we will permanently delete all data associated with your account—including personal information and all consumption/activity records—from our active systems. This action is irreversible and will remove your history, saved items, recommendations, and any contributions to analytics. ",
                      style: TextStyle(
                          fontSize: 12,
                          color: FlutterFlowTheme.of(context).textGrey,
                          height: 1.667),
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        context.pushNamed(
                          LoginWidget.routeName,
                          extra: <String, dynamic>{
                            kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                            ),
                          },
                        );
                      },
                      text: 'Delete account',
                      options: FFButtonOptions(
                        width: double.infinity,
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
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                              color:
                                  FlutterFlowTheme.of(context).secondaryText),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              color: FlutterFlowTheme.of(context).blackText,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
