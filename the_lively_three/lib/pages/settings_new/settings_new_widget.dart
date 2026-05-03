import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
import 'package:the_lively_three/components/fluid_bg/setting_bg_widget.dart';
import 'package:the_lively_three/custom_code/widgets/f_f_wheel_picker.dart'
    as custom_widgets;
import 'package:the_lively_three/custom_code/widgets/silver_button_widget.dart';
import 'package:the_lively_three/custom_code/widgets/switchButton.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_widgets.dart';
import 'package:the_lively_three/flutter_flow/nav/nav.dart'
    show kTransitionInfoKey, TransitionInfo;
import 'package:the_lively_three/l10n/app_localizations.dart';
import 'package:the_lively_three/pages/data_contracts/data_contracts_widget.dart';
import 'package:the_lively_three/pages/delete_account/delete_account_widget.dart';
import 'package:the_lively_three/pages/settings_new/settings_new_model.dart';
import 'package:the_lively_three/pages/subscription/subscription_widget.dart';
import 'package:the_lively_three/custom_code/widgets/openCamera.dart';
import 'package:the_lively_three/utils/loader_util.dart';
import '/providers/locale_provider.dart' as locale_provider;
import 'package:supabase_flutter/supabase_flutter.dart';
import '/utils/update_user_communities_service.dart';
import 'package:go_router/go_router.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/index.dart';

class SettingsNewPage extends StatefulWidget {
  static String routeName = 'settings-new';
  static String routePath = '/settings-new';
  const SettingsNewPage({super.key});

  @override
  _SettingView createState() => _SettingView();
}

class _SettingView extends State<SettingsNewPage> {
  final supabase = Supabase.instance.client;
  final updateUserCommunity = CommunitySyncService();
  final PageController _controller = PageController();

  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> genderList = [];
  List<Map<String, dynamic>> countryList = [];
  bool isLoading = true;
  String? selectedGenderText;
  int? selectedCountryKeycode;
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  DateTime? selectedBirthdate;
  int? calculatedAge;
  int weightValue = 50;
  // String weightUnit = "kg";
  double? weight;
  String? weightUnit;
  String? appNameFromDB;
  String? appVersion;
  bool? selectedSubscriptionActive;
  DateTime? selectedSubscriptionExpiry;
  Locale? currentLocale;

  List<String> features = [
    'Community Insights to Boost Habit Building',
    'Monitor Long-Term Progress',
    'Detailed Nutrient Insights',
    'Get Personalised Recommendations & Alerts',
    'Calculate & Reduce Your Environmental Footprint',
  ];

  final List<String> _monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  final List<Map<String, dynamic>> primaryGoalList = [
    {'id': 1, 'label': 'General Health'},
    {'id': 2, 'label': 'Weight Loss'},
    {'id': 3, 'label': 'Muscle Gain'},
    {'id': 4, 'label': 'Improve Energy'},
    {'id': 5, 'label': 'Healthy Aging'},
  ];

  late final SettingsNewModel _model;
  final TextEditingController weightController = TextEditingController();

  late var currentScreen = 'SettingsMenu';
  @override
  void initState() {
    super.initState();

    _model = SettingsNewModel();
    _fetchUserData();
    _fetchAppInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the FFAppState locale here
    currentLocale = Provider.of<locale_provider.FFAppState>(context).locale;
    print('Locale :- $currentLocale');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchAppInfo() async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('codelkup')
        .select('key1, key2')
        .eq('lkcode', 'App Name')
        .maybeSingle();

    setState(() {
      appNameFromDB = response?['key1'] ?? 'The Lively Three';
      appVersion = response?['key2'] ?? '0.95.0+18';
    });
  }

  Future<void> _fetchUserData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // Fetch lookups
      final genderResponse = await supabase
          .from('codelkup')
          .select('keycode, key1')
          .eq('lkcode', 'Gender');

      final countryResponse = await supabase
          .from('codelkup')
          .select('keycode, key1')
          .eq('lkcode', 'countries_with_flag');

      genderList = List<Map<String, dynamic>>.from(genderResponse);
      countryList = List<Map<String, dynamic>>.from(countryResponse);
      print('genderlist $genderList');
      // Fetch user
      final userResponse =
          await supabase.from('users').select().eq('id', user.id).maybeSingle();

      if (userResponse == null) return;

      final vitalResponse = await supabase
          .from('user_vitals')
          .select('value, unit, created_at')
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      // Convert country from text to int (safe parse)
      final countryValue = int.tryParse(userResponse['country'] ?? '');
      final birthdateStr = userResponse['birthdate'];

      DateTime? birthdate;
      if (birthdateStr != null && birthdateStr != '') {
        birthdate = DateTime.tryParse(birthdateStr.toString());
      }

      // Resolve readable names
      final countryDisplay = countryList.firstWhere(
        (c) => c['keycode'] == countryValue,
        orElse: () => {'key1': userResponse['country'] ?? ''},
      )['key1'];

      // SUBSCRIPTION FETCH PROCESS
      final originalSubscriptionId = userResponse['original_subscription_id'];

      Map<String, dynamic>? subscriptionDetails;

      if (originalSubscriptionId != null) {
        subscriptionDetails = await supabase
            .from('subscription')
            .select('name, price, currency')
            .eq('id', originalSubscriptionId)
            .eq('locale', currentLocale as Object)
            .maybeSingle();
      }

