import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wild_explorer/detection/detection_theme.dart';

class ChallengeBannerView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ChallengeBannerView(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.srcATop,
                    ),
                    image: const NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/f/ff/%E4%B9%9D%E5%AF%A8%E6%BA%9D-%E4%BA%94%E8%8A%B1%E6%B5%B7.jpg'),
                    fit: BoxFit.fill),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12, top: 24, right: 12, bottom: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MAY 2023',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Rubik',
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        'PROTECT AREAS CHALLENGE',
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Rubik',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CustomPaint(
                            painter:
                                HexagonPainter(), // Màu và độ dày của border
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Text(
                            'Take observation with the camera to earn the Challenge badge!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              wordSpacing: 1.35,
                            ),
                          ),
                        )
                      ],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        fixedSize: const Size(double.maxFinite, 50),
                        foregroundColor: Colors.white,
                        backgroundColor: DetectionTheme.nearlyDarkBlue,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {},
                      child: Text("START CHALLENGE"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()..color = Colors.transparent;

    final dottedPaint = Paint()..color = Colors.white;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    final path = Path();
    path.moveTo(centerX + radius * cos(pi / 6), centerY - radius * sin(pi / 6));
    for (int i = 1; i <= 6; i++) {
      final double angle = 2 * pi / 6 * i;
      path.lineTo(centerX + radius * cos(angle + pi / 6),
          centerY - radius * sin(angle + pi / 6));
    }
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Vẽ viền dotted border
    const double dotSpacing = 6.0; // Khoảng cách giữa các chấm
    const double dotRadius = 1.0; // Bán kính của chấm

    final List<PathMetric> pathMetrics = path.computeMetrics().toList();
    for (final PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final Tangent tangent = pathMetric.getTangentForOffset(distance)!;
        canvas.drawCircle(tangent.position, dotRadius, dottedPaint);
        distance += dotSpacing;
      }
    }
  }

  @override
  bool shouldRepaint(HexagonPainter oldDelegate) => false;
}
