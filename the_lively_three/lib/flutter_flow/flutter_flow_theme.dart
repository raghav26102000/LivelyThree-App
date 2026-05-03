// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';

const kThemeModeKey = '__theme_mode__';

SharedPreferences? _prefs;

enum DeviceSize {
  mobile,
  tablet,
  desktop,
}

abstract class FlutterFlowTheme {
  static DeviceSize deviceSize = DeviceSize.mobile;

  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();

  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static double adjustScale(
      {required double size,
      double smallScreenMargin = 2,
      double largeScreenMargin = 2}) {
    if (FFAppState().screenCategory == 'small') {
      return size - smallScreenMargin;
    } else if (FFAppState().screenCategory == 'medium') {
      return size;
    } else {
      return size + largeScreenMargin;
    }
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static FlutterFlowTheme of(BuildContext context) {
    deviceSize = getDeviceSize(context);
    return Theme.of(context).brightness == Brightness.dark
        ? DarkModeTheme()
        : LightModeTheme();
  }

  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;

  late Color tertiaryText;
  late Color blackText;
  late Color labelText;
  late Color circularTextColor;
  late Color userPlantProtein;
  late Color userAnimalProtein;
  late Color commPlantProtein;
  late Color commAnimalProtein;
  late Color commFiber;
  late Color userFiber;
  late Color secondary2;
  late Color redFill;
  late Color orangeFill;
  late Color yellowFill;
  late Color greenFill;
  late Color purpleFill;
  late Color brownFill;
  late Color greyFill;
  late Color whiteFill;
  late Color redBorder;
  late Color orangeBorder;
  late Color yellowBorder;
  late Color greenBorder;
  late Color purpleBorder;
  late Color brownBorder;
  late Color whiteBorder;
  late Color greyDark;
  late Color brownDark;
  late Color redDark;
  late Color orangeDark;
  late Color yellowDark;
  late Color greenDark;
  late Color purpleDark;
  late Color textGrey;
  late Color textWhite;
  late Color textGreen;
  late Color bgGreen;

  @Deprecated('Use displaySmallFamily instead')
  String get title1Family => displaySmallFamily;
  @Deprecated('Use displaySmall instead')
  TextStyle get title1 => typography.displaySmall;
  @Deprecated('Use headlineMediumFamily instead')
  String get title2Family => typography.headlineMediumFamily;
  @Deprecated('Use headlineMedium instead')
  TextStyle get title2 => typography.headlineMedium;
  @Deprecated('Use headlineSmallFamily instead')
  String get title3Family => typography.headlineSmallFamily;
  @Deprecated('Use headlineSmall instead')
  TextStyle get title3 => typography.headlineSmall;
  @Deprecated('Use titleMediumFamily instead')
  String get subtitle1Family => typography.titleMediumFamily;
  @Deprecated('Use titleMedium instead')
  TextStyle get subtitle1 => typography.titleMedium;
  @Deprecated('Use titleSmallFamily instead')
  String get subtitle2Family => typography.titleSmallFamily;
  @Deprecated('Use titleSmall instead')
  TextStyle get subtitle2 => typography.titleSmall;
  @Deprecated('Use bodyMediumFamily instead')
  String get bodyText1Family => typography.bodyMediumFamily;
  @Deprecated('Use bodyMedium instead')
  TextStyle get bodyText1 => typography.bodyMedium;
  @Deprecated('Use bodySmallFamily instead')
  String get bodyText2Family => typography.bodySmallFamily;
  @Deprecated('Use bodySmall instead')
  TextStyle get bodyText2 => typography.bodySmall;

  String get displayLargeFamily => typography.displayLargeFamily;
  bool get displayLargeIsCustom => typography.displayLargeIsCustom;
  TextStyle get displayLarge => typography.displayLarge;
  String get displayMediumFamily => typography.displayMediumFamily;
  bool get displayMediumIsCustom => typography.displayMediumIsCustom;
  TextStyle get displayMedium => typography.displayMedium;
  String get displaySmallFamily => typography.displaySmallFamily;
  bool get displaySmallIsCustom => typography.displaySmallIsCustom;
  TextStyle get displaySmall => typography.displaySmall;
  String get headlineLargeFamily => typography.headlineLargeFamily;
  bool get headlineLargeIsCustom => typography.headlineLargeIsCustom;
  TextStyle get headlineLarge => typography.headlineLarge;
  String get headlineMediumFamily => typography.headlineMediumFamily;
  bool get headlineMediumIsCustom => typography.headlineMediumIsCustom;
  TextStyle get headlineMedium => typography.headlineMedium;
  String get headlineSmallFamily => typography.headlineSmallFamily;
  bool get headlineSmallIsCustom => typography.headlineSmallIsCustom;
  TextStyle get headlineSmall => typography.headlineSmall;
  String get titleLargeFamily => typography.titleLargeFamily;
  bool get titleLargeIsCustom => typography.titleLargeIsCustom;
  TextStyle get titleLarge => typography.titleLarge;
  String get titleMediumFamily => typography.titleMediumFamily;
  bool get titleMediumIsCustom => typography.titleMediumIsCustom;
  TextStyle get titleMedium => typography.titleMedium;
  String get titleSmallFamily => typography.titleSmallFamily;
  bool get titleSmallIsCustom => typography.titleSmallIsCustom;
  TextStyle get titleSmall => typography.titleSmall;
  String get labelLargeFamily => typography.labelLargeFamily;
  bool get labelLargeIsCustom => typography.labelLargeIsCustom;
  TextStyle get labelLarge => typography.labelLarge;
  String get labelMediumFamily => typography.labelMediumFamily;
  bool get labelMediumIsCustom => typography.labelMediumIsCustom;
  TextStyle get labelMedium => typography.labelMedium;
  String get labelSmallFamily => typography.labelSmallFamily;
  bool get labelSmallIsCustom => typography.labelSmallIsCustom;
  TextStyle get labelSmall => typography.labelSmall;
  String get bodyLargeFamily => typography.bodyLargeFamily;
  bool get bodyLargeIsCustom => typography.bodyLargeIsCustom;
  TextStyle get bodyLarge => typography.bodyLarge;
  String get bodyMediumFamily => typography.bodyMediumFamily;
  bool get bodyMediumIsCustom => typography.bodyMediumIsCustom;
  TextStyle get bodyMedium => typography.bodyMedium;
  String get bodySmallFamily => typography.bodySmallFamily;
  bool get bodySmallIsCustom => typography.bodySmallIsCustom;
  TextStyle get bodySmall => typography.bodySmall;

  Typography get typography => {
        DeviceSize.mobile: MobileTypography(this),
        DeviceSize.tablet: TabletTypography(this),
        DeviceSize.desktop: DesktopTypography(this),
      }[deviceSize]!;
}

DeviceSize getDeviceSize(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 479) {
    return DeviceSize.mobile;
  } else if (width < 991) {
    return DeviceSize.tablet;
  } else {
    return DeviceSize.desktop;
  }
}

class LightModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF2f3032);
  late Color secondary = const Color(0xFF0B67BC);
  late Color tertiary = const Color(0xFFACC420);
  late Color alternate = const Color(0xFFF9F9F9);
  late Color primaryText = const Color(0xFF2f3032);
  late Color secondaryText = const Color(0xFF979797);
  late Color primaryBackground = const Color(0xFFFFFFFF);
  late Color secondaryBackground = const Color(0xFFF9F9F9);
  late Color accent1 = const Color(0x4C2797FF);
  late Color accent2 = const Color(0x4C0B67BC);
  late Color accent3 = const Color(0x4DACC420);
  late Color accent4 = const Color(0xFFEEEEEE);
  late Color success = const Color(0xFF27AE52);
  late Color warning = const Color(0xFFFC964D);
  late Color error = const Color(0xFFEE4444);
  late Color info = const Color(0xFFFFFFFF);

  late Color tertiaryText = const Color(0xFF999FA8);
  late Color blackText = const Color(0xFF000000);
  late Color labelText = const Color(0xFF707172);
  late Color circularTextColor = const Color(0xFF505050);
  late Color userPlantProtein = const Color(0xFF36B4AD);
  late Color userAnimalProtein = const Color(0xFFC15374);
  late Color commPlantProtein = const Color(0xFF8AD0CC);
  late Color commAnimalProtein = const Color(0xFFF2D0DE);
  late Color commFiber = const Color(0xFFC2B4A6);
  late Color userFiber = const Color(0xFFDE8A74);
  late Color secondary2 = const Color(0xFF5894A8);
  late Color redFill = const Color(0xFFE63946);
  late Color orangeFill = const Color(0xFFF77F00);
  late Color yellowFill = const Color(0xFFF2C935);
  late Color greenFill = const Color(0xFF4CAF50);
  late Color purpleFill = const Color(0xFFC40CD3);
  late Color brownFill = const Color(0xFF886052);
  late Color greyFill = const Color(0xFFC3C3C3);
  late Color whiteFill = const Color(0xFFC3C3C3);
  late Color redBorder = const Color(0xFF9D2137);
  late Color orangeBorder = const Color(0xFFAA6410);
  late Color yellowBorder = const Color(0xFFAC941A);
  late Color greenBorder = const Color(0xFF24710A);
  late Color purpleBorder = const Color(0xFF7B1F52);
  late Color brownBorder = const Color(0xFF6A4818);
  late Color whiteBorder = const Color(0xFF999999);
  late Color greyDark = const Color(0xFFC0BDBB);
  late Color brownDark = const Color(0xFF8D6E63);
  late Color redDark = const Color(0xFFE63946);
  late Color orangeDark = const Color(0xFFF77F00);
  late Color yellowDark = const Color(0xFFF4D35E);
  late Color greenDark = const Color(0xFF4CAF50);
  late Color purpleDark = const Color(0xFF6A0572);
  late Color textGrey = const Color(0xFF434343);
  late Color textWhite = const Color(0xFFFFFFFF);
  late Color textGreen = const Color(0xFF195f5d);
  late Color bgGreen = const Color(0xFF5db494);
}

