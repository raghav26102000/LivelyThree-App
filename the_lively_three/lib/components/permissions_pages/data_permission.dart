import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/pages/homepage/homepage_widget.dart';

class SubscriptionPopup extends StatefulWidget {
  final VoidCallback? onClose;

  const SubscriptionPopup({
    Key? key,
    this.onClose,
  }) : super(key: key);

  @override
  State<SubscriptionPopup> createState() => _SubscriptionPopupState();
}

class _SubscriptionPopupState extends State<SubscriptionPopup> {
  String selectPlanDuration = 'Yearly'; // Default selected plan
  String subscribedPlan = ''; // Empty means not subscribed yet

  void _setSelectedPlan(String plan) {
    setState(() {
      selectPlanDuration = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                width: MediaQuery.of(context).size.width * 0.95,
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
                      width: MediaQuery.of(context).size.width * 0.95,
                      padding: const EdgeInsets.all(12),
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
                          const SizedBox(height: 8),
                          Text(
                            "Know Your Impact. Improve Your Choices.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 18),
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              height: 1.61,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "To receive personalized suggestions, please subscribe and give permission to data access.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 12),
                              color: Colors.grey.shade700,
                              height: 1.67,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildPlanCard(
                            title: "Yearly",
                            subtitle: "95,99 € / year after 7 day trial",
                            isSelected: selectPlanDuration == 'Yearly',
                            onTap: subscribedPlan == ''
                                ? () => _setSelectedPlan('Yearly')
                                : null,
                            showHeader: true,
                          ),
                          const SizedBox(height: 12),

                          // Monthly Plan Card
                          _buildPlanCard(
                            title: "Monthly",
                            subtitle: "12,99 € / month after 7 day trial",
                            isSelected: selectPlanDuration == 'Monthly',
                            onTap: subscribedPlan == ''
                                ? () => _setSelectedPlan('Monthly')
                                : null,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                fixedSize: const Size.fromHeight(50),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 12),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
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
    );

    // return Stack(
    //   children: [
    //     // Background blur effect for full screen
    //     BackdropFilter(
    //       filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
    //       child: Container(
    //         color: Colors.white.withOpacity(0.8),
    //       ),
    //     ),
    //     // Center popup
    //     Center(
    //       child: Material(
    //         type: MaterialType.transparency,
    //         child: Container(
    //           padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
    //           height: MediaQuery.sizeOf(context).height,
    //           decoration: BoxDecoration(
    //             color: Colors.transparent,
    //             borderRadius: BorderRadius.circular(20),
    //           ),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Align(
    //                 alignment: Alignment.topRight,
    //                 child: GestureDetector(
    //                   onTap: () {
    //                     Navigator.of(context).pop();
    //                   },
    //                   child: const Icon(Icons.close, size: 22),
    //                 ),
    //               ),
    //               const SizedBox(height: 28),
    //               const Text(
    //                 "Know Your Impact\nImprove Your Choices.",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                     fontSize: 24,
    //                     fontWeight: FontWeight.w700,
    //                     height: 1.2,
    //                     color: Colors.black),
    //               ),
    //               const SizedBox(height: 30),
    //               const Text(
    //                 "To receive personalized suggestions, please subscribe and give permission to data access.",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                   fontSize: 18,
    //                   color: Colors.black,
    //                   height: 1.6,
    //                 ),
    //               ),
    //               const SizedBox(height: 40),

    //               // Yearly Plan Card
    //               Column(
    //                 children: [
    //                   _buildPlanCard(
    //                     title: "Yearly",
    //                     subtitle: "95,99 € / year after 7 day trial",
    //                     isSelected: selectPlanDuration == 'Yearly',
    //                     onTap: subscribedPlan == ''
    //                         ? () => _setSelectedPlan('Yearly')
    //                         : null,
    //                     showHeader: true,
    //                   ),
    //                 ],
    //               ),
    //               const SizedBox(height: 24),

    //               // Monthly Plan Card
    //               _buildPlanCard(
    //                 title: "Monthly",
    //                 subtitle: "12,99 € / month after 7 day trial",
    //                 isSelected: selectPlanDuration == 'Monthly',
    //                 onTap: subscribedPlan == ''
    //                     ? () => _setSelectedPlan('Monthly')
    //                     : null,
    //               ),
    //               const SizedBox(height: 20),
    //               const Spacer(),
    //               SizedBox(
    //                 width: double.infinity,
    //                 child: ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: Colors.black,
    //                     foregroundColor: Colors.white,
    //                     fixedSize: const Size.fromHeight(50),
    //                     padding: const EdgeInsets.symmetric(vertical: 14),
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(99),
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     Navigator.pop(context);
    //                     // TODO: Add subscription purchase logic
    //                   },
    //                   child: const Text(
    //                     "Continue",
    //                     style: TextStyle(
    //                       fontSize: 12,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget _buildPlanCard({
    required String title,
    String? subtitle = '',
    required bool isSelected,
    required VoidCallback? onTap,
    bool showHeader = false,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Opacity(
              opacity: isSelected ? 1 : 0.5,
              child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(children: [
                    if (showHeader)
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xfff4c400),
                                Color(0xfff77f00),
                                Color(0xffe63949),
                                Color(0xffc40cd3),
                              ],
                              stops: [0.0, 0.27, 0.61, 1.0],
                              end: Alignment.topLeft,
                              begin: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: Colors.white70,
                                    style: BorderStyle.solid))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Save 20%',
                                  style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 16),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xfff4c400),
                            Color(0xfff77f00),
                            Color(0xffe63949),
                            Color(0xffc40cd3),
                          ],
                          stops: [0.0, 0.27, 0.61, 1.0],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.32),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: !showHeader
                            ? BorderRadius.circular(12)
                            : const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 18),
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (subtitle != '')
                            Text(
                              '$subtitle',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 16),
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ])),
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffc40cd3),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.32),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
              ),
            if (showHeader)
              Positioned(
                left: 11,
                top: 11,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xfff4c400),
                          Color(0xfff77f00),
                          Color(0xffe63949),
                          Color(0xffc40cd3),
                        ],
                        stops: [0.0, 0.27, 0.61, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          width: 1,
                          color: Colors.white70,
                          style: BorderStyle.solid)),
                  child: Text(
                    'Best Deal',
                    style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 12),
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Updated showSubscriptionPopup function
Future<void> showSubscriptionPopup(
  BuildContext context, {
  VoidCallback? onClose,
}) async {
  await showGeneralDialog(
    context: context,
    barrierLabel: "SubscriptionPopup",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
        child: SubscriptionPopup(onClose: onClose),
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
  );

  // After dialog is dismissed, call the onClose callback
  if (onClose != null) {
    Future.delayed(const Duration(milliseconds: 50), () {
      onClose();
    });
  }
}
