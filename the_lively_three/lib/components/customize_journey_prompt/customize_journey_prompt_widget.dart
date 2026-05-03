import 'package:flutter/material.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_widgets.dart';
import '/l10n/app_localizations.dart';

class CustomizeJourneyPrompt extends StatefulWidget {
  final String title;
  final String? description;
  final VoidCallback? onSkip;
  final VoidCallback? onNext;

  final bool showBack;
  final VoidCallback? onBack;

  const CustomizeJourneyPrompt({
    Key? key,
    required this.title,
    this.description,
    this.onNext,
    this.onSkip,
    this.showBack = false,
    this.onBack,
  }) : super(key: key);

  @override
  State<CustomizeJourneyPrompt> createState() => _DynamicFormFieldState();
}

class _DynamicFormFieldState extends State<CustomizeJourneyPrompt> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24.0),
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 🔹 Top Section (fixed title + description)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (widget.description != null) ...[
                const SizedBox(height: 16),
                Text(
                  widget.description!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),

          /// 🔹 Scrollable message bubble area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  MessageBubble(
                    normalText:
                        '${localization.personalized_experience1} ${localization.personalized_experience2}',
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(19)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.personalized_experience3,
                          style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              height: 2,
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("   - ",
                                style: TextStyle(
                                    fontSize: FlutterFlowTheme.adjustScale(
                                        size: 20))), // bullet
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: localization.personalized_experience4,
                                  style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      height: 2,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("   - ",
                                style: TextStyle(
                                    fontSize: FlutterFlowTheme.adjustScale(
                                        size: 20))), // bullet
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: localization.personalized_experience5,
                                  style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      height: 2,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("   - ",
                                style: TextStyle(
                                    fontSize: FlutterFlowTheme.adjustScale(
                                        size: 20))), // bullet
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: localization.personalized_experience6,
                                  style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      height: 2,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("   - ",
                                style: TextStyle(
                                    fontSize: FlutterFlowTheme.adjustScale(
                                        size: 20))), // bullet
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: localization.personalized_experience7,
                                  style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      height: 2,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("   - ",
                                style: TextStyle(
                                    fontSize: FlutterFlowTheme.adjustScale(
                                        size: 20))), // bullet
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: localization.personalized_experience8,
                                  style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      height: 2,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("   - ",
                                style: TextStyle(
                                    fontSize: FlutterFlowTheme.adjustScale(
                                        size: 20))), // bullet
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: localization.personalized_experience9,
                                  style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      height: 2,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("- ",
                                style: TextStyle(
                                    fontSize: FlutterFlowTheme.adjustScale(
                                        size: 20))), // bullet
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: localization.personalized_experience10,
                                  style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      height: 2,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  MessageBubble(
                      normalText: localization.personalized_experience11)
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// 🔹 Bottom Buttons (fixed)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12,
            children: [
              FFButtonWidget(
                onPressed: widget.onNext,
                text: localization.confirm,
                options: FFButtonOptions(
                  width: MediaQuery.sizeOf(context).width - 60,
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
              FFButtonWidget(
                onPressed: widget.onSkip,
                text: localization.skipForNow,
                options: FFButtonOptions(
                  width: MediaQuery.sizeOf(context).width - 60,
                  height: 50,
                  color: const Color(0xfff8f8f8),
                  borderSide: const BorderSide(
                    color: Color(0xff979797),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  textStyle: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                  ),
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String normalText;
  final String boldText;
  final bool textCenter;
  const MessageBubble(
      {super.key,
      required this.normalText,
      this.boldText = '',
      this.textCenter = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(19)),
      child: RichText(
        textAlign: textCenter ? TextAlign.center : TextAlign.left,
        text: TextSpan(
            text: normalText,
            style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 12),
                height: 2,
                color: FlutterFlowTheme.of(context).primaryText,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5),
            children: [
              TextSpan(
                  text: boldText,
                  style: const TextStyle(fontWeight: FontWeight.w600))
            ]),
      ),
    );
  }
}
