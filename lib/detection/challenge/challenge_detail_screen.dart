import 'package:flutter/material.dart';
import 'package:wild_explorer/detection/detection_theme.dart';
import 'package:wild_explorer/detection/ui_view/challenge_banner_view.dart';

class ChallengeDetailScreen extends StatefulWidget {
  const ChallengeDetailScreen({super.key});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail'.toUpperCase(),
          style: TextStyle(
              fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: DetectionTheme.nearlyDarkBlue,
        elevation: 0,
      ),
      body: Container(
        color: DetectionTheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
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
                padding:
                    EdgeInsets.only(top: 24, bottom: 12, right: 12, left: 12),
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
                    Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: DetectionTheme.nearlyDarkBlue,
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () {},
                              child: Text(
                                "open camera".toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'your mission'.toUpperCase(),
                      style: DetectionTheme.h2_darkBlue,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Align(
                        alignment: Alignment.center,
                        widthFactor: 0.1,
                        child: Icon(
                          Icons.circle,
                          size: 12,
                        ),
                      ),
                      title: Text(
                          'Find any 4 different birds, mammals, reptoles, amphibians, or fish'),
                    ),
                    ListTile(
                      leading: const Text(''),
                      title: Text(
                        '0 observed so far',
                        style: TextStyle(
                          color: DetectionTheme.nearlyDarkBlue,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Align(
                        alignment: Alignment.center,
                        widthFactor: 0.1,
                        child: Icon(
                          Icons.circle,
                          size: 12,
                        ),
                      ),
                      title: Text('Find 4 different insects'),
                    ),
                    ListTile(
                      leading: const Text(''),
                      title: Text(
                        '0 observed so far',
                        style: TextStyle(
                          color: DetectionTheme.nearlyDarkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
