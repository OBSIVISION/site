# OBSIVISION Site

The root page of [obsivision.com](https://obsivision.com): the Figma frame
"Home" in the file *OBSIVISION-Site* (node 7-6), as a Flutter web app.

- `lib/src/tokens.dart` — colours, type and frame geometry from Figma.
- `lib/src/home_page.dart` — the two window-tall screens. At 1280 × 832 each
  is the design frame; elsewhere the lockup keeps its distance from the
  window's centre and shrinks only where it would not fit, and the motto
  scales with the width so it always bleeds off both edges.
- `lib/src/copy.dart` — the words; `web/index.html` repeats them for
  crawlers and readers without script.
- `assets/fonts/` — static instances of Cairo (200, 800, 900) and Fraunces
  (400, SOFT 0, WONK 1, opsz 24), cut from the Google Fonts variable sources
  with `fonttools varLib.instancer`. Both are OFL; the licences sit beside
  them.

```sh
flutter test        # layout is measured in the real fonts (flutter_test_config.dart)
flutter analyze
```

It is built and deployed from [OBSIVISION/infra](https://github.com/OBSIVISION/infra)
(`dart hosting/assemble.dart`, then `firebase deploy --only hosting`), which
serves it at `/` and each project site at `/<slug>/`.