abstract class Typography {
  String get displayLargeFamily;
  bool get displayLargeIsCustom;
  TextStyle get displayLarge;
  String get displayMediumFamily;
  bool get displayMediumIsCustom;
  TextStyle get displayMedium;
  String get displaySmallFamily;
  bool get displaySmallIsCustom;
  TextStyle get displaySmall;
  String get headlineLargeFamily;
  bool get headlineLargeIsCustom;
  TextStyle get headlineLarge;
  String get headlineMediumFamily;
  bool get headlineMediumIsCustom;
  TextStyle get headlineMedium;
  String get headlineSmallFamily;
  bool get headlineSmallIsCustom;
  TextStyle get headlineSmall;
  String get titleLargeFamily;
  bool get titleLargeIsCustom;
  TextStyle get titleLarge;
  String get titleMediumFamily;
  bool get titleMediumIsCustom;
  TextStyle get titleMedium;
  String get titleSmallFamily;
  bool get titleSmallIsCustom;
  TextStyle get titleSmall;
  String get labelLargeFamily;
  bool get labelLargeIsCustom;
  TextStyle get labelLarge;
  String get labelMediumFamily;
  bool get labelMediumIsCustom;
  TextStyle get labelMedium;
  String get labelSmallFamily;
  bool get labelSmallIsCustom;
  TextStyle get labelSmall;
  String get bodyLargeFamily;
  bool get bodyLargeIsCustom;
  TextStyle get bodyLarge;
  String get bodyMediumFamily;
  bool get bodyMediumIsCustom;
  TextStyle get bodyMedium;
  String get bodySmallFamily;
  bool get bodySmallIsCustom;
  TextStyle get bodySmall;
}

