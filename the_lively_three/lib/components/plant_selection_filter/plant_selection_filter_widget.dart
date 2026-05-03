// ignore_for_file: prefer_const_constructors

import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlantSelectionFilterWidget extends StatefulWidget {
  const PlantSelectionFilterWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PlantSelectionFilterWidget> createState() =>
      _PlantSelectionFilterWidgetState();
}

class _PlantSelectionFilterWidgetState
    extends State<PlantSelectionFilterWidget> {
  final supabase = Supabase.instance.client;
  Locale? currentLocale;
  int totalConsumption = 0;
  Map<int, int> dailyConsumption = {};
  List<int> daysWithConsumption = [];
  late int colorCode;
  double portionsize = 0.0;

  // Lists to store vitamins from database
  List<Map<String, dynamic>> fatSolubleVitamins = [];
  List<Map<String, dynamic>> waterSolubleVitamins = [];
  Map<String, dynamic>? selectedVitamin; // Changed to single selection
  bool isLoading = true;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    _fetchVitaminsFromDatabase();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchVitaminsFromDatabase() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Fetch fat-soluble vitamins (category_code = 2) ordered alphabetically
      final fatSolubleResponse = await supabase
          .from('nutrient')
          .select('*')
          .eq('category_code', 2)
          .order('display_name', ascending: true);

      // Fetch water-soluble vitamins (category_code = 1) ordered alphabetically
      final waterSolubleResponse = await supabase
          .from('nutrient')
          .select('*')
          .eq('category_code', 1)
          .order('display_name', ascending: true);

      setState(() {
        fatSolubleVitamins =
            List<Map<String, dynamic>>.from(fatSolubleResponse);
        waterSolubleVitamins =
            List<Map<String, dynamic>>.from(waterSolubleResponse);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error - you might want to show a snackbar or error message
      print('Error fetching vitamins: $e');
    }
  }

  void _toggleVitaminSelection(Map<String, dynamic> vitamin) {
    setState(() {
      // If the same vitamin is clicked, deselect it; otherwise select the new one
      if (selectedVitamin != null && selectedVitamin!['id'] == vitamin['id']) {
        selectedVitamin = null;
      } else {
        selectedVitamin = vitamin;
      }
    });
  }

  void _clearAllSelections() {
    setState(() {
      selectedVitamin = null;
    });
  }

  Future<void> _applyFilters() async {
    print('DEBUG: _applyFilters called in filter widget');

    if (selectedVitamin == null) {
      print('DEBUG: No vitamin selected, returning null');
      Navigator.pop(context, null);
      return;
    }

    try {
      print('DEBUG: Selected vitamin in filter: $selectedVitamin');

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // For now, let's skip the database fetch and just return the vitamin info
      // You can add the plant data fetch later once this basic flow works

      // Close loading dialog
      Navigator.pop(context);

      print('DEBUG: Returning vitamin data to parent');

      // Return the selected vitamin info
      Navigator.pop(context, {
        'selectedVitamin': selectedVitamin,
      });
    } catch (e, stackTrace) {
      print('DEBUG: Error in _applyFilters: $e');
      print('DEBUG: Stack trace: $stackTrace');

      // Close loading dialog if it's open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 1.0,
        decoration: BoxDecoration(
          color: Color(0x37000000),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 12.0),
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
                                'Micronutrients',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 18.0),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
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
                  if (isLoading)
                    Container(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          spacing: 21,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fat-soluble vitamins section
                            if (fatSolubleVitamins.isNotEmpty)
                              Column(
                                spacing: 12,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontSize:
                                              FlutterFlowTheme.adjustScale(
                                                  size: 12),
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                      children: [
                                        TextSpan(text: 'Fat-soluble vitamins'),
                                        TextSpan(
                                          text:
                                              ' (stored in fat tissues/liver)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 12,
                                    children: fatSolubleVitamins.map((vitamin) {
                                      final vitaminName =
                                          vitamin['display_name'] ?? 'Unknown';
                                      final isSelected =
                                          selectedVitamin != null &&
                                              selectedVitamin!['id'] ==
                                                  vitamin['id'];
                                      return _filterChip(
                                        filterName: vitaminName,
                                        isSelected: isSelected,
                                        onTap: () =>
                                            _toggleVitaminSelection(vitamin),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),

                            // Water-soluble vitamins section
                            if (waterSolubleVitamins.isNotEmpty)
                              Column(
                                spacing: 12,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontSize:
                                              FlutterFlowTheme.adjustScale(
                                                  size: 12),
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                      children: const [
                                        TextSpan(
                                            text: 'Water-soluble vitamins'),
                                        TextSpan(
                                          text:
                                              ' (not stored much, need regular intake)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 12,
                                    children:
                                        waterSolubleVitamins.map((vitamin) {
                                      final vitaminName =
                                          vitamin['display_name'] ?? 'Unknown';
                                      final isSelected =
                                          selectedVitamin != null &&
                                              selectedVitamin!['id'] ==
                                                  vitamin['id'];
                                      return _filterChip(
                                        filterName: vitaminName,
                                        isSelected: isSelected,
                                        onTap: () =>
                                            _toggleVitaminSelection(vitamin),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),

                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: _clearAllSelections,
                                    text: 'Unselect',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 50,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      textStyle: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 12),
                                      ),
                                      elevation: 2.0,
                                      borderRadius: BorderRadius.circular(24.0),
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: _applyFilters,
                                    text: 'Apply',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 50,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      textStyle: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 12),
                                      ),
                                      elevation: 2.0,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip({
    required String filterName,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? Colors.black : Color(0xfff9f9f9),
        ),
        child: Text(
          filterName,
          style: TextStyle(
            fontSize: FlutterFlowTheme.adjustScale(size: 12),
            height: 1,
            color: isSelected ? Colors.white : Color(0xff2e3032),
          ),
        ),
      ),
    );
  }
}
