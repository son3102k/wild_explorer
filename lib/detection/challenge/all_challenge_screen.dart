import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wild_explorer/detection/detection_theme.dart';
import 'package:wild_explorer/detection/ui_view/challenge_banner_view.dart';

class AllChallengeScreen extends StatefulWidget {
  final AnimationController? animationController;
  const AllChallengeScreen({super.key, this.animationController});

  @override
  State<AllChallengeScreen> createState() => _AllChallengeScreenState();
}

class _AllChallengeScreenState extends State<AllChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DetectionTheme.nearlyDarkBlue,
        title: Text(
          'all challenges'.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'inprogress'.toUpperCase(),
              style: DetectionTheme.h1_darkBlue,
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              leading: SizedBox(
                width: 80,
                height: 80,
                child: CustomPaint(
                  painter: HexagonPainter(
                    color: Colors.black,
                    filled: false,
                  ), // Màu và độ dày của border
                ),
              ),
              title: Text(
                'protected areas challenge'.toUpperCase(),
                style: DetectionTheme.h2_darkBlue,
              ),
              subtitle: Text('May 2023'),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'not started'.toUpperCase(),
              style: DetectionTheme.h1_darkBlue,
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              leading: SizedBox(
                width: 80,
                height: 80,
                child: CustomPaint(
                  painter: HexagonPainter(
                    color: Colors.black,
                    filled: false,
                  ), // Màu và độ dày của border
                ),
              ),
              title: Text(
                'natural challenge'.toUpperCase(),
                style: DetectionTheme.h2_darkBlue,
              ),
              subtitle: Text('April 2023'),
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              leading: SizedBox(
                width: 80,
                height: 80,
                child: CustomPaint(
                  painter: HexagonPainter(
                    color: Colors.black,
                    filled: false,
                  ), // Màu và độ dày của border
                ),
              ),
              title: Text(
                'climate change challenge'.toUpperCase(),
                style: DetectionTheme.h2_darkBlue,
              ),
              subtitle: Text('March 2023'),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'completed'.toUpperCase(),
              style: DetectionTheme.h1_darkBlue,
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              leading: SizedBox(
                width: 80,
                height: 80,
                child: CustomPaint(
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/medal-award-svgrepo-com.svg',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  painter: HexagonPainter(
                    color: Colors.transparent,
                    filled: true,
                  ),
                ),
              ),
              title: Text(
                'habitats challenge'.toUpperCase(),
                style: DetectionTheme.h2_darkBlue,
              ),
              subtitle: Text('February 2023'),
            ),
          ],
        ),
      )),
    );
  }
}
