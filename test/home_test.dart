import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obsivision_site/main.dart';
import 'package:obsivision_site/src/copy.dart';
import 'package:obsivision_site/src/home_page.dart';
import 'package:obsivision_site/src/tokens.dart';

void main() {
  Future<void> pumpSite(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(const ObsivisionSite());
    await tester.pumpAndSettle();
  }

  final wordmark = find.text(ObsCopy.wordmark);
  final subtitle = find.text(ObsCopy.subtitle);
  final motto = find.text(ObsCopy.motto);
  final body = find.text(ObsCopy.body, skipOffstage: false);

  testWidgets('at 1280 × 832 every line sits where the frame puts it', (
    tester,
  ) async {
    await pumpSite(tester, const Size(1280, 832));

    // Line centres from the Figma frame "Home" (node 7:6). A laid-out
    // paragraph reports its height rounded up to a whole pixel while the
    // line inside keeps its exact box, so check the box's top.
    double lineTop(TextStyle style, double centre) =>
        centre - style.fontSize! * style.height! / 2;
    expect(
      tester.getTopLeft(wordmark).dy,
      closeTo(lineTop(ObsType.wordmark, 416 - 36.83), 0.01),
    );
    expect(
      tester.getTopLeft(subtitle).dy,
      closeTo(lineTop(ObsType.subtitle, 416 + 56.67), 0.01),
    );
    expect(
      tester.getTopLeft(motto).dy,
      closeTo(lineTop(ObsType.motto, 784), 0.01),
    );
    expect(tester.getCenter(wordmark).dx, closeTo(639.5, 0.01));
    expect(tester.getCenter(subtitle).dx, closeTo(639.5, 0.01));
    expect(tester.getCenter(motto).dx, closeTo(640, 0.01));

    // Screen 2: the copy is 836 wide at x = 222, centred 0.5 below the
    // middle of the second frame.
    expect(tester.getTopLeft(body).dx, 222);
    expect(tester.getSize(body).width, ObsLayout.bodyWidth);
    expect(tester.getCenter(body).dy, closeTo(832 + 416.5, 0.01));
    expect(tester.getSize(find.byType(BodyScreen)).height, 832);
  });

  testWidgets('no overflow from a small phone to a wide desktop', (
    tester,
  ) async {
    for (final size in const [
      Size(320, 568),
      Size(360, 740),
      Size(390, 844),
      Size(844, 390),
      Size(768, 1024),
      Size(1024, 700),
      Size(1366, 768),
      Size(1920, 1080),
      Size(2560, 1440),
    ]) {
      await pumpSite(tester, size);
      expect(tester.takeException(), isNull, reason: '$size');

      // The lockup stays inside the gutters, and above the motto.
      final lockup = tester
          .getRect(wordmark)
          .expandToInclude(tester.getRect(subtitle));
      final words = Rect.fromLTRB(
        tester.getRect(wordmark).left,
        lockup.top,
        tester.getRect(wordmark).right,
        lockup.bottom,
      );
      expect(words.left, greaterThanOrEqualTo(0), reason: '$size');
      expect(words.right, lessThanOrEqualTo(size.width), reason: '$size');
      expect(
        tester.getCenter(subtitle).dy,
        lessThan(tester.getCenter(motto).dy - 40),
        reason: '$size: lockup clear of the motto',
      );

      // The motto is always wider than the window.
      expect(
        tester.getSize(motto).width,
        greaterThan(size.width),
        reason: '$size: the motto bleeds off both edges',
      );

      // The copy keeps its gutters.
      expect(tester.getTopLeft(body).dx, greaterThanOrEqualTo(24));
      expect(tester.getTopRight(body).dx, lessThanOrEqualTo(size.width - 24));
    }
  });

  testWidgets('the lockup is full size on ordinary windows and shrinks only '
      'where it would not fit', (tester) async {
    for (final (size, scale) in const [
      (Size(1280, 832), 1.0),
      (Size(1366, 768), 1.0),
      (Size(1280, 600), 1.0),
      (Size(390, 844), (390 - 48) / 640),
      (Size(844, 390), 390 / 560),
    ]) {
      await pumpSite(tester, size);
      // On screen, so the FittedBox's scale is included; the paragraph's
      // height is rounded up to a whole pixel before scaling.
      expect(
        tester.getRect(wordmark).height,
        closeTo(
          (ObsType.wordmark.fontSize! * ObsType.wordmark.height!).ceil() *
              scale,
          0.01,
        ),
        reason: '$size',
      );
    }
  });

  testWidgets('a phone\'s address bar coming and going does not resize the '
      'screens; rotating does', (tester) async {
    await pumpSite(tester, const Size(390, 844));
    final screen = find.byType(LockupScreen);
    expect(tester.getSize(screen).height, 844);

    for (final height in const [900.0, 760.0]) {
      tester.view.physicalSize = Size(390, height);
      await tester.pumpAndSettle();
      expect(tester.getSize(screen).height, 844, reason: '$height');
    }

    tester.view.physicalSize = const Size(844, 390);
    await tester.pumpAndSettle();
    expect(tester.getSize(screen).height, 390);
  });

  testWidgets('the copy steps down to 18 on a phone and wraps inside it', (
    tester,
  ) async {
    await pumpSite(tester, const Size(390, 844));
    final text = tester.widget<Text>(body);
    expect(text.style!.fontSize, 18);
    expect(tester.getSize(body).width, 390 - 48);
    // Taller than a screen: the second screen grows to fit it.
    final screen = tester.getSize(find.byType(BodyScreen)).height;
    expect(screen, greaterThanOrEqualTo(tester.getSize(body).height + 192));
  });
}
