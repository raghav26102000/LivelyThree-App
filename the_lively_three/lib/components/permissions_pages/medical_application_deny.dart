import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';

Future<void> showMedicalConsentPopup(
  BuildContext context,
  VoidCallback? onContinue,
  VoidCallback? onSkip,
) async {
  showGeneralDialog(
    context: context,
    barrierLabel: "MedicalConsentPopup",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox.shrink(); // not used
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // Background blur effect for full screen
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
              // Center popup
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              height: 150,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                gradient: RadialGradient(
                                  colors: [
                                    Color(0xFFf8f2df).withOpacity(0.3),
                                    Color(0xFFf8f2df).withOpacity(0.3),
                                    Color(0xFFf8f2df).withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 75,
                            child: Container(
                              height: 150,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                gradient: RadialGradient(
                                  colors: [
                                    Color(0xFFe0eee1).withOpacity(0.3),
                                    Color(0xFFe0eee1).withOpacity(0.3),
                                    Color(0xFFe0eee1).withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 20,
                            bottom: 0,
                            child: Container(
                              height: 150,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                gradient: RadialGradient(
                                  colors: [
                                    Color(0xFFf9ede1).withOpacity(0.3),
                                    Color(0xFFf9ede1).withOpacity(0.3),
                                    Color(0xFFf9ede1).withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: const Icon(
                                      Icons.close,
                                      size: 22,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Consent Required to Continue Using This Application",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 18),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    height: 1.778,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(height: 20),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text:
                                        'To ensure proper functionality and compliance, we require your consent. If you choose not to provide it, you will not be able to access or use the application”',
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
                                const SizedBox(height: 20),
                                Row(
                                  spacing: 8,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: onSkip,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          width:
                                              MediaQuery.sizeOf(context).width -
                                                  60,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                style: BorderStyle.solid,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText),
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          child: Text(
                                            'Delete Account',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 12),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .blackText,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          fixedSize: const Size.fromHeight(50),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(99),
                                          ),
                                        ),
                                        onPressed: onContinue,
                                        child: Text(
                                          "I Consent",
                                          style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 12),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}
