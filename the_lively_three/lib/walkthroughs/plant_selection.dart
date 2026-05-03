import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '/components/walkthrough/walkthrough_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

// Focus widget keys for this walkthrough
final listViewWlpkacw3 = GlobalKey();
final columnItb9tr37 = GlobalKey();

/// Plant Selection
///
///
List<TargetFocus> createWalkthroughTargets(BuildContext context) => [
      /// Step 1
      TargetFocus(
        keyTarget: listViewWlpkacw3,
        enableOverlayTab: true,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, __) => WalkthroughWidget(
              description:
                  'Enter the plants you consumed. See the overview on Homepage.',
            ),
          ),
        ],
      ),

      /// Step 2
      TargetFocus(
        keyTarget: columnItb9tr37,
        enableOverlayTab: true,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, __) => WalkthroughWidget(
              description: 'Multifunctional plant buttons explained',
            ),
          ),
        ],
      ),
    ];
