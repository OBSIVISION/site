import 'package:flutter/painting.dart';

/// Values from the Figma file "OBSIVISION-Site", frame "Home".
abstract final class ObsColors {
  static const background = Color(0xFF080F19);
  static const ink = Color(0xFFF1FAEE);

  /// "IMAGINE. DESIGN. DEVELOP." — ink at 10%.
  static const motto = Color(0x1AF1FAEE);

  /// The body copy — `#457B9D` at 75%.
  static const body = Color(0xBF457B9D);
}

/// Type. Every style uses even leading, which is how Figma (and CSS) place a
/// line in its box; the positions below assume it.
abstract final class ObsType {
  static const _cairo = TextStyle(
    fontFamily: 'Cairo',
    height: 1.39,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const wordmark = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 113.333,
    fontWeight: FontWeight.w900,
    height: 1.39,
    leadingDistribution: TextLeadingDistribution.even,
    color: ObsColors.ink,
  );

  static final subtitle = _cairo.copyWith(
    fontSize: 73.667,
    fontWeight: FontWeight.w200,
    letterSpacing: 7.3667,
    color: ObsColors.ink,
  );

  static final motto = _cairo.copyWith(
    fontSize: 103,
    fontWeight: FontWeight.w800,
    color: ObsColors.motto,
  );

  /// `body.b1`: Fraunces Regular 24, 135% leading, 1% tracking.
  static const body = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.35,
    letterSpacing: 0.24,
    leadingDistribution: TextLeadingDistribution.even,
    color: ObsColors.body,
  );

  /// The body on a phone: the same face, stepped down to keep ~40
  /// characters a line.
  static final bodyCompact = body.copyWith(fontSize: 18, letterSpacing: 0.18);
}

/// Geometry of the 1280 × 832 frames the layout is measured against.
abstract final class ObsLayout {
  static const designWidth = 1280.0;
  static const designHeight = 832.0;

  /// A screen is one window tall, but never shorter than this — low enough
  /// that a phone held sideways (~360–430 tall) still sees the whole first
  /// screen.
  static const minScreenHeight = 360.0;

  static const gutter = 24.0;
  static const bodyWidth = 836.0;

  /// Below this width the body copy takes its compact size.
  static const compactBodyBreakpoint = 600.0;
}
