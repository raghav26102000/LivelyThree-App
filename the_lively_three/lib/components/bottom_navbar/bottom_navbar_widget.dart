import 'package:flutter_svg/svg.dart';
import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
import 'package:the_lively_three/pages/settings/settings_widget.dart';
import 'package:the_lively_three/utils/user_action_audit_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bottom_navbar_model.dart';
export 'bottom_navbar_model.dart';
import '/index.dart';
import '/l10n/app_localizations.dart';
import '/backend/supabase/supabase.dart';

class BottomNavbarWidget extends StatefulWidget {
  const BottomNavbarWidget({super.key});

  @override
  State<BottomNavbarWidget> createState() => _BottomNavbarWidgetState();
}

class _BottomNavbarWidgetState extends State<BottomNavbarWidget> {
  late BottomNavbarModel _model;
  int counter = 0;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final supabase = Supabase.instance.client;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BottomNavbarModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void logAuditAction(dietarySource) async {
    print("54: $dietarySource");
    final auditService = UserActionAuditService(supabase);
    await auditService.logUserAction(
      userId: currentUserUid,
      action: 'Add consumption',
      screenName: 'Homepage',
      userData: {
        'dietarySource': dietarySource,
        'week': FFAppState().calendarWeek,
        'year': FFAppState().calendarYear,
      },
    );
  }

