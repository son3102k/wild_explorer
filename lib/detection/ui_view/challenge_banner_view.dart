import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wild_explorer/detection/challenge/challenge_detail_screen.dart';
import 'package:wild_explorer/detection/detection_theme.dart';

class ChallengeBannerView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final VoidCallback? callback;
  const ChallengeBannerView(
      {Key? key, this.animationController, this.animation, this.callback})
      : super(key: key);

  @override
  State<ChallengeBannerView> createState() => _ChallengeBannerViewState();
}

class _ChallengeBannerViewState extends State<ChallengeBannerView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.black54,
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.srcATop,
                    ),
                    image: AssetImage(
                      'assets/images/challenge_banner_background.jpg',
                    ),
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
                            painter: HexagonPainter(
                                color: Colors.white,
                                filled: false), // Màu và độ dày của border
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
                    Expanded(child: Container()),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: DetectionTheme.nearlyDarkBlue,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          moveTo();
                        },
                        child: Text(
                          "start challenge".toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            widget.callback?.call();
                          },
                          child: Text(
                            'View all challenges',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              fontFamily: 'Rubik',
                              fontSize: 16,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void moveTo() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const ChallengeDetailScreen(),
      ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;
  final bool filled;

  HexagonPainter({
    required this.color,
    required this.filled,
  });
  @override
  void paint(Canvas canvas, Size size) {
    late final paint;
    if (filled) {
      paint = Paint()
        ..color = DetectionTheme.nearlyDarkBlue
        ..style = PaintingStyle.fill;
    } else {
      paint = Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.fill;
    }

    final borderPaint = Paint()..color = Colors.transparent;

    final dottedPaint = Paint()..color = color;

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
