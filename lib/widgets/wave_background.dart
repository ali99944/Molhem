import 'package:Molhem/widgets/wave_clipper.dart';
import 'package:flutter/material.dart';

import '../core/helpers/theme_helper.dart';

class WaveBackground extends StatelessWidget {
  final double height;

  WaveBackground({required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeHelper.primaryColor,
              ThemeHelper.secondaryColor,
            ],
          ),
        ),
      ),
    );
  }
}