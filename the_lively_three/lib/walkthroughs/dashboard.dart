import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '/components/walkthrough/walkthrough_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

// Focus widget keys for this walkthrough
final columnXa67ey42 = GlobalKey();
final iconBxwdxv3c = GlobalKey();
final row7tqkpjrw = GlobalKey();
final row49gz4fek = GlobalKey();

/// Dashboard
///
///
List<TargetFocus> createWalkthroughTargets(BuildContext context) => [
      /// Step 1
      TargetFocus(
        keyTarget: columnXa67ey42,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => WalkthroughWidget(
              description:
                  'Explore additional metrics, showing your habits in more detail. ',
            ),
          ),
        ],
      ),

      /// Step 2
      TargetFocus(
        keyTarget: iconBxwdxv3c,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.Circle,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => WalkthroughWidget(
              description:
                  'If you are subscribed, tap the field to see historic data to track progress',
            ),
          ),
        ],
      ),

      /// Step 3
      TargetFocus(
        keyTarget: row7tqkpjrw,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => WalkthroughWidget(
              description:
                  'Track your fiber intake, that of the community, and what science suggests for your onboarding goals.',
            ),
          ),
        ],
      ),

      /// Step 4
      TargetFocus(
        keyTarget: row49gz4fek,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => WalkthroughWidget(
              description:
                  'Track your protein intake, that of the community, and what science suggests for your onboarding goals.',
            ),
          ),
        ],
      ),
    ];