  void _resetDateToToday() {
  final now = DateTime.now();
  FFAppState().currentDay = DateFormat('yyyy-MM-dd').format(now);
  FFAppState().currentDayNumber = now.weekday;
}

  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    setState(() {
      FFAppState().navFloatingButtonVisibility = _overlayEntry != null;
    });
  }

  OverlayEntry _createOverlayEntry() {
    final locale = AppLocalizations.of(context)!;
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        bottom: size.height,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, -MediaQuery.of(context).size.height + 16),
          child: Material(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Top-left button - UPF (dietary_source = 3)
                  Positioned(
                    top: MediaQuery.of(context).size.height - 105,
                    left: MediaQuery.of(context).size.width * 0.035,
                    child: _buildOverlayButton(
                      "assets/images/ultra_processed_food.png",
                      locale.ultraProcessed,
                      locale.foods,
                      onTap: () async{
                         _resetDateToToday();
                         final auditService = UserActionAuditService(supabase);
    await auditService.logUserAction(
      userId: currentUserUid,
      action: 'Add consumption',
      screenName: 'Homepage',
      userData: {
        'dietarySource': 3,
        'week': FFAppState().calendarWeek,
        'year': FFAppState().calendarYear,
      },
    );
                        context.pushNamed(
                          PlantselectionWidget.routeName,
                          queryParameters: {
                            'dietarySource': serializeParam(3,
                                ParamType.int), // Changed from dietary_source
                          }.withoutNulls,
                          extra: <String, dynamic>{
                            kTransitionInfoKey: const TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                            ),
                          },
                        );
                        _toggleOverlay();
                      },
                    ),
                  ),
                  // Top-right button - Animal Products (dietary_source = 2)
                  Positioned(
                    top: MediaQuery.of(context).size.height - 145,
                    left: MediaQuery.of(context).size.width * 0.25,
                    child: _buildOverlayButton(
                      "assets/images/animal_product.png",
                      locale.animal,
                      locale.products,
                      onTap: () {
                         _resetDateToToday();
                        logAuditAction(2);
                        context.pushNamed(
                          PlantselectionWidget.routeName,
                          queryParameters: {
                            'dietarySource': serializeParam(2,
                                ParamType.int), // Changed from dietary_source
                          }.withoutNulls,
                          extra: <String, dynamic>{
                            kTransitionInfoKey: const TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                            ),
                          },
                        );
                        _toggleOverlay();
                      },
                    ),
                  ),
                  // Bottom-left button - Water (dietary_source = 4)
                  Positioned(
                    top: MediaQuery.of(context).size.height - 145,
                    right: MediaQuery.of(context).size.width * 0.25,
                    child: _buildOverlayButton(
                      "assets/images/water.png",
                      locale.water,
                      "",
                      onTap: () {
                         _resetDateToToday();
                        logAuditAction(4);
                        context.pushNamed(
                          PlantselectionWidget.routeName,
                          queryParameters: {
                            'dietarySource': serializeParam(4,
                                ParamType.int), // Changed from dietary_source
                          }.withoutNulls,
                          extra: <String, dynamic>{
                            kTransitionInfoKey: const TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                            ),
                          },
                        );
                        _toggleOverlay();
                      },
                    ),
                  ),
                  // Bottom-right button - Plants (dietary_source = 1)
                  Positioned(
                    top: MediaQuery.of(context).size.height - 105,
                    right: MediaQuery.of(context).size.width * 0.035,
                    child: _buildOverlayButton(
                      "assets/images/plant_product.png",
                      locale.plants,
                      "",
                      onTap: () {
                         _resetDateToToday();
                        logAuditAction(1);
                        context.pushNamed(
                          PlantselectionWidget.routeName,
                          queryParameters: {
                            'dietarySource': serializeParam(1,
                                ParamType.int), // Changed from dietary_source
                          }.withoutNulls,
                          extra: <String, dynamic>{
                            kTransitionInfoKey: const TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                            ),
                          },
                        );
                        _toggleOverlay();
                      },
                    ),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height - 16,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Color(0xfffefefe),
                            borderRadius: BorderRadius.circular(999.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                spreadRadius: 0.0,
                                blurRadius: 8,
                                offset: Offset(0, 0),
                              )
                            ],
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: InkWell(
                            onTap: _toggleOverlay,
                            child: Icon(
                              Icons.close,
                              color: Color.fromRGBO(224, 32, 32, 1),
                              size: 36.0,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayButton(String imagePath, String text1, String text2,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 110,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Image.asset(
                imagePath,
                height: 28,
                width: 28,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              text1,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: Colors.white,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                  ),
            ),
            if (text2.isNotEmpty)
              Text(
                text2,
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: Colors.white,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    context.watch<FFAppState>();

    return CompositedTransformTarget(
      link: _layerLink,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: 72,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.92),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        offset: Offset(0, 1),
                        blurRadius: 8)
                  ]),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.2 - 5,
                      child: GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              HomepageWidget.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: const TransitionInfo(
                                  hasTransition: true,
                                  transitionType:
                                      PageTransitionType.bottomToTop,
                                ),
                              },
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/home_icon.svg',
                                height: 24,
                              ),
                             
                              Text(
                                locale.home,
                                style: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .override(
                                      font: GoogleFonts.montserrat(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 10.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ].divide(SizedBox(height: 4.0)),
                          )),
                    ),
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.2 - 5,
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              ProgressPage.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: const TransitionInfo(
                                  hasTransition: true,
                                  transitionType:
                                      PageTransitionType.bottomToTop,
                                ),
                              },
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/dashboard_icon.svg',
                                height: 24,
                              ),
                              Text(
                                locale.progress,
                                style: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .override(
                                      font: GoogleFonts.montserrat(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 10.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ].divide(SizedBox(height: 4.0)),
                          ),
                        )),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.2 - 5,
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.2 - 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/sustainability_icon.png',
                            height: 24,
                          ),
                          Text(
                            locale.sustainability,
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  font: GoogleFonts.montserrat(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 10.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ].divide(SizedBox(height: 4.0)),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.2 - 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              context.pushNamed(
                                SettingsNewPage.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                  ),
                                },
                              );
                            },
                            child: SvgPicture.asset(
                              'assets/icons/settings_icon.svg',
                              height: 24,
                            ),
                          ),
                          Text(
                            locale.settings,
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  font: GoogleFonts.montserrat(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 10.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ].divide(SizedBox(height: 4.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Material(
              color: Colors.transparent,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999.0),
              ),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Color(0xfffefefe),
                  borderRadius: BorderRadius.circular(999.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      spreadRadius: 0.0,
                      blurRadius: 8,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: InkWell(
                  onTap: _toggleOverlay,
                  child: Icon(
                    _overlayEntry == null ? Icons.add_rounded : Icons.close,
                    color: _overlayEntry == null
                        ? Color.fromRGBO(46, 48, 50, 1)
                        : Color.fromRGBO(224, 32, 32, 1),
                    size: 36.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
