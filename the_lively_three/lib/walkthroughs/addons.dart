import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '/components/walkthrough/walkthrough_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

// Focus widget keys for this walkthrough
final column1yu2v9ey = GlobalKey();
final containerBic7dote = GlobalKey();
final container0kutp96y = GlobalKey();
final rowJdufi4nk = GlobalKey();

/// Addons
///
///
List<TargetFocus> createWalkthroughTargets(BuildContext context) => [
      /// Step 1
      TargetFocus(
        keyTarget: column1yu2v9ey,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => WalkthroughWidget(
              description:
                  'On this page, enter additional info for upcoming personalized analytics. ',
            ),
          ),
        ],
      ),

      /// Step 2
      TargetFocus(
        keyTarget: containerBic7dote,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => WalkthroughWidget(
              description: 'Tap when you ate highly processed food.',
            ),
          ),
        ],
      ),

      /// Step 3
      TargetFocus(
        keyTarget: container0kutp96y,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => WalkthroughWidget(
              description: 'Tap when you drank water',
            ),
          ),
        ],
      ),

      /// Step 4
      TargetFocus(
        keyTarget: rowJdufi4nk,
        enableOverlayTab: true,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.Circle,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, __) => WalkthroughWidget(
              description: 'Enter your weight every now and then. ',
            ),
          ),
        ],
      ),
    ];
