import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

void main() async {
  runApp(ObsivisionSite());
}

class ObsivisionSite extends StatelessWidget {
  Future<FragmentProgram> program =
      FragmentProgram.fromAsset('assets/shaders/grain.frag');

  ObsivisionSite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        color: const Color(0xFF1d3557),
        child: Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: FutureBuilder(
                      future: program,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ShaderMask(
                            blendMode: BlendMode
                                .screen, // Blends grain light over your UI
                            shaderCallback: (bounds) {
                              return snapshot.data!.fragmentShader()
                                ..setFloat(0, bounds.width) // uSize.x
                                ..setFloat(1, bounds.height) // uSize.y
                                ..setFloat(
                                    2,
                                    DateTime.now().millisecondsSinceEpoch /
                                        1000.0); // uTime
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.2,
                              color: Colors.red.withValues(alpha: 0.5),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ],
              )),
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
