import 'package:flutter/material.dart';

/// Custom scrollbar with gradient colors
class GradientScrollbar extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final double thickness;

  const GradientScrollbar({
    Key? key,
    required this.child,
    this.colors = const [
      Color(0xFF8A5A44),
      Color(0xFFDDB892),
      Color(0xFFEDE0D4),
    ],
    this.thickness = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: true,
      ),
      child: RawScrollbar(
        thumbColor: colors[0],
        thickness: thickness,
        radius: Radius.circular(10),
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: child,
        ),
      ),
    );
  }
}
