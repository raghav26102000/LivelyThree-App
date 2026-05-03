import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '/components/walkthrough/walkthrough_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

// Focus widget keys for this walkthrough
final columnUa3b3tce = GlobalKey();
final columnGnc3qoy8 = GlobalKey();
final rowP1btybzx = GlobalKey();
final rowIevihemv = GlobalKey();

/// Homepage
///
///
List<TargetFocus> createWalkthroughTargets(BuildContext context) => [
      /// Step 1
      TargetFocus(
        keyTarget: columnUa3b3tce,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        color: Color(0x6A636F81),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => WalkthroughWidget(
              description: 'Color and number of plants you eat. ',
            ),
          ),
        ],
      ),

      /// Step 2
      TargetFocus(
        keyTarget: columnGnc3qoy8,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => WalkthroughWidget(
              description: 'What you consumed each week day. ',
            ),
          ),
        ],
      ),

      /// Step 3
      TargetFocus(
        keyTarget: rowP1btybzx,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => WalkthroughWidget(
              description: 'The Three Rules. ',
            ),
          ),
        ],
      ),

      /// Step 4
      TargetFocus(
        keyTarget: rowIevihemv,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, __) => WalkthroughWidget(
              description: 'Your Health Score and the Community Score.',
            ),
          ),
        ],
      ),
    ];
