
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double blur;
  final double linearGradientBeginOpacity;
  final double linearGradientEndOpacity;
  final double borderGradientBeginOpacity;
  final double borderGradientEndOpacity;
  final Widget child;
  GlassWidget({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.blur,
    required this.linearGradientBeginOpacity,
    required this.linearGradientEndOpacity,
    required this.borderGradientBeginOpacity,
    required this.borderGradientEndOpacity,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GlassmorphicContainer(
        width: width,
        height: height,
        borderRadius: borderRadius,
        blur: blur,
        alignment: Alignment.bottomCenter,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF).withOpacity(linearGradientBeginOpacity),
            Color(0xFFFFFFFF).withOpacity(linearGradientEndOpacity),
          ],
          stops: [
            0.1,
            1,
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFffffff).withOpacity(borderGradientBeginOpacity),
            Color(0xFFFFFFFF).withOpacity(borderGradientEndOpacity),
          ],
        ),
        child: child,
      ),
    );
  }
}