      setState(() {
        userData = {
          'user_name': userResponse['user_name'] ?? '',
          'email': userResponse['email'] ?? '',
          'gender': userResponse['gender'] ?? '',
          'country': countryDisplay,
          'vital_value': vitalResponse != null ? vitalResponse['value'] : null,
          'vital_unit': vitalResponse != null ? vitalResponse['unit'] : null,
          'subscription_active': userResponse['has_subscription'] ?? false,
          'subscription_expires_at': userResponse['subscription_expires_at'],
          // Subscription details (may be null)
          'subscription_name': subscriptionDetails?['name'],
          'subscription_price': subscriptionDetails?['price'],
          'subscription_currency': subscriptionDetails?['currency'],
        };
        DateTime? subscriptionExpiry;
        final subExpiryStr = userResponse['subscription_expires_at'];
        if (subExpiryStr != null && subExpiryStr != '') {
          subscriptionExpiry = DateTime.tryParse(subExpiryStr.toString());
        }

        selectedGenderText = userResponse['gender'];
        selectedCountryKeycode = countryValue;
        selectedBirthdate = birthdate;
        selectedDay = birthdate != null ? birthdate.day.toString() : null;
        selectedMonth =
            birthdate != null ? _monthNames[birthdate.month - 1] : null;
        selectedYear = birthdate != null ? birthdate.year.toString() : null;
        selectedSubscriptionActive = userResponse['has_subscription'] ?? false;
        selectedSubscriptionExpiry = subscriptionExpiry;

        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _setCurrentScreen(String value) {
    setState(() => currentScreen = value);
  }

  bool get showFreeEdition {
    if (selectedSubscriptionActive == true &&
        selectedSubscriptionExpiry != null &&
        DateTime.now().toUtc().isBefore(selectedSubscriptionExpiry!)) {
      return false; // user has an active subscription → hide free edition
    }
    return true; // Show free edition otherwise
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // Set this to your app's background color
      statusBarIconBrightness: Brightness.dark, // For light icons in status bar
    ));
    final l10n = AppLocalizations.of(context)!;
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: Color(0xffececec),
      resizeToAvoidBottomInset: true,
      extendBody: false,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            const SettingsBG(),
            Container(
                height: MediaQuery.sizeOf(context).height,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (currentScreen == 'SettingsMenu')
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 12,
                            children: [
                              Column(
                                spacing: 40,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          context.pushNamed(
                                            HomepageWidget.routeName,
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey:
                                                  const TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType
                                                        .bottomToTop,
                                              ),
                                            },
                                          );
                                        },
                                        child: Icon(Icons.chevron_left,
                                            color: theme.primaryText),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width -
                                                64,
                                        child: Text(
                                          'Settings',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 18),
                                            fontWeight: FontWeight.w700,
                                            color: theme.primaryText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    spacing: 20,
                                    children: [
                                      _buildMenuItems(
                                          Icons.account_circle_outlined,
                                          'Account', () {
                                        _fetchUserData();
                                        _setCurrentScreen('Account');
                                      }),
                                      _buildMenuItems(Icons.density_medium,
                                          'Data Transparency', () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const DataContractPage(),
                                          ),
                                        );
                                      }),
                                      _buildMenuItems(Icons.notification_add,
                                          'Notifications', () {
                                        _setCurrentScreen('Notifications');
                                      }),
                                      _buildMenuItems(
                                          Icons.book, 'Nutrition Profile', () {
                                        _setCurrentScreen('Nutrition Profile');
                                      }),
                                      _buildMenuItems(Icons.mail, 'Support',
                                          () {
                                        _setCurrentScreen('Support');
                                      }),
                                      _buildMenuItems(
                                          Icons.content_paste, 'Privacy Policy',
                                          () {
                                        // _setCurrentScreen('Privacy Policy');
                                      }),
                                      _buildMenuItems(
                                          Icons.exit_to_app, 'Log Out',
                                          () async {
                                        try {
                                          LoaderUtils.showLoader(context);
                                          await authManager.signOut();
                                          LoaderUtils.hideLoader(
                                              context); // Hide loader

                                          // Navigate to login page using GoRouter
                                          if (mounted) {
                                            context.go('/login');
                                          }
                                        } catch (e) {
                                          LoaderUtils.hideLoader(context);
                                          // Show error message
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Logout failed: $e')),
                                          );
                                        }
                                      }),
                                    ],
                                  ),
                                  Column(
                                    spacing: 20,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text:
                                              '${appNameFromDB ?? 'The Lively Three'}\n',
                                          style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 12),
                                              height: 1.667,
                                              color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text:
                                                  'Version ${appVersion ?? ''}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/swiss_made_logo.png',
                                        width: 100,
                                        height: 113,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (currentScreen == 'Account')
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 12,
                            children: [
                              Column(
                                spacing: 40,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _setCurrentScreen('SettingsMenu');
                                        },
                                        child: Icon(Icons.chevron_left,
                                            color: theme.primaryText),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width -
                                                64,
                                        child: Text(
                                          'Account',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 18),
                                            fontWeight: FontWeight.w700,
                                            color: theme.primaryText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    spacing: 16,
                                    children: [
                                      _buildAddPhotoSection(context),

                                      // User info fields
                                      _buildTextField('user_name', "User Name",
                                          userData?['user_name'] ?? ''),
                                      _buildTextField('email', "Email",
                                          userData?['email'] ?? ''),
                                      _buildCountryDropdown(),
                                      _buildGenderDropdown(),
                                      if (showFreeEdition) _buildFreeEdition(),
                                      if (!showFreeEdition) _buildProEdition(),

                                      const SizedBox(
                                        height: 24,
                                      ),
                                      GestureDetector(
                                        onTap: () => showModalBottomSheet<
                                            Map<String, dynamic>>(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              deleteAccountPopup(),
                                        ),
                                        // onTap: () async {
                                        //   // Get current user email
                                        //   final user = Supabase
                                        //       .instance.client.auth.currentUser;
                                        //   final userEmail = user?.email;

                                        //   if (userEmail == null) {
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(
                                        //       const SnackBar(
                                        //           content: Text(
                                        //               'No user logged in')),
                                        //     );
                                        //     return;
                                        //   }

                                        //   // Show confirmation dialog
                                        //   final bool? confirmed =
                                        //       await showDialog<bool>(
                                        //     context: context,
                                        //     builder:
                                        //         (BuildContext dialogContext) {
                                        //       return AlertDialog(
                                        //         title: const Text(
                                        //             'Delete Account'),
                                        //         content: const Text(
                                        //           'Are you sure you want to delete your account? This action cannot be undone.',
                                        //         ),
                                        //         actions: [
                                        //           TextButton(
                                        //             onPressed: () =>
                                        //                 Navigator.of(
                                        //                         dialogContext)
                                        //                     .pop(false),
                                        //             child: const Text('Cancel'),
                                        //           ),
                                        //           TextButton(
                                        //             onPressed: () =>
                                        //                 Navigator.of(
                                        //                         dialogContext)
                                        //                     .pop(true),
                                        //             style: TextButton.styleFrom(
                                        //               foregroundColor:
                                        //                   const Color(
                                        //                       0xffff2236),
                                        //             ),
                                        //             child: const Text(
                                        //                 'Yes, Delete'),
                                        //           ),
                                        //         ],
                                        //       );
                                        //     },
                                        //   );

                                        //   // If user cancelled, do nothing
                                        //   if (confirmed != true) return;

                                        //   // Show loading indicator
                                        //   showDialog(
                                        //     context: context,
                                        //     barrierDismissible: false,
                                        //     builder: (loadingContext) =>
                                        //         const Center(
                                        //       child:
                                        //           CircularProgressIndicator(),
                                        //     ),
                                        //   );

                                        //   try {
                                        //     // Call the Supabase function with correct parameter name
                                        //     await Supabase.instance.client.rpc(
                                        //       'delete_user_by_email',
                                        //       params: {
                                        //         'p_email': userEmail
                                        //       }, // Changed from 'user_email' to 'p_email'
                                        //     );

                                        //     // Sign out the user after deletion
                                        //     await Supabase.instance.client.auth
                                        //         .signOut();

                                        //     // Close loading indicator
                                        //     if (context.mounted) {
                                        //       Navigator.of(context).pop();
                                        //     }

                                        //     // Navigate to login page
                                        //     if (context.mounted) {
                                        //       Navigator.of(context)
                                        //           .pushNamedAndRemoveUntil(
                                        //         '/login',
                                        //         (route) => false,
                                        //       );

                                        //       // Show success message after navigation
                                        //       Future.delayed(
                                        //           const Duration(
                                        //               milliseconds: 200), () {
                                        //         if (context.mounted) {
                                        //           ScaffoldMessenger.of(context)
                                        //               .showSnackBar(
                                        //             const SnackBar(
                                        //               content: Text(
                                        //                   'Account successfully deleted'),
                                        //               backgroundColor:
                                        //                   Colors.green,
                                        //               duration:
                                        //                   Duration(seconds: 3),
                                        //             ),
                                        //           );
                                        //         }
                                        //       });
                                        //     }
                                        //   } catch (e) {
                                        //     print('Error deleting account: $e');

                                        //     // Close loading indicator
                                        //     if (context.mounted) {
                                        //       Navigator.of(context).pop();
                                        //     }

                                        //     // Show error message
                                        //     if (context.mounted) {
                                        //       ScaffoldMessenger.of(context)
                                        //           .showSnackBar(
                                        //         SnackBar(
                                        //           content: Text(
                                        //               'Error: ${e.toString()}'),
                                        //           backgroundColor: Colors.red,
                                        //           duration: const Duration(
                                        //               seconds: 5),
                                        //         ),
                                        //       );
                                        //     }
                                        //   }
                                        // },

                                        child: Text(
                                          'Delete Your Account',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 12),
                                            color: Color(0xffff2236),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      // Date of birth section
                                      // _buildDateOfBirthSection(),
                                      // Container(
                                      //   width: double.infinity,
                                      //   height: 1,
                                      //   color: Color(0xffececec),
                                      // ),
                                      // // Weight section
                                      // _buildWeightSection(),
                                      // Container(
                                      //   width: double.infinity,
                                      //   height: 1,
                                      //   color: Color(0xffececec),
                                      // ),
                                      // // Instruction text
                                      // _buildInstructionText(),

                                      // // Buttons
                                      // _buildSaveButton(),
                                      // _buildButtonsSection(null),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (currentScreen == 'Data Transparency')
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 12,
                            children: [
                              DataContractPage(
                                onBackButton: () {
                                  _setCurrentScreen('SettingsMenu');
                                },
                              ),
                            ],
                          ),
                        ),
                      if (currentScreen == 'Notifications')
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 12,
                            children: [
                              Column(
                                spacing: 40,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _setCurrentScreen('SettingsMenu');
                                        },
                                        child: Icon(Icons.chevron_left,
                                            color: theme.primaryText),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width -
                                                64,
                                        child: Text(
                                          'Notifications',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 18),
                                            fontWeight: FontWeight.w700,
                                            color: theme.primaryText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    spacing: 16,
                                    children: [
                                      _buildNotificationCard(
                                          notificationTilte: 'Beginner Tips',
                                          notificationDesc:
                                              'Suggestions and use cases for the first few days of your journey.',
                                          notificationStatus: true),
                                      _buildNotificationCard(
                                          notificationTilte: 'Weekly Insights',
                                          notificationDesc:
                                              'Facts and figures about your use of application.',
                                          notificationStatus: true),
                                      _buildNotificationCard(
                                          notificationTilte: 'Product Updates',
                                          notificationDesc:
                                              'To introduce new features.',
                                          notificationStatus: true),
                                      _buildNotificationCard(
                                          notificationTilte:
                                              'Subscription Offers',
                                          notificationDesc:
                                              'Get access to special discounts and premium features.',
                                          notificationStatus: true),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (currentScreen == 'Nutrition Profile')
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 12,
                            children: [
                              Column(
                                spacing: 40,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _setCurrentScreen('SettingsMenu');
                                        },
                                        child: Icon(Icons.chevron_left,
                                            color: theme.primaryText),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width -
                                                64,
                                        child: Text(
                                          'Nutrition Profile',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 18),
                                            fontWeight: FontWeight.w700,
                                            color: theme.primaryText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    spacing: 12,
                                    children: [
                                      Row(
                                        spacing: 6,
                                        children: [
                                          _buildNutritionProfileCard(
                                              nutrientName: 'Protein Goal',
                                              nutrientValue: 1.6,
                                              nutrientColor:
                                                  const Color.fromRGBO(
                                                      54, 180, 173, 1),
                                              cardWidth:
                                                  (MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.33) -
                                                      14),
                                          _buildNutritionProfileCard(
                                              nutrientName: 'Fiber Goal',
                                              nutrientValue: 30,
                                              nutrientColor:
                                                  const Color.fromRGBO(
                                                      222, 138, 116, 1),
                                              cardWidth:
                                                  (MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.33) -
                                                      14),
                                          _buildNutritionProfileCard(
                                              nutrientName: 'Water Goal',
                                              nutrientValue: 1.6,
                                              nutrientColor:
                                                  const Color.fromRGBO(
                                                      95, 196, 248, 1),
                                              cardWidth:
                                                  (MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.33) -
                                                      14),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        'Your body’s nutrient needs depend on the personal factors below. Update your information to receive the most accurate guidance.',
                                        style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 12),
                                            height: 1.67,
                                            color: FlutterFlowTheme.of(context)
                                                .textGrey),
                                        textAlign: TextAlign.center,
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Date of Birth',
                                        itemWidget: _buildDummyDropdown(
                                          inputValue: '01 January 2000',
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldDesc:
                                                'Protein requirements are most directly correlated with your weight. ',
                                            editingFieldName: 'Your weight',
                                            editingFieldType: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              spacing: 4,
                                              children: [
                                                // Day Dropdown
                                                _buildDropdown(
                                                  width: FlutterFlowTheme
                                                      .adjustScale(
                                                          size: 76,
                                                          largeScreenMargin:
                                                              10),
                                                  value: selectedDay,
                                                  hint: "Day",
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedDay = newValue;
                                                      _updateSelectedBirthdate();
                                                    });
                                                  },
                                                  items: List.generate(
                                                      31,
                                                      (index) => (index + 1)
                                                          .toString()),
                                                ),

                                                // Month Dropdown
                                                _buildDropdown(
                                                  width: FlutterFlowTheme
                                                      .adjustScale(
                                                          size: 110,
                                                          largeScreenMargin:
                                                              30),
                                                  value: selectedMonth,
                                                  hint: "Month",
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedMonth = newValue;
                                                      _updateSelectedBirthdate();
                                                    });
                                                  },
                                                  items: _monthNames,
                                                ),

                                                // Year Dropdown
                                                _buildDropdown(
                                                  width: 90,
                                                  value: selectedYear,
                                                  hint: "Year",
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedYear = newValue;
                                                      _updateSelectedBirthdate();
                                                    });
                                                  },
                                                  items: List.generate(
                                                    100,
                                                    (index) =>
                                                        (DateTime.now().year -
                                                                index)
                                                            .toString(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Your height:',
                                        itemWidget: InkWell(
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldDesc:
                                                'Height, together with weight, is a primary determinant of your daily energy and nutrient requirements.',
                                            editingFieldName: 'Your height',
                                            editingFieldType: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                custom_widgets.FFWheelPicker(
                                                  key: ValueKey(
                                                      'weight_picker_$weightUnit'),
                                                  width: 100,
                                                  height: 220.0,
                                                  min: (weightUnit == "kg")
                                                      ? 20
                                                      : 44, // ~20kg in lbs
                                                  max: (weightUnit == "kg")
                                                      ? 800
                                                      : 1760, // ~800kg in lbs
                                                  step: 1,
                                                  initialValue:
                                                      weightValue, // ✅ use stored value directly
                                                  itemExtent: 48.0,
                                                  selectedFontSize: 22.0,
                                                  unselectedFontSize: 18.0,
                                                  selectedChipRadius: 12.0,
                                                  chipHPadding: 16.0,
                                                  chipVPadding: 8.0,
                                                  diameterRatio: 2.0,
                                                  perspective: 0.003,
                                                  offAxisFraction: 0.0,
                                                  suffix: '',
                                                  loop: false,
                                                  haptics: true,
                                                  selectedTextColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .blackText,
                                                  unselectedTextColor:
                                                      Color(0xFF9E9E9E),
                                                  selectedChipColor:
                                                      Colors.transparent,
                                                  onChanged: (value) {},
                                                ),
                                                custom_widgets.FFWheelPicker(
                                                  key: const ValueKey(
                                                      'weight_unit_picker'),
                                                  items: const ["kg", "lbs"],
                                                  width: 100,
                                                  initialItem: weightUnit,
                                                  selectedChipRadius: 12.0,
                                                  selectedTextColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .blackText,
                                                  selectedChipColor:
                                                      Colors.transparent,
                                                  onChanged: (value) {},
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: Row(
                                            spacing: 6,
                                            children: [
                                              _buildMeasurementBox(
                                                  value: '180'),
                                              _buildMeasurementBox(value: 'cm'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Your weight:',
                                        itemWidget: InkWell(
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldDesc:
                                                'Fiber and Protein requirements vary by age. We will also use this for community metrics.',
                                            editingFieldName: 'Date of Birth',
                                            editingFieldType: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                custom_widgets.FFWheelPicker(
                                                  key: ValueKey(
                                                      'weight_picker_$weightUnit'),
                                                  width: 100,
                                                  height: 220.0,
                                                  min: (weightUnit == "kg")
                                                      ? 20
                                                      : 44, // ~20kg in lbs
                                                  max: (weightUnit == "kg")
                                                      ? 800
                                                      : 1760, // ~800kg in lbs
                                                  step: 1,
                                                  initialValue:
                                                      weightValue, // ✅ use stored value directly
                                                  itemExtent: 48.0,
                                                  selectedFontSize: 22.0,
                                                  unselectedFontSize: 18.0,
                                                  selectedChipRadius: 12.0,
                                                  chipHPadding: 16.0,
                                                  chipVPadding: 8.0,
                                                  diameterRatio: 2.0,
                                                  perspective: 0.003,
                                                  offAxisFraction: 0.0,
                                                  suffix: '',
                                                  loop: false,
                                                  haptics: true,
                                                  selectedTextColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .blackText,
                                                  unselectedTextColor:
                                                      Color(0xFF9E9E9E),
                                                  selectedChipColor:
                                                      Colors.transparent,
                                                  onChanged: (value) {},
                                                ),
                                                custom_widgets.FFWheelPicker(
                                                  key: const ValueKey(
                                                      'weight_unit_picker'),
                                                  items: const ["kg", "lbs"],
                                                  width: 100,
                                                  initialItem: weightUnit,
                                                  selectedChipRadius: 12.0,
                                                  selectedTextColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .blackText,
                                                  selectedChipColor:
                                                      Colors.transparent,
                                                  onChanged: (value) {},
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: Row(
                                            spacing: 6,
                                            children: [
                                              _buildMeasurementBox(value: '65'),
                                              _buildMeasurementBox(value: 'kg'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Gender:',
                                        itemWidget: _buildDummyDropdown(
                                          inputValue: 'Male',
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldDesc:
                                                'Micronutrient requirements based on gender since there are some small differences.',
                                            editingFieldName: 'Gender',
                                            editingFieldType: SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                                .height *
                                                            0.48 -
                                                        150,
                                                child: SingleChildScrollView(
                                                    child:
                                                        _buildRadioButtonList(
                                                            data: genderList,
                                                            selectedValue: 1))),
                                          ),
                                        ),
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Ethnicity:',
                                        itemWidget: _buildDummyDropdown(
                                          inputValue: 'Caucasion',
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldName: 'Ethnicity',
                                            editingFieldType: SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                                .height *
                                                            0.48 -
                                                        150,
                                                child: SingleChildScrollView(
                                                    child:
                                                        _buildRadioButtonList(
                                                            data: genderList,
                                                            selectedValue: 1))),
                                          ),
                                        ),
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Country of Residence:',
                                        itemWidget: _buildDummyDropdown(
                                          inputValue: 'Canada',
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldName:
                                                'Country of Residence',
                                            editingFieldType: SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                                .height *
                                                            0.48 -
                                                        150,
                                                child: SingleChildScrollView(
                                                    child:
                                                        _buildRadioButtonList(
                                                            data: genderList,
                                                            selectedValue: 1))),
                                          ),
                                        ),
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Primary Goal:',
                                        itemWidget: _buildDummyDropdown(
                                          inputValue: 'General Health',
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldName: 'Primary Goal',
                                            editingFieldType: SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                                .height *
                                                            0.48 -
                                                        150,
                                                child: SingleChildScrollView(
                                                    child:
                                                        _buildRadioButtonList(
                                                            data:
                                                                primaryGoalList,
                                                            selectedValue: 1))),
                                          ),
                                        ),
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Secondary Goal:',
                                        itemWidget: _buildDummyDropdown(
                                          inputValue: 'Healthy Aging',
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldName: 'Secondary Goal',
                                            editingFieldType: SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                                .height *
                                                            0.48 -
                                                        150,
                                                child: SingleChildScrollView(
                                                    child:
                                                        _buildRadioButtonList(
                                                            data: genderList,
                                                            selectedValue: 1))),
                                          ),
                                        ),
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Activity Level:',
                                        itemWidget: _buildDummyDropdown(
                                          inputValue: 'Medium',
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldName: 'Activity Level',
                                            editingFieldType: SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                                .height *
                                                            0.48 -
                                                        150,
                                                child: SingleChildScrollView(
                                                    child:
                                                        _buildRadioButtonList(
                                                            data: genderList,
                                                            selectedValue: 1))),
                                          ),
                                        ),
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Water Goals:',
                                        itemWidget: _buildDummyDropdown(
                                          inputValue: '1.5 L',
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldName: 'Water Goals',
                                            editingFieldType: SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                                .height *
                                                            0.48 -
                                                        150,
                                                child: SingleChildScrollView(
                                                    child:
                                                        _buildRadioButtonList(
                                                            data: genderList,
                                                            selectedValue: 1))),
                                          ),
                                        ),
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Dietary Preferences:',
                                        itemWidget: _buildDummyDropdown(
                                          inputValue: 'Vegan',
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldName:
                                                'Dietary Preferences',
                                            editingFieldType: SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                                .height *
                                                            0.48 -
                                                        150,
                                                child: SingleChildScrollView(
                                                    child:
                                                        _buildRadioButtonList(
                                                            data: genderList,
                                                            selectedValue: 1))),
                                          ),
                                        ),
                                      ),
                                      _buildNutritionProfileItems(
                                        itemName: 'Foods to Avoid:',
                                        itemWidget: _buildDummyDropdown(
                                          inputValue: 'Gluten • Dairy',
                                          onTap: () => _showEditingFieldSheet(
                                            context,
                                            editingFieldName: 'Foods to Avoid:',
                                            editingFieldType: SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                                .height *
                                                            0.48 -
                                                        150,
                                                child: SingleChildScrollView(
                                                    child:
                                                        _buildRadioButtonList(
                                                            data: genderList,
                                                            selectedValue: 1))),
                                          ),
                                        ),
                                      ),
                                      Stack(
                                          clipBehavior: Clip.none,
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 28,
                                                  bottom: 18,
                                                  left: 20,
                                                  right: 20),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      style: BorderStyle.solid,
                                                      color: Color.fromRGBO(
                                                          230, 57, 73, 1)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                    text:
                                                        'Nutrition suggestions provided in this app are based on general scientific guidelines. Every individual is different, and these recommendations may not suit everyone. ',
                                                    style: TextStyle(
                                                      fontSize: FlutterFlowTheme
                                                          .adjustScale(
                                                              size: 12),
                                                      height: 1.5,
                                                      color: Colors.black,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            'Please consult your doctor ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'or a registered dietitian before making significant changes to your diet.',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                            Positioned(
                                                top: -18,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: const Icon(
                                                      Icons.warning_amber,
                                                      color: Colors.white,
                                                      size: 18),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: const Color
                                                              .fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              1), // rgba(255, 255, 255, 1)
                                                          offset: const Offset(
                                                              0, 0), // x=0, y=0
                                                          blurRadius:
                                                              0, // no blur
                                                          spreadRadius:
                                                              0.66, // equivalent to the 0.66px "outline" effect
                                                        ),
                                                        BoxShadow(
                                                          color: const Color
                                                              .fromRGBO(
                                                              129,
                                                              129,
                                                              129,
                                                              0.2), // rgba(129, 129, 129, 0.2)
                                                          offset: const Offset(
                                                              0, 2), // x=0, y=2
                                                          blurRadius:
                                                              5, // blur radius
                                                          spreadRadius:
                                                              0, // no spread
                                                        ),
                                                      ],
                                                      color: Color.fromRGBO(
                                                          230, 57, 73, 1)),
                                                )),
                                          ]),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (currentScreen == 'Support')
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 12,
                            children: [
                              Column(
                                spacing: 40,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _setCurrentScreen('SettingsMenu');
                                        },
                                        child: Icon(Icons.chevron_left,
                                            color: theme.primaryText),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width -
                                                64,
                                        child: Text(
                                          'Support',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 18),
                                            fontWeight: FontWeight.w700,
                                            color: theme.primaryText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    spacing: 16,
                                    children: [
                                      TextField(
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          labelText: 'Query',
                                          alignLabelWithHint: true,
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily,
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 14),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelMediumIsCustom,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          contentPadding:
                                              const EdgeInsets.all(18.0),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 14),
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                      const SizedBox(height: 20),
                                      FFButtonWidget(
                                        onPressed: () {},
                                        text: 'Send mail',
                                        options: FFButtonOptions(
                                          width:
                                              MediaQuery.sizeOf(context).width -
                                                  24,
                                          height: 50,
                                          padding: const EdgeInsets.all(18),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmallFamily,
                                                color: Colors.white,
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 14),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmallIsCustom,
                                              ),
                                          elevation: 3.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget deleteAccountPopup() {
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
                    Container(
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 12, left: 10, right: 10),
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                                text:
                                    'You currently have an active subscription with this account.',
                                style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 14),
                                  height: 1.62,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Please cancel your current subscription to ensure that you are not charged for an inactive account.',
                      style: TextStyle(
                          fontSize: 12,
                          color: FlutterFlowTheme.of(context).textGrey,
                          height: 1.667),
                      textAlign: TextAlign.center,
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UpgradeSubscriptionPage(
                              onSuccess: 'Settings',
                              onFailure: 'Settings',
                              openFullPage: true,
                            ),
                          ),
                        );
                      },
                      text: 'Cancel Subscription',
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
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DeleteAccountPage(),
                          ),
                        );
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
                          'Continue To Delete',
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

  Widget _buildMenuItems(settingIcon, settingName, action) {
    return Column(
      children: [
        InkWell(
          onTap: action,
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16, vertical: 16),
            child: Row(
              spacing: 12,
              children: [
                Icon(
                  settingIcon,
                  size: 14,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                Text(
                  settingName,
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: const Color(0xffececec),
          height: 1,
          width: MediaQuery.sizeOf(context).width - 40,
        )
      ],
    );
  }

  Widget _buildNutritionProfileItems(
      {required Widget itemWidget, required String itemName}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  itemName,
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    height: 1.2,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              itemWidget,
            ],
          ),
        ),
        Container(
          color: const Color(0xffececec),
          height: 1,
          width: MediaQuery.sizeOf(context).width - 40,
        )
      ],
    );
  }

  Widget _buildAddPhotoSection(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final file = await showPhotoPicker(context);
        if (file != null) {
          // do something with the image
          print("Selected image: ${file.path}");
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xfff8f8f8),
            ),
            child: const Icon(Icons.account_circle,
                size: 48, color: Color(0xffcecece)),
          ),
          Text(
            "Add Photo",
            style: TextStyle(
                color: Colors.black,
                fontSize: FlutterFlowTheme.adjustScale(size: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String key, String hintText, String value) {
    final controller = TextEditingController(text: value);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffd3d3d3)),
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xfff9f9f9),
      ),
      child: TextField(
        controller: controller,
        onChanged: (newValue) {
          setState(() {
            userData?[key] = newValue; // ✅ Update userData dynamically
          });
        },
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: FlutterFlowTheme.of(context).primaryText),
          suffixIcon: const Icon(
            Icons.edit,
            size: 16,
            color: Color(0xff818181),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffd3d3d3)),
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xfff9f9f9),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedGenderText,
          hint: Text(userData?['gender'] ?? 'Select Gender'),
          items: genderList.map((g) {
            return DropdownMenuItem<String>(
              value: g['key1'], // store key1 text
              child: Text(g['key1']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedGenderText = value;
              userData!['gender'] = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffd3d3d3)),
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xfff9f9f9),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: selectedCountryKeycode,
          hint: Text(userData?['country'] ?? 'Select Country'),
          items: countryList.map((c) {
            return DropdownMenuItem<int>(
              value: c['keycode'] as int,
              child: Text(c['key1']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCountryKeycode = value;
              final selected = countryList.firstWhere(
                (c) => c['keycode'] == value,
                orElse: () => {'key1': ''},
              );
              userData!['country'] = selected['key1'];
            });
          },
        ),
      ),
    );
  }

  Widget _buildDateOfBirthSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Date of Birth:",
          style: TextStyle(
            fontSize: FlutterFlowTheme.adjustScale(size: 16),
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            // Day Dropdown
            _buildDropdown(
              width: 76,
              value: selectedDay,
              hint: "Day",
              onChanged: (String? newValue) {
                setState(() {
                  selectedDay = newValue;
                  _updateSelectedBirthdate();
                });
              },
              items: List.generate(31, (index) => (index + 1).toString()),
            ),

            // Month Dropdown
            _buildDropdown(
              width: 110,
              value: selectedMonth,
              hint: "Month",
              onChanged: (String? newValue) {
                setState(() {
                  selectedMonth = newValue;
                  _updateSelectedBirthdate();
                });
              },
              items: _monthNames,
            ),

            // Year Dropdown
            _buildDropdown(
              width: 90,
              value: selectedYear,
              hint: "Year",
              onChanged: (String? newValue) {
                setState(() {
                  selectedYear = newValue;
                  _updateSelectedBirthdate();
                });
              },
              items: List.generate(
                100,
                (index) => (DateTime.now().year - index).toString(),
              ),
            ),
          ],
        ),
        if (calculatedAge != null) ...[
          const SizedBox(height: 10),
          Text(
            "Age: $calculatedAge years",
            style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 14),
                color: Colors.black54,
                fontWeight: FontWeight.w400),
          ),
        ],
      ],
    );
  }

  void _updateSelectedBirthdate() {
    if (selectedDay != null && selectedMonth != null && selectedYear != null) {
      try {
        final monthIndex = _monthNames.indexOf(selectedMonth!) + 1;
        final day = int.tryParse(selectedDay!) ?? 1;
        final year = int.tryParse(selectedYear!) ?? DateTime.now().year;

        // Handle invalid dates like Feb 30 → auto-fix to Feb 28
        final lastDayOfMonth = DateTime(year, monthIndex + 1, 0).day;
        final validDay = day > lastDayOfMonth ? lastDayOfMonth : day;

        final newDate = DateTime(year, monthIndex, validDay);

        // Calculate age immediately
        final now = DateTime.now();
        int age = now.year - newDate.year;
        if (now.month < newDate.month ||
            (now.month == newDate.month && now.day < newDate.day)) {
          age--;
        }

        setState(() {
          selectedBirthdate = newDate;
          calculatedAge = age;
        });

        print("📅 Birthdate selected: $newDate → age $age");
      } catch (e) {
        print('❌ Invalid date selection: $e');
      }
    }
  }

  Widget _buildDropdown(
      {required String? value,
      required String hint,
      required Function(String?) onChanged,
      required List<String> items,
      double? width}) {
    return Container(
      height: 40,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffd3d3d3)),
          borderRadius: BorderRadius.circular(8),
          color: Color(0xfff9f9f9)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: Text(
              hint,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: FlutterFlowTheme.adjustScale(size: 12)),
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildWeightSection() {
    final weightValue = userData?['vital_value']?.round() ?? '-';
    final weightUnit = userData?['vital_unit']?.toString() ?? '-';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Your weight:",
          style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 16),
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                final tapPosition = details.globalPosition;
                _showCustomDialogAt(tapPosition, weightValue, []);
              },
              child: Container(
                width: 85,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: const Color(0xff979797),
                ),
                child: Center(
                  child: Text(
                    '$weightValue',
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                final tapPosition = details.globalPosition;
                _showCustomDialogAt(tapPosition, weightUnit, ['kg', 'lbs']);
              },
              child: Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: const Color(0xff979797),
                ),
                child: Center(
                  child: Text(
                    weightUnit,
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInstructionText() {
    return Text(
      "Return to the questionnaire to enter your details\nand receive tailored suggestions.",
      style: TextStyle(
        color: Colors.black,
        fontSize: FlutterFlowTheme.adjustScale(size: 12),
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSaveButton() {
    return FFButtonWidget(
      onPressed: _handleUpdateProfile,
      text: 'Update Profile Details',
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
    );
  }

  Future<void> _handleUpdateProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('❌ No authenticated user');
        return;
      }

      // 1️⃣ Fetch existing record
      final existingData =
          await supabase.from('users').select().eq('id', user.id).maybeSingle();

      if (existingData == null) {
        print('⚠️ No user record found');
        return;
      }

      // 2️⃣ Prepare new data (safe values)
      final formattedBirthdate = selectedBirthdate != null
          ? "${selectedBirthdate!.year.toString().padLeft(4, '0')}-${selectedBirthdate!.month.toString().padLeft(2, '0')}-${selectedBirthdate!.day.toString().padLeft(2, '0')}"
          : existingData['birthdate'];

      final newData = {
        'user_name': userData?['user_name'],
        'email': userData?['email'],
        'gender': selectedGenderText,
        'country': selectedCountryKeycode?.toString(),
        'birthdate': formattedBirthdate,
      };

      // 3️⃣ Compare and detect changes
      Map<String, dynamic> changedFields = {};
      newData.forEach((key, value) {
        if (existingData[key]?.toString() != value?.toString()) {
          changedFields[key] = value;
          print("🟡 Field changed: $key => $value (was ${existingData[key]})");
        }
      });

      // 4️⃣ Always include birthdate + age if DOB selected
      int? calculatedAge;
      if (selectedBirthdate != null) {
        final now = DateTime.now();
        int age = now.year - selectedBirthdate!.year;
        if (now.month < selectedBirthdate!.month ||
            (now.month == selectedBirthdate!.month &&
                now.day < selectedBirthdate!.day)) {
          age--;
        }

        changedFields['birthdate'] = formattedBirthdate;
        changedFields['age'] = age;
        calculatedAge = age;

        print("🎂 Updated DOB: $formattedBirthdate | Age: $age");
      }

      // 🚫 If nothing changed, exit early
      if (changedFields.isEmpty) {
        print("ℹ️ No changes detected — skipping update & community sync");
        return;
      }

      // 5️⃣ Resolve Gender Keycode
      int? genderKeycode;
      String? genderLabel;
      if (selectedGenderText != null && selectedGenderText!.isNotEmpty) {
        final genderLookup = await supabase
            .from('codelkup')
            .select('keycode, key1')
            .eq('lkcode', 'Gender')
            .eq('key1', selectedGenderText!)
            .maybeSingle();

        if (genderLookup != null) {
          genderKeycode = genderLookup['keycode'];
          genderLabel = genderLookup?['key1'];
          print(
              "👩‍🦱 Gender: '${selectedGenderText}' (keycode: $genderKeycode)");
        }
      } else {
        final genderLookup = await supabase
            .from('codelkup')
            .select('keycode, key1')
            .eq('lkcode', 'Gender')
            .eq('key1', existingData['gender'])
            .maybeSingle();
        genderKeycode = genderLookup?['keycode'];
      }

      // 6️⃣ Resolve Country Keycode
      int? countryKeycode;
      String? countryLabel;
      if (selectedCountryKeycode != null) {
        final countryLookup = await supabase
            .from('codelkup')
            .select('keycode, key1')
            .eq('lkcode', 'countries_with_flag')
            .eq('keycode', selectedCountryKeycode!)
            .maybeSingle();
        countryKeycode = selectedCountryKeycode;
        countryLabel = countryLookup?['key1'];
      } else {
        final existingCountry = int.tryParse(existingData['country'] ?? '0');
        countryKeycode = existingCountry ?? 0;
      }

      if (countryKeycode != null && countryKeycode > 0) {
        print("🌍 Country keycode: $countryKeycode");
      }

      // 7️⃣ Resolve Ethnicity Keycode (from users.ethnicity)
      int? ethnicityKeycode;
      ethnicityKeycode = existingData['ethnicity'];

      // 8️⃣ Update users table
      await supabase.from('users').update(changedFields).eq('id', user.id);
      print("✅ Updated fields in DB: $changedFields");

      // 9️⃣ Fetch age_group from codelkup and find matching range
      int? ageGroupKeycode;
      if (calculatedAge != null) {
        final ageGroups = await supabase
            .from('codelkup')
            .select('keycode, key1')
            .eq('lkcode', 'age_group');

        for (final group in ageGroups) {
          final range = group['key1'].toString();
          // Expected format: "18–25" or "26-35"
          final parts = range.split(RegExp(r'[-–]'));
          if (parts.length == 2) {
            final start = int.tryParse(parts[0].trim());
            final end = int.tryParse(parts[1].trim());
            if (start != null &&
                end != null &&
                calculatedAge! >= start &&
                calculatedAge! <= end) {
              ageGroupKeycode = group['keycode'];
              print(
                  "🎯 Age $calculatedAge falls in group $range (keycode: $ageGroupKeycode)");
              break;
            }
          }
        }
      }

      final existingReason =
          "Existing → Age: ${existingData['age'] ?? 'N/A'}, Gender: ${existingData['gender'] ?? 'N/A'}, Ethnicity: ${existingData['ethnicity'] ?? 'N/A'}, Location: ${existingData['country'] ?? 'N/A'}";

      final newReason =
          "Updated → Age Group: ($ageGroupKeycode), Gender: ${genderLabel ?? 'N/A'} ($genderKeycode), Ethnicity:  ($ethnicityKeycode), Location: ${countryLabel ?? 'N/A'} ($countryKeycode)";

      final reason = "$existingReason\n$newReason";

      // 🔟 Call CommunitySyncService ONLY if something changed
      if (genderKeycode != null &&
          countryKeycode != null &&
          ethnicityKeycode != null &&
          ageGroupKeycode != null &&
          changedFields.isNotEmpty) {
        print("🔄 Syncing communities due to user changes...");
        final result = await updateUserCommunity.updateUserCommunities(
          age: ageGroupKeycode, // <-- use group keycode instead of raw age
          gender: genderKeycode,
          ethnicity: ethnicityKeycode,
          location: countryKeycode,
          reason: reason,
        );
        print("🏡 Community Sync Result: $result");
      } else {
        print(
            "⚠️ Missing demographic data or no changes — skipping community sync.");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile details updated successfully')),
      );

      await supabase.from('user_vitals').insert({
        'user_id': supabase.auth.currentUser!.id,
        'vital_type': 'Weight',
        'value': weight,
        'unit': userData?['vital_unit'] ?? 'kg',
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      final formattedWeight = "$weight $weightUnit";
      print('weight update in user_answers');
      await supabase
          .from('user_answers')
          .update({
            'question_id': 24,
            'question_option_id': null,
            'answer_text': formattedWeight,
            'linkedtoscreen': 'Onboarding',
          })
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('question_id', 24);
      // 🧩 Update user_answers table for gender, birthdate, and weight
      try {
        final List<Map<String, dynamic>> answerUpdates = [];

        // 1️⃣ GENDER → question_id: 20
        if (changedFields.containsKey('gender') && genderKeycode != null) {
          answerUpdates.add({
            'question_id': 20,
            'question_option_id': genderKeycode,
            'answer_text': selectedGenderText ?? existingData['gender'],
            'linkedtoscreen': 'Onboarding',
          });
        }

        // 2️⃣ BIRTHDATE → question_id: 19
        if (changedFields.containsKey('birthdate')) {
          answerUpdates.add({
            'question_id': 19,
            'question_option_id': null,
            'answer_text': formattedBirthdate,
            'linkedtoscreen': 'Onboarding',
          });
        }

        // 3️⃣ WEIGHT → question_id: 24
        final latestWeight = userData?['vital_value'];
        final latestUnit = userData?['vital_unit'] ?? 'kg';
        if (latestWeight != null) {
          final formattedWeight = "$latestWeight $latestUnit";
          answerUpdates.add({
            'question_id': 24,
            'question_option_id': null,
            'answer_text': formattedWeight,
            'linkedtoscreen': 'Onboarding',
          });
        }

        if (answerUpdates.isNotEmpty) {
          for (final ans in answerUpdates) {
            // Check if already exists for this user + question_id
            final existing = await supabase
                .from('user_answers')
                .select('id')
                .eq('user_id', user.id)
                .eq('question_id', ans['question_id'])
                .maybeSingle();

            if (existing != null) {
              // ✅ Update existing record
              await supabase
                  .from('user_answers')
                  .update({
                    'question_id': ans['question_id'],
                    'question_option_id': ans['question_option_id'],
                    'answer_text': ans['answer_text'],
                    'linkedtoscreen': ans['linkedtoscreen'],
                  })
                  .eq('user_id', user.id)
                  .eq('question_id', ans['question_id']);
              print(
                  "🔁 Updated answer for Q${ans['question_id']}: ${ans['answer_text']}");
            }
          }
        }
      } catch (e) {
        print('❌ Error updating user_answers: $e');
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
    }
  }

  Widget _buildButtonsSection(action) {
    return FFButtonWidget(
      onPressed: () {
        if (!mounted) return;
        onboardingFromSettings = true;
        context.go('/onboarding');
      },
      text: 'Back to Questionnaire',
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
    );
  }

  Widget _buildFreeEdition() {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Free Edition',
          style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 16),
              height: 1.2,
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text(
                'Unlock All Features with Pro',
                style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 16),
                    height: 1.2,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.w700),
              ),
              ...features.map((el) => Row(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check,
                        color: Colors.purpleAccent,
                        size: 16,
                      ),
                      Expanded(
                          child: Text(
                        el,
                        style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(size: 12),
                          height: 1.67,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ))
                    ],
                  )),
              InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpgradeSubscriptionPage(
                        onSuccess: 'Settings',
                        onFailure: 'Home',
                        openFullPage: true,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 1,
                          color: Color(0xffC7c7c7),
                          style: BorderStyle.solid),
                      boxShadow: const [
                        // First shadow: white outline
                        BoxShadow(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          spreadRadius: 1, // acts like the 1px border
                          blurRadius: 0,
                          offset: Offset(0, 0),
                        ),
                        // Second shadow: black shadow with blur
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.32),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
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
                      )),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Upgrade Your Account',
                    style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 14),
                        color: Colors.white,
                        height: 1.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProEdition() {
    final planName = userData?['subscription_name'] ?? 'Pro Plan';
    final planPrice = userData?['subscription_price']?.toString() ?? '0';
    final planCurrency = userData?['subscription_currency'] ?? 'USD';

    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Pro Edition',
          style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 16),
              height: 1.2,
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12,
            children: [
              Text(
                planName.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 18),
                    height: 1.2,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                'Know Your Impact.\nImprove Your Choices.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 24),
                    height: 1.2,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                'Account Type: Pro',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    height: 2.42,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.w700),
              ),
              InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpgradeSubscriptionPage(
                        onSuccess: 'Settings',
                        onFailure: 'Home',
                        openFullPage: true,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 1,
                        color: Color(0xffC7c7c7),
                        style: BorderStyle.solid),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        spreadRadius: 1,
                        blurRadius: 0,
                        offset: Offset(0, 0),
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.32),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 12,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purpleAccent,
                                border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            child: const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                planName,
                                style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 18),
                                  height: 1.3,
                                  color: Color(0xfff9f9f9),
                                ),
                              ),
                              Text(
                                '$planPrice $planCurrency / year',
                                style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 16),
                                  height: 1.4,
                                  color: Color(0xfff9f9f9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 24,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCustomDialogAt(
    Offset position,
    dynamic portionSize,
    List<String> items,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    final translatedTop = position.dy - 127;
    final overflow = (translatedTop + 254) - screenHeight;
    final double adjustedDy = overflow > 0 ? -127 - overflow - 10 : -127;

    final currentWeight = userData?['vital_value']?.round();
    final currentUnit = userData?['vital_unit']?.toString();

    int? initialWeight;
    int? initialUnitIndex;

    if (items.isEmpty) {
      if (currentWeight != null) {
        if (currentWeight is int) {
          initialWeight = currentWeight;
        } else if (currentWeight is double) {
          initialWeight = currentWeight.round();
        } else if (currentWeight is String) {
          initialWeight = double.tryParse(currentWeight)?.round();
        } else if (currentWeight is num) {
          initialWeight = currentWeight.round();
        }
      }
      initialWeight ??= 65;
      if (initialWeight < 5) initialWeight = 5;
      if (initialWeight > 200) initialWeight = 200;
    } else {
      if (currentUnit != null && currentUnit.isNotEmpty) {
        final idx = items.indexOf(currentUnit);
        initialUnitIndex = idx >= 0 ? idx : 0;
      } else {
        initialUnitIndex = 0;
      }
    }

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(dialogContext).pop(),
                child: Container(color: Colors.black.withOpacity(0.15)),
              ),
            ),
            Positioned(
              right: items.isEmpty
                  ? (MediaQuery.sizeOf(context).width * 0.5) - 20
                  : (MediaQuery.sizeOf(context).width * 0.5) - 100,
              top: position.dy,
              child: Transform.translate(
                offset: Offset(0, adjustedDy),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 92,
                    height: 254,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff979797).withOpacity(0.1),
                          Color(0xff979797).withOpacity(0.05),
                          Color(0xff979797).withOpacity(0.1),
                        ],
                        stops: [0.2, 0.8, 1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: items.isNotEmpty
                        // 🟩 UNIT PICKER
                        ? custom_widgets.FFWheelPicker(
                            key: const ValueKey('weight_unit_picker'),
                            items: items,
                            width: 100,
                            initialItem: weightUnit,
                            onTap: (value) {
                              Navigator.of(context).pop();

                              if (!mounted) return;
                              setState(() {
                                if (weightUnit != value) {
                                  double currentWeight = 0;

                                  // ✅ Get the latest saved weight
                                  if (userData?['vital_value'] != null) {
                                    if (userData!['vital_value'] is num) {
                                      currentWeight =
                                          (userData!['vital_value'] as num)
                                              .toDouble();
                                    } else {
                                      currentWeight = double.tryParse(
                                            userData!['vital_value'].toString(),
                                          ) ??
                                          0;
                                    }
                                  }

                                  // ✅ Convert based on current unit → target unit
                                  if (value == "kg" && weightUnit == "lbs") {
                                    // lbs → kg
                                    currentWeight = currentWeight / 2.20462;
                                  } else if (value == "lbs" &&
                                      weightUnit == "kg") {
                                    // kg → lbs
                                    currentWeight = currentWeight * 2.20462;
                                  }

                                  currentWeight = double.parse(
                                      currentWeight.toStringAsFixed(1));

                                  // ✅ Update both in userData
                                  weightUnit = value;
                                  userData?['vital_unit'] = weightUnit;
                                  userData?['vital_value'] = currentWeight;
                                }
                              });
                            },
                          )
                        // ⚖️ WEIGHT PICKER
                        : custom_widgets.FFWheelPicker(
                            key: ValueKey('weight_picker_$weightUnit'),
                            width: 100,
                            height: 220.0,
                            min: (weightUnit == "kg") ? 20 : 44,
                            max: (weightUnit == "kg") ? 800 : 1760,
                            step: 1,
                            initialValue: currentWeight,
                            onTap: (value) async {
                              weight = (value is double)
                                  ? value
                                  : (value is int)
                                      ? value.toDouble()
                                      : double.tryParse(value.toString()) ??
                                          65.0;

                              setState(() {
                                userData?['vital_value'] = weight;
                              });

                              Navigator.of(context).pop();
                            },
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataPermissionCard({
    required String permissionTilte,
    required String permissionDesc,
    required bool permissionStatus,
    required String whatYouGet,
    VoidCallback? seeDetails,
    bool showActionButton = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xfff9f9f9),
        borderRadius: BorderRadius.circular(12),
        border: permissionStatus
            ? Border.all(
                color: Color(0xff81c995), width: 1, style: BorderStyle.solid)
            : null,
        boxShadow: permissionStatus
            ? [
                BoxShadow(
                    color: Color.fromRGBO(249, 249, 249, 1),
                    offset: Offset(0, 0),
                    spreadRadius: 1),
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.08),
                    offset: Offset(0, 2),
                    blurRadius: 8),
              ]
            : null,
      ),
      child: Column(
        spacing: 4,
        children: [
          Text(
            textAlign: TextAlign.center,
            permissionTilte,
            style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 16),
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: FlutterFlowTheme.of(context).textGrey,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            permissionTilte,
            style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 12),
              height: 1.5,
              color: FlutterFlowTheme.of(context).textGrey,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SwitchButton(
            value: permissionStatus,
            onChanged: (value) {
              setState(() {
                permissionStatus = value;
              });
            },
            height: 30,
          ),
          const SizedBox(
            height: 8,
          ),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'You will get: ',
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    fontWeight: FontWeight.w700,
                    color: FlutterFlowTheme.of(context).textGrey,
                  ),
                  children: [
                    TextSpan(
                        text: whatYouGet,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ))
                  ])),
          if (showActionButton)
            FFButtonWidget(
              onPressed: () {
                seeDetails;
              },
              text: 'See Detail',
              icon: const Icon(
                Icons.chevron_right,
                size: 12,
                color: Colors.white,
              ),
              options: FFButtonOptions(
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  height: 36,
                  color: FlutterFlowTheme.of(context).primaryText,
                  textStyle: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                  ),
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(24.0),
                  iconAlignment: IconAlignment.end),
            )
        ],
      ),
    );
  }

  Widget _buildDataPermissionDetailsCard({
    required String permissionTilte,
    required String permissionDesc,
    required bool permissionStatus,
    required String youReceive,
    required String whoAsk,
    required String howLong,
    required String status,
    VoidCallback? seeDetails,
    bool showActionButton = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xfff9f9f9),
        borderRadius: BorderRadius.circular(12),
        border: permissionStatus
            ? Border.all(
                color: Color(0xff81c995), width: 1, style: BorderStyle.solid)
            : null,
        boxShadow: permissionStatus
            ? [
                BoxShadow(
                    color: Color.fromRGBO(249, 249, 249, 1),
                    offset: Offset(0, 0),
                    spreadRadius: 1),
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.08),
                    offset: Offset(0, 2),
                    blurRadius: 8),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  permissionTilte,
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 16),
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: FlutterFlowTheme.of(context).textGrey,
                  ),
                ),
              ),
              InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.chevron_right,
                    size: 20,
                  )),
            ],
          ),
          RichText(
              text: TextSpan(
                  text: 'You receive: ',
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    fontWeight: FontWeight.w700,
                    color: FlutterFlowTheme.of(context).textGrey,
                  ),
                  children: [
                TextSpan(
                    text: youReceive,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ))
              ])),
          const SizedBox(
            height: 3,
          ),
          Text(
            permissionDesc,
            style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 12),
              height: 1.5,
              color: FlutterFlowTheme.of(context).textGrey,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SwitchButton(
            value: permissionStatus,
            onChanged: (value) {
              setState(() {
                permissionStatus = value;
              });
            },
            height: 30,
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            spacing: 6,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniCard(
                  title: 'Who asks:',
                  value: whoAsk,
                  bgColor: Color(0xffcecece)),
              _buildMiniCard(
                  title: 'Who asks:',
                  value: howLong,
                  bgColor: Color(0xffecc53f)),
              _buildMiniCard(
                  title: 'Who asks:',
                  value: status,
                  bgColor: Color(0xff88d1a5)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionPermissionCard(
      {required String permissionTilte,
      required String permissionDesc,
      required bool permissionStatus,
      required String whoAsk,
      required String status,
      VoidCallback? seeDetails,
      Color switchColor = const Color(0xffa8e6cf)}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xfff9f9f9),
        borderRadius: BorderRadius.circular(12),
        border: permissionStatus
            ? Border.all(
                color: Color(0xff81c995), width: 1, style: BorderStyle.solid)
            : null,
        boxShadow: permissionStatus
            ? [
                BoxShadow(
                    color: Color.fromRGBO(249, 249, 249, 1),
                    offset: Offset(0, 0),
                    spreadRadius: 1),
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.08),
                    offset: Offset(0, 2),
                    blurRadius: 8),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            permissionTilte,
            style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 16),
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: FlutterFlowTheme.of(context).textGrey,
            ),
          ),
          Text(
            permissionDesc,
            style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 12),
              height: 1.5,
              color: FlutterFlowTheme.of(context).textGrey,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          RichText(
              text: TextSpan(
                  text: 'Who asked: ',
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    fontWeight: FontWeight.w700,
                    color: FlutterFlowTheme.of(context).textGrey,
                  ),
                  children: [
                TextSpan(
                    text: whoAsk,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ))
              ])),
          const SizedBox(
            height: 12,
          ),
          Row(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SwitchButton(
                value: permissionStatus,
                onChanged: (value) {
                  setState(() {
                    permissionStatus = value;
                  });
                },
                switchOnColor: switchColor,
                height: 30,
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 16),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: FlutterFlowTheme.of(context).textGrey,
                ),
              ),
              Spacer(),
              SilverButton(
                  buttonFunction: () => {seeDetails},
                  buttonTitle: 'See Details',
                  hasIcon: true,
                  borderRadius: 99,
                  iconWidget: Icon(
                    Icons.chevron_right,
                    size: 16,
                  ),
                  paddingHorizontal: 12,
                  paddingVertical: 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(
      {required title,
      required value,
      required Color bgColor,
      height = 60,
      width = 0}) {
    return Container(
      height: height,
      width: width != 0 ? width : MediaQuery.sizeOf(context).width * 0.33 - 20,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: bgColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 12),
                color: FlutterFlowTheme.of(context).textGrey,
                fontWeight: FontWeight.w700),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 12),
              color: FlutterFlowTheme.of(context).textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String notificationTilte,
    required String notificationDesc,
    required bool notificationStatus,
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
      ),
      child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationTilte,
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: FlutterFlowTheme.of(context).textGrey,
                    ),
                  ),
                  Text(
                    notificationDesc,
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 12),
                      height: 1.5,
                      color: FlutterFlowTheme.of(context).textGrey,
                    ),
                  ),
                ],
              ),
            ),
            SwitchButton(
              value: notificationStatus,
              onChanged: (value) {
                setState(() {
                  notificationStatus = value;
                });
              },
              height: 30,
            ),
          ]),
    );
  }

  Widget _buildNutritionProfileCard(
      {required String nutrientName,
      required double nutrientValue,
      double cardWidth = 100,
      required Color nutrientColor}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          width: cardWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: FlutterFlowTheme.of(context).primaryBackground,
            boxShadow: const [
              // First shadow (1px white border)
              BoxShadow(
                color:
                    Colors.white, // White shadow (this is the 1px white border)
                offset: Offset(0, 0),
                blurRadius: 0,
                spreadRadius: 1,
              ),
              // Second shadow (light gray blur)
              BoxShadow(
                color: Color.fromRGBO(
                    129, 129, 129, 0.2), // RGBA equivalent for the gray shadow
                offset: Offset(0, 3),
                blurRadius: 7,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 9,
            children: [
              Text(
                nutrientName,
                style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    color: FlutterFlowTheme.of(context).textGrey,
                    height: 1.2,
                    fontWeight: FontWeight.w700),
              ),
              Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: CarouselSlider(
                      items: [
                        Container(
                          width: 58,
                          height: 58,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffececec),
                          ),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: nutrientColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 2,
                              children: [
                                Text(
                                  '$nutrientValue',
                                  style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 16),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      carouselController: _model.carouselController ??=
                          CarouselSliderController(),
                      options: CarouselOptions(
                        height: 60,
                        initialPage: 1,
                        viewportFraction: 1,
                        enlargeCenterPage: false,
                        enlargeFactor: 0,
                        enableInfiniteScroll: false,
                        scrollDirection: Axis.horizontal,
                        autoPlay: false,
                        onPageChanged: (index, _) =>
                            _model.carouselCurrentIndex = index,
                      ),
                    ),
                  ),
                  Positioned(
                    left: -18,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                      child: InkWell(
                        child: Icon(
                          Icons.arrow_left,
                          color: nutrientColor,
                          size: 24.0,
                        ),
                        onTap: () async {
                          await _model.carouselController?.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: -18,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                      child: InkWell(
                        child: Icon(
                          Icons.arrow_right,
                          color: nutrientColor,
                          size: 24.0,
                        ),
                        onTap: () async {
                          await _model.carouselController?.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                  ),
                  // Dots (bottom, always visible)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -12,
                    child: _Dots(
                      count: 2,
                      activeIndex: 0,
                      onDotTap: (i) => _controller.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      ),
                      dotColor: nutrientColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 1,
          left: 1,
          child: AlignedTooltip(
            content: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
              child: Text(
                '',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.montserrat(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).textGrey,
                      fontSize: FlutterFlowTheme.adjustScale(size: 12),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                    ),
              ),
            ),
            offset: 4.0,
            preferredDirection: AxisDirection.down,
            borderRadius: BorderRadius.circular(8.0),
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            elevation: 4.0,
            tailBaseWidth: 24.0,
            tailLength: 12.0,
            waitDuration: Duration(milliseconds: 100),
            showDuration: Duration(milliseconds: 1500),
            triggerMode: TooltipTriggerMode.tap,
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: FaIcon(
                FontAwesomeIcons.infoCircle,
                color: FlutterFlowTheme.of(context).textGreen.withOpacity(0.26),
                size: 18.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDummyDropdown({
    required String inputValue,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: FlutterFlowTheme.adjustScale(size: 150, largeScreenMargin: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: const Color(0xffe1e1e1),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 6,
          children: [
            Text(
              inputValue,
              style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 12),
                color: Colors.black,
                height: 1.2,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: FlutterFlowTheme.of(context).textGrey,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditingFieldSheet(BuildContext context,
      {required String editingFieldName,
      String editingFieldDesc = '',
      required Widget editingFieldType}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
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
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 24.0, 0.0),
                        child: Text(
                          editingFieldName,
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
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 18),
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
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 40,
                children: [
                  if (editingFieldDesc != '')
                    Text(
                      textAlign: TextAlign.center,
                      editingFieldDesc,
                      style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(size: 12),
                          height: 2,
                          color: FlutterFlowTheme.of(context).primaryText),
                    ),
                  editingFieldType
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildMeasurementBox({required value}) {
    return Container(
      height: FlutterFlowTheme.adjustScale(size: 40, largeScreenMargin: 10),
      width: 59,
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: Color(0xffe1e1e1), style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: FlutterFlowTheme.adjustScale(size: 18), height: 1.2),
      ),
    );
  }

  Widget _buildRadioButtonList({
    required List<Map<String, dynamic>> data,
    required int? selectedValue,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return RadioListTile<int>(
          title: Text(item['key1']),
          value: item['keycode'],
          groupValue: selectedValue,
          activeColor: FlutterFlowTheme.of(context).primaryText,
          onChanged: (val) {},
        );
      },
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int activeIndex;
  final ValueChanged<int>? onDotTap;
  final Color dotColor;

  const _Dots({
    required this.count,
    required this.activeIndex,
    this.onDotTap,
    this.dotColor = const Color(0xff000000),
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(count, (i) {
        final bool isActive = i == activeIndex;
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onDotTap == null ? null : () => onDotTap!(i),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? dotColor : dotColor.withOpacity(0.3),
            ),
          ),
        );
      }),
    );
  }
}