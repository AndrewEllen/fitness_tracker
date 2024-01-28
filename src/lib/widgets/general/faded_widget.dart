import 'package:flutter/material.dart';

///https://stackoverflow.com/questions/76139179/flutter-image-fade-out-at-the-four-edges-gradient

class FadedWidget extends StatelessWidget {
  final Widget child;
  final List<double> stops;
  final List<Color> colorsForStops;

  FadedWidget({
    super.key,
    required this.child,
    this.stops = const [0.4, 0.9, 1],
    List<double> opacities = const [1, 1, 0.4],
  }) : colorsForStops = opacities
      .map((double opacity) => Colors.black.withOpacity(opacity))
      .toList();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: stops,
          colors: colorsForStops,
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            stops: stops,
            colors: colorsForStops,
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: stops,
              colors: colorsForStops,
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.dstIn,
          child: ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: stops,
                colors: colorsForStops,
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: child,
          ),
        ),
      ),
    );
  }
}