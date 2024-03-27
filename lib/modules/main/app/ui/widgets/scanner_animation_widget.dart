import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScannerAnimationWidget extends AnimatedWidget {
  final bool stopped;
  final double width;

  const ScannerAnimationWidget({
    Key? key,
    required Animation<double> animation,
    required this.stopped,
    required this.width,
  }) : super(
          key: key,
          listenable: animation,
        );

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    final scorePosition = (animation.value * 440) - 40;

    Color color1 = const Color(0xFFFBAD1B).withOpacity(0.7);
    Color color2 = const Color(0x00FBAD1B);

    if (animation.status == AnimationStatus.reverse) {
      color1 = const Color(0x00FBAD1B);
      color2 = const Color(0xFFFBAD1B).withOpacity(0.7);
    }

    return Positioned(
      bottom: scorePosition.h,
      child: Opacity(
        opacity: stopped ? 0.0 : 1.0,
        child: Container(
          height: 150.h,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.1, 0.9],
              colors: [color1, color2],
            ),
          ),
        ),
      ),
    );
  }
}
