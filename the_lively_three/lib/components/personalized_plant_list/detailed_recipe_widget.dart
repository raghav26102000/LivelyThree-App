// ignore_for_file: prefer_const_constructors

import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
import 'package:the_lively_three/components/consumption_card/consumption_card_widget.dart';
import 'package:the_lively_three/components/fluid_bg/setting_bg_widget.dart';
import 'package:the_lively_three/components/permissions_pages/data_permission.dart';
import 'package:the_lively_three/components/permissions_pages/get_permission_access.dart';
import 'package:the_lively_three/custom_code/widgets/f_f_wheel_picker.dart';
import 'package:the_lively_three/custom_code/widgets/f_f_wheel_picker.dart'
    as custom_widgets;
import 'package:the_lively_three/custom_code/widgets/weekly_item_card.dart';
import 'package:the_lively_three/pages/homepage/homepage_widget.dart';
import 'package:the_lively_three/pages/subscription/subscription_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'personalized_plant_list_model.dart';
export 'personalized_plant_list_model.dart';
import '/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_lively_three/pages/subscription/subscription_model.dart';

class DetailedRecipeWidget extends StatefulWidget {
  final String recipeName;

  static String routeName = 'detailed-recipe';
  static String routePath = '/detailed-recipe';
  const DetailedRecipeWidget({
    super.key,
    required this.recipeName,
  });

  @override
  State<DetailedRecipeWidget> createState() =>
      _PersonalizedPlantListWidgetState();
}

// Updated DetailedRecipeWidget with subscription check

