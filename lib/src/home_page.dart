import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'copy.dart';
import 'tokens.dart';

/// The Figma frame "Home": two window-tall screens.
///
/// 1. The OBSIVISION / TECH FOUNDRY lockup, with "IMAGINE. DESIGN.
///    DEVELOP." faint along the bottom, wider than the window.
/// 2. The body copy.
///
/// At 1280 × 832 each screen is the design frame exactly. At other sizes
/// the lockup keeps its distance from the window's centre and shrinks only
/// when the window is too narrow for it; the motto scales with the width,
/// so it always bleeds off both edges by the same proportion.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _heightWidth;
  double _stableHeight = 0;

  /// The window height as first seen at the current width. A phone browser
  /// changes the height as its address bar slides away; following it would
  /// resize the screens mid-scroll and make the page jump. Rotating changes
  /// the width, which takes a new reading.
  double _screenHeight(Size size) {
    if (size.width != _heightWidth) {
      _heightWidth = size.width;
      _stableHeight = size.height;
    }
    return math.max(_stableHeight, ObsLayout.minScreenHeight);
  }

  @override
  Widget build(BuildContext context) {
    final height = _screenHeight(MediaQuery.sizeOf(context));
    return Scaffold(
      backgroundColor: ObsColors.background,
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              LockupScreen(height: height),
              BodyScreen(minHeight: height),
            ],
          ),
        ),
      ),
    );
  }
}

/// Screen 1: the lockup and the motto.
class LockupScreen extends StatelessWidget {
  const LockupScreen({super.key, required this.height});

  final double height;

  // In design units, relative to the frame's vertical centre (416).
  static const _wordmarkCentre = -36.83;
  static const _subtitleCentre = 56.67;

  /// Both lines are centred half a pixel left of the frame's middle.
  static const _lockupNudge = -0.5;

  /// The motto's line is centred 48 above the frame's bottom edge.
  static const _mottoFromBottom = 48.0;

  /// The shortest screen that shows the lockup at full size with room
  /// between it and the motto.
  static const _fullSizeHeight = 560.0;

  /// Wide enough for either line; the lines centre in it.
  static const _lockupWidth = 640.0;

  static final _wordmarkLine =
      ObsType.wordmark.fontSize! * ObsType.wordmark.height!;
  static final _subtitleLine =
      ObsType.subtitle.fontSize! * ObsType.subtitle.height!;

  /// From the top of the wordmark's line box to the bottom of the
  /// subtitle's.
  static double get _lockupTop => _wordmarkCentre - _wordmarkLine / 2;
  static double get _lockupHeight =>
      _subtitleCentre + _subtitleLine / 2 - _lockupTop;

  /// How far the lockup is drawn below its design size: 1 unless the
  /// screen is narrower than the lockup plus its gutters, or shorter than
  /// [_fullSizeHeight] (a phone held sideways), below which it would crowd
  /// the motto.
  static double scaleFor(Size screen) => math.min(
    1,
    math.min(
      (screen.width - 2 * ObsLayout.gutter) / _lockupWidth,
      screen.height / _fullSizeHeight,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final centre = height / 2;
        final s = scaleFor(Size(width, height));
        final k = width / ObsLayout.designWidth;
        final motto = ObsType.motto.copyWith(
          fontSize: ObsType.motto.fontSize! * k,
        );
        final mottoLine = motto.fontSize! * motto.height!;

        return SizedBox(
          width: double.infinity,
          height: height,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: height - _mottoFromBottom * k - mottoLine / 2,
                height: mottoLine,
                // Wider than the window by design: lay it out unconstrained
                // and let the screen clip both ends.
                child: OverflowBox(
                  maxWidth: double.infinity,
                  child: ExcludeSemantics(
                    child: Text(
                      ObsCopy.motto,
                      maxLines: 1,
                      softWrap: false,
                      style: motto,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: centre + _lockupTop * s,
                height: _lockupHeight * s,
                child: Center(
                  child: Transform.translate(
                    offset: Offset(_lockupNudge * s, 0),
                    child: SizedBox(
                      width: _lockupWidth * s,
                      height: _lockupHeight * s,
                      child: FittedBox(
                        child: SizedBox(
                          width: _lockupWidth,
                          height: _lockupHeight,
                          child: const _Lockup(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The two lines at design size, in a box from the top of the first line
/// to the bottom of the second.
class _Lockup extends StatelessWidget {
  const _Lockup();

  @override
  Widget build(BuildContext context) {
    final subtitleTop =
        LockupScreen._subtitleCentre -
        LockupScreen._subtitleLine / 2 -
        LockupScreen._lockupTop;
    return Semantics(
      header: true,
      label: '${ObsCopy.wordmark} ${ObsCopy.subtitle}',
      excludeSemantics: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Text(
              ObsCopy.wordmark,
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
              style: ObsType.wordmark,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: subtitleTop,
            child: Text(
              ObsCopy.subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
              style: ObsType.subtitle,
            ),
          ),
        ],
      ),
    );
  }
}

/// Screen 2: the body copy, 836 wide, centred half a pixel below the
/// window's middle.
class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key, required this.minHeight});

  final double minHeight;

  static const _centreOffset = 0.5;

  /// Kept clear above and below the copy when it is taller than a window.
  static const _verticalPadding = 96.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final style = width < ObsLayout.compactBodyBreakpoint
            ? ObsType.bodyCompact
            : ObsType.body;
        final textWidth = math.min(
          ObsLayout.bodyWidth,
          width - 2 * ObsLayout.gutter,
        );
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Padding(
            padding: const EdgeInsets.only(
              top: _verticalPadding + _centreOffset * 2,
              bottom: _verticalPadding,
            ),
            child: Center(
              child: SizedBox(
                width: textWidth,
                child: Text(ObsCopy.body, style: style),
              ),
            ),
          ),
        );
      },
    );
  }
}
