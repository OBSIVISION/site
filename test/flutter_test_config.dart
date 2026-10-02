import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

/// Loads the site's fonts before every test file. flutter_test otherwise
/// draws every glyph a full em wide, so nothing measured would be the page.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final file in files) {
      final bytes = File('assets/fonts/$file').readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }

  await load('Cairo', [
    'Cairo-ExtraLight.ttf',
    'Cairo-ExtraBold.ttf',
    'Cairo-Black.ttf',
  ]);
  await load('Fraunces', ['Fraunces-Regular.ttf']);
  await testMain();
}