class _PersonalizedPlantListWidgetState extends State<DetailedRecipeWidget> {
  @override
  void initState() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    late String recipeOverview = '';
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              // Middle scoop - Red/Orange
              Positioned(
                left: -MediaQuery.sizeOf(context).width * 0.2,
                top: -50,
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.55,
                  width: MediaQuery.sizeOf(context).width * 1.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    gradient: RadialGradient(
                      colors: [
                        Color(0xfff6e0e1),
                        Color(0xfff6e0e1),
                        Color(0xfff6e0e1),
                      ],
                    ),
                  ),
                ),
              ),

              // Top scoop (smallest) - Green
              Positioned(
                left: MediaQuery.sizeOf(context).width * 0.35,
                right: -MediaQuery.sizeOf(context).width * 0.22,
                top: -75,
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    gradient: RadialGradient(
                      colors: [
                        Color(0xfff4e3f1),
                        Color(0xfff4e3f1),
                        Color(0xfff4e3f1),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom scoop (largest) - Purple/Magenta
              Positioned(
                left: -MediaQuery.sizeOf(context).width * 0.4,
                bottom: -MediaQuery.sizeOf(context).height * 0.3,
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFf8eeef),
                        Color(0xFFf8eeef),
                        Color(0xFFf8eeef),
                      ],
                    ),
                  ),
                ),
              ),

              // Blur effect overlay
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
                child: Container(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ],
          ),
        ),
        // Blur effect overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
          child: Container(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
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
                color: FlutterFlowTheme.of(context).blackText,
                size: 24.0,
              ),
            ),
            centerTitle: true,
            titleSpacing: 16,
            title: Expanded(
                child: Text(
              widget.recipeName,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: FlutterFlowTheme.adjustScale(size: 18.0),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            )),
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            shadowColor: const Color.fromRGBO(0, 0, 0, 0.09),
          ),
          body: SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                decoration: BoxDecoration(
                                    color: Color(0xfff77f00),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 4,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: FaIcon(
                                        FontAwesomeIcons.solidStar,
                                        color: Color(0xfff77f00),
                                        size: 9,
                                      ),
                                    ),
                                    Text(
                                      'Protein-Rich', //'Fiber-Rich',
                                      style: TextStyle(
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 11),
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildInfoCard('Servings', '8', 100),
                              buildInfoCard('Prep Time', '20m', 25),
                              buildInfoCard('Cook Time', '40m', 50),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Key Ingredients - Nutrition Information',
                            style: TextStyle(
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 16),
                                height: 1.2,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 16),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  width: 1,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground),
                            ),
                            child: Column(
                              spacing: 16,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(255, 241, 229, 1),
                                          border: Border.all(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  247, 220, 196, 1))),
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          Color.fromRGBO(247, 220, 196, 1),
                                          BlendMode.srcIn,
                                        ),
                                        child: Image.asset(
                                          'assets/images/LOGO.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Carrot',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          height: 1.2,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        )),
                                    Spacer(),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Vitamin A: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          height: 1.5,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '20mg / 100g',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Color(0xffececec),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(255, 241, 229, 1),
                                          border: Border.all(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  247, 220, 196, 1))),
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          Color.fromRGBO(247, 220, 196, 1),
                                          BlendMode.srcIn,
                                        ),
                                        child: Image.asset(
                                          'assets/images/LOGO.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Red Lentils',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          height: 1.2,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        )),
                                    Spacer(),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Protein: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          height: 1.5,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '25g / 100g',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 16),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  width: 1,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground),
                            ),
                            child: Column(
                              spacing: 20,
                              children: [
                                Row(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/ingredients_icon.png',
                                      width: 32,
                                      height: 32,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Ingredients',
                                        style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 16),
                                            fontWeight: FontWeight.w700,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            height: 1.2),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  spacing: 24,
                                  children: [
                                    buildIngredientItems(
                                        ingredient:
                                            '1 ½ cups red lentils rinsed',
                                        mainIngrdient: true),
                                    buildIngredientItems(
                                        ingredient: '3 carrots sliced',
                                        mainIngrdient: true),
                                    buildIngredientItems(
                                        ingredient: '1 medium onion diced'),
                                    buildIngredientItems(
                                        ingredient: '3 cloves garlic minced'),
                                    buildIngredientItems(
                                        ingredient: '3 stalks celery sliced'),
                                    buildIngredientItems(
                                        ingredient: '1 ½ teaspoons cumin'),
                                    buildIngredientItems(
                                        ingredient: '1 ½ teaspoons coriander'),
                                    buildIngredientItems(
                                        ingredient: '½ teaspoon turmeric'),
                                    buildIngredientItems(
                                        ingredient:
                                            'A dash or two of red pepper flakes optional'),
                                    buildIngredientItems(
                                        ingredient: '1 teaspoon salt'),
                                    buildIngredientItems(
                                        ingredient: '¼ teaspoon black pepper'),
                                    buildIngredientItems(
                                        ingredient:
                                            '2 10-ounce bags frozen cauliflower or one large head fresh'),
                                    buildIngredientItems(
                                        ingredient:
                                            '8 cups low-sodium veggie broth or stock'),
                                    buildIngredientItems(
                                        ingredient:
                                            '1 cup unsweetened almond milk or use coconut milk for a creamier consistency'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 16),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  width: 1,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground),
                            ),
                            child: Column(
                              spacing: 20,
                              children: [
                                Row(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/recipe-icon.png',
                                      width: 32,
                                      height: 32,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Instruction',
                                        style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 16),
                                            fontWeight: FontWeight.w700,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            height: 1.2),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  spacing: 12,
                                  children: [
                                    buildInstructionItems(1,
                                        'In a large stock pot, heat a splash of water over medium heat.'),
                                    buildInstructionItems(2,
                                        'Add the diced onion, garlic, carrots, and celery. Sauté for about 5–7 minutes, stirring occasionally, until the veggies begin to soften and the onions turn translucent. Add more water as needed to prevent sticking.'),
                                    buildInstructionItems(3,
                                        '1 medium onion,3 cloves garlic,3 carrots,3 stalks celery. Stir in the cumin, coriander, turmeric, red pepper flakes (if using), salt, and blackpepper. Cook for 1–2 more minutes to toast the spices and bring out their flavor.'),
                                    buildInstructionItems(4,
                                        '1 ½ teaspoons cumin,1 ½ teaspoons coriander,½ teaspoon turmeric,A dash or two of red pepper flakes,1 teaspoon salt,¼ teaspoon black pepper'),
                                    buildInstructionItems(5,
                                        'Add the bags of frozen cauliflower straight into the pot. If using fresh, chop a large head of cauliflower into florets and add them in. Stir to coat the cauliflower with the spices. 2 10-ounce bags frozen cauliflower'),
                                    buildInstructionItems(6,
                                        'Pour in the vegetable broth and almond milk, then add the rinsed red lentils. Stir everything together and bring the soup to a boil.'),
                                    buildInstructionItems(7,
                                        '8 cups low-sodium veggie broth,1 cup unsweetened almond milk,1 ½ cups red lentils'),
                                    buildInstructionItems(8,
                                        'Stir in the torn spinach and cook for 2–3 minutes, just until wilted. \n3 large handfuls spinach'),
                                    buildInstructionItems(9,
                                        'Once boiling, reduce the heat to low and let the soup simmer uncovered for 20–25 minutes, or until the lentils are soft and the cauliflower is tender. Stir occasionally to prevent sticking.'),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildInfoCard(String infoName, String infoValue, progressValue) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional(0.0, 0.0),
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: CircularPercentIndicator(
            percent: (progressValue / 100.0),
            radius: 36,
            lineWidth: 1.0,
            backgroundWidth: 4,
            animation: true,
            animateFromLastPercent: true,
            progressColor: Color.fromRGBO(129, 129, 129, 1),
            backgroundColor: Color(0xFFececec),
            circularStrokeCap: CircularStrokeCap.round,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
          ),
        ),
        Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  infoValue,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.2,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  infoName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.2,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIngredientItems(
      {required String ingredient, bool mainIngrdient = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(
                mainIngrdient ? Icons.star : Icons.circle,
                size: mainIngrdient ? 10 : 7,
                color: mainIngrdient
                    ? Color.fromRGBO(255, 120, 0, 1)
                    : FlutterFlowTheme.of(context).blackText,
              )),
          Expanded(
            child: Text(
              ingredient,
              style: TextStyle(
                fontWeight: mainIngrdient ? FontWeight.w700 : FontWeight.w400,
                fontSize: FlutterFlowTheme.adjustScale(size: 12),
                height: 1.2,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInstructionItems(int numberInstruction, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CircleAvatar(
              radius: 11,
              backgroundColor: FlutterFlowTheme.of(context).primaryText,
              child: Text(
                  textAlign: TextAlign.center,
                  numberInstruction.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 1.2,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  )),
            ),
          ),
          Expanded(
            child: Text(
              instruction,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: FlutterFlowTheme.adjustScale(size: 12),
                height: 2,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
