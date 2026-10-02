import 'package:flutter/material.dart';

import 'src/home_page.dart';
import 'src/tokens.dart';

void main() => runApp(const ObsivisionSite());

class ObsivisionSite extends StatelessWidget {
  const ObsivisionSite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBSIVISION — Tech Foundry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ObsColors.background,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: ObsColors.body.withValues(alpha: 0.35),
        ),
      ),
      home: const HomePage(),
    );
  }
}
