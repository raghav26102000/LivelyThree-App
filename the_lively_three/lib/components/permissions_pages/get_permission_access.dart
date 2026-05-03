import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/pages/data_contracts/data_contracts_widget.dart';

Future<void> showPermissionPopup(BuildContext context) async {
  showGeneralDialog(
    context: context,
    barrierLabel: "PermissionPopup",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox.shrink(); // not used
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
        child: Material(
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
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 22,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Access restricted, give permission\nto get the best experience",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 18),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    height: 1.61,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "You’ll need to allow data access in Settings > Data Permissions to view this page and get personalized suggestions.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                    color: Colors.grey.shade700,
                                    height: 2,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      fixedSize: const Size.fromHeight(50),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const DataContractPage(
                                            fromPage: 'Home',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Open Data Permissions",
                                      style: TextStyle(
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 12),
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
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}