class MobileTypography extends Typography {
  MobileTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => 'Roboto';
  bool get displayLargeIsCustom => false;
  TextStyle get displayLarge => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 57.0,
      );
  String get displayMediumFamily => 'Roboto';
  bool get displayMediumIsCustom => false;
  TextStyle get displayMedium => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 45.0,
      );
  String get displaySmallFamily => 'Roboto';
  bool get displaySmallIsCustom => false;
  TextStyle get displaySmall => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 36.0,
      );
  String get headlineLargeFamily => 'Roboto';
  bool get headlineLargeIsCustom => false;
  TextStyle get headlineLarge => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 32.0,
      );
  String get headlineMediumFamily => 'Roboto';
  bool get headlineMediumIsCustom => false;
  TextStyle get headlineMedium => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 32.0,
      );
  String get headlineSmallFamily => 'Roboto';
  bool get headlineSmallIsCustom => false;
  TextStyle get headlineSmall => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      );
  String get titleLargeFamily => 'Roboto';
  bool get titleLargeIsCustom => false;
  TextStyle get titleLarge => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 22.0,
      );
  String get titleMediumFamily => 'Manrope';
  bool get titleMediumIsCustom => false;
  TextStyle get titleMedium => GoogleFonts.manrope(
        color: theme.info,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  String get titleSmallFamily => 'Manrope';
  bool get titleSmallIsCustom => false;
  TextStyle get titleSmall => GoogleFonts.manrope(
        color: theme.info,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get labelLargeFamily => 'Manrope';
  bool get labelLargeIsCustom => false;
  TextStyle get labelLarge => GoogleFonts.manrope(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  String get labelMediumFamily => 'Manrope';
  bool get labelMediumIsCustom => false;
  TextStyle get labelMedium => GoogleFonts.manrope(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get labelSmallFamily => 'Manrope';
  bool get labelSmallIsCustom => false;
  TextStyle get labelSmall => GoogleFonts.manrope(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
      );
  String get bodyLargeFamily => 'Manrope';
  bool get bodyLargeIsCustom => false;
  TextStyle get bodyLarge => GoogleFonts.manrope(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  String get bodyMediumFamily => 'Manrope';
  bool get bodyMediumIsCustom => false;
  TextStyle get bodyMedium => GoogleFonts.manrope(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get bodySmallFamily => 'Manrope';
  bool get bodySmallIsCustom => false;
  TextStyle get bodySmall => GoogleFonts.manrope(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
      );
}

class TabletTypography extends Typography {
  TabletTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => 'Roboto';
  bool get displayLargeIsCustom => false;
  TextStyle get displayLarge => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 57.0,
      );
  String get displayMediumFamily => 'Roboto';
  bool get displayMediumIsCustom => false;
  TextStyle get displayMedium => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 45.0,
      );
  String get displaySmallFamily => 'Roboto';
  bool get displaySmallIsCustom => false;
  TextStyle get displaySmall => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 36.0,
      );
  String get headlineLargeFamily => 'Roboto';
  bool get headlineLargeIsCustom => false;
  TextStyle get headlineLarge => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 32.0,
      );
  String get headlineMediumFamily => 'Roboto';
  bool get headlineMediumIsCustom => false;
  TextStyle get headlineMedium => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 32.0,
      );
  String get headlineSmallFamily => 'Roboto';
  bool get headlineSmallIsCustom => false;
  TextStyle get headlineSmall => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      );
  String get titleLargeFamily => 'Roboto';
  bool get titleLargeIsCustom => false;
  TextStyle get titleLarge => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 22.0,
      );
  String get titleMediumFamily => 'Manrope';
  bool get titleMediumIsCustom => false;
  TextStyle get titleMedium => GoogleFonts.manrope(
        color: theme.info,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  String get titleSmallFamily => 'Manrope';
  bool get titleSmallIsCustom => false;
  TextStyle get titleSmall => GoogleFonts.manrope(
        color: theme.info,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get labelLargeFamily => 'Manrope';
  bool get labelLargeIsCustom => false;
  TextStyle get labelLarge => GoogleFonts.manrope(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  String get labelMediumFamily => 'Manrope';
  bool get labelMediumIsCustom => false;
  TextStyle get labelMedium => GoogleFonts.manrope(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get labelSmallFamily => 'Manrope';
  bool get labelSmallIsCustom => false;
  TextStyle get labelSmall => GoogleFonts.manrope(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
      );
  String get bodyLargeFamily => 'Manrope';
  bool get bodyLargeIsCustom => false;
  TextStyle get bodyLarge => GoogleFonts.manrope(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  String get bodyMediumFamily => 'Manrope';
  bool get bodyMediumIsCustom => false;
  TextStyle get bodyMedium => GoogleFonts.manrope(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get bodySmallFamily => 'Manrope';
  bool get bodySmallIsCustom => false;
  TextStyle get bodySmall => GoogleFonts.manrope(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
      );
}

class DesktopTypography extends Typography {
  DesktopTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => 'Roboto';
  bool get displayLargeIsCustom => false;
  TextStyle get displayLarge => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 57.0,
      );
  String get displayMediumFamily => 'Roboto';
  bool get displayMediumIsCustom => false;
  TextStyle get displayMedium => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 45.0,
      );
  String get displaySmallFamily => 'Roboto';
  bool get displaySmallIsCustom => false;
  TextStyle get displaySmall => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 36.0,
      );
  String get headlineLargeFamily => 'Roboto';
  bool get headlineLargeIsCustom => false;
  TextStyle get headlineLarge => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 32.0,
      );
  String get headlineMediumFamily => 'Roboto';
  bool get headlineMediumIsCustom => false;
  TextStyle get headlineMedium => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 32.0,
      );
  String get headlineSmallFamily => 'Roboto';
  bool get headlineSmallIsCustom => false;
  TextStyle get headlineSmall => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      );
  String get titleLargeFamily => 'Roboto';
  bool get titleLargeIsCustom => false;
  TextStyle get titleLarge => GoogleFonts.roboto(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 22.0,
      );
  String get titleMediumFamily => 'Manrope';
  bool get titleMediumIsCustom => false;
  TextStyle get titleMedium => GoogleFonts.manrope(
        color: theme.info,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  String get titleSmallFamily => 'Manrope';
  bool get titleSmallIsCustom => false;
  TextStyle get titleSmall => GoogleFonts.manrope(
        color: theme.info,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get labelLargeFamily => 'Manrope';
  bool get labelLargeIsCustom => false;
  TextStyle get labelLarge => GoogleFonts.manrope(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  String get labelMediumFamily => 'Manrope';
  bool get labelMediumIsCustom => false;
  TextStyle get labelMedium => GoogleFonts.manrope(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get labelSmallFamily => 'Manrope';
  bool get labelSmallIsCustom => false;
  TextStyle get labelSmall => GoogleFonts.manrope(
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
      );
  String get bodyLargeFamily => 'Manrope';
  bool get bodyLargeIsCustom => false;
  TextStyle get bodyLarge => GoogleFonts.manrope(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  String get bodyMediumFamily => 'Manrope';
  bool get bodyMediumIsCustom => false;
  TextStyle get bodyMedium => GoogleFonts.manrope(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get bodySmallFamily => 'Manrope';
  bool get bodySmallIsCustom => false;
  TextStyle get bodySmall => GoogleFonts.manrope(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
      );
}

class DarkModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF2797FF);
  late Color secondary = const Color(0xFF0B67BC);
  late Color tertiary = const Color(0xFFACC420);
  late Color alternate = const Color(0xFF2B3743);
  late Color primaryText = const Color(0xFFFFFFFF);
  late Color secondaryText = const Color(0xFF919BAB);
  late Color primaryBackground = const Color(0xFF333333);
  late Color secondaryBackground = const Color(0xFF212B36);
  late Color accent1 = const Color(0x4C2797FF);
  late Color accent2 = const Color(0x4C0B67BC);
  late Color accent3 = const Color(0x4DACC420);
  late Color accent4 = const Color(0xB3161C24);
  late Color success = const Color(0xFF27AE52);
  late Color warning = const Color(0xFFFC964D);
  late Color error = const Color(0xFFEE4444);
  late Color info = const Color(0xFFFFFFFF);

  late Color tertiaryText = const Color(0xFF999FA8);
  late Color blackText = const Color(0xFFffffff);
  late Color labelText = const Color(0xFF707172);
  late Color circularTextColor = const Color(0xFFf9f9f9);
  late Color secondary2 = const Color(0xFF5894A8);
  late Color redFill = const Color(0xFFECA375);
  late Color orangeFill = const Color(0xFF188ABD);
  late Color yellowFill = const Color(0xFF162265);
  late Color greenFill = const Color(0xFF696A2D);
  late Color purpleFill = const Color(0xFF2878B2);
  late Color brownFill = const Color(0xFF181E10);
  late Color greyFill = const Color(0xFF9C6C30);
  late Color whiteFill = const Color(0xFF9C6C30);
  late Color redBorder = const Color(0xFFA12B40);
  late Color orangeBorder = const Color(0xFF192102);
  late Color yellowBorder = const Color(0xFFCEEFF2);
  late Color greenBorder = const Color(0xFF079BF1);
  late Color purpleBorder = const Color(0xFF895E76);
  late Color brownBorder = const Color(0xFF593297);
  late Color whiteBorder = const Color(0xFF080391);
  late Color greyDark = const Color(0xFFC0BDBB);
  late Color brownDark = const Color(0xFF8D6E63);
  late Color redDark = const Color(0xFFE63946);
  late Color orangeDark = const Color(0xFFF77F00);
  late Color yellowDark = const Color(0xFFF4D35E);
  late Color greenDark = const Color(0xFF4CAF50);
  late Color purpleDark = const Color(0xFF6A0572);
  late Color textGrey = const Color(0xFF434343);
  late Color textWhite = const Color(0xFFFFFFFF);
  late Color textGreen = const Color(0xFF195f5d);
  late Color bgGreen = const Color(0xFF5db494);
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    TextStyle? font,
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = false,
    TextDecoration? decoration,
    double? lineHeight,
    List<Shadow>? shadows,
    String? package,
  }) {
    if (useGoogleFonts && fontFamily != null) {
      font = GoogleFonts.getFont(fontFamily,
          fontWeight: fontWeight ?? this.fontWeight,
          fontStyle: fontStyle ?? this.fontStyle);
    }

    return font != null
        ? font.copyWith(
            color: color ?? this.color,
            fontSize: fontSize ?? this.fontSize,
            letterSpacing: letterSpacing ?? this.letterSpacing,
            fontWeight: fontWeight ?? this.fontWeight,
            fontStyle: fontStyle ?? this.fontStyle,
            decoration: decoration,
            height: lineHeight,
            shadows: shadows,
          )
        : copyWith(
            fontFamily: fontFamily ?? 'Montserrat',
            package: package,
            color: color,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            decoration: decoration,
            height: lineHeight,
            shadows: shadows,
          );
  }
}
