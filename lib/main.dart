import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

void main() {
  runApp(const ObsivisionSite());
}

class ObsivisionSite extends StatelessWidget {
  const ObsivisionSite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        color: const Color(0xFF1d3557),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: const Text(
              "Hello. Yes, this is my site. No, it doesn't scroll. Yes, I'm working on it to have something better than this dismal message.",
              style: TextStyle(color: Color(0xFFf1faee)),
            ),
          ),
        ),
      ),
    );
  }

  /* @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: HtmlElementView.fromTagName(
        tagName: 'iframe',
        onElementCreated: (Object iframe) {
          iframe as web.HTMLIFrameElement;
          iframe.src =
              'https://my.spline.design/untitled-e91931702076d74c4caa04d8eddb64fa/';
          iframe.frameBorder = '0';
          iframe.width = '100%';
          iframe.height = '100%';
        },
      ),
    );
  } */
}
