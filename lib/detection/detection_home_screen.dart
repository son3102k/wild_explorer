import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:wild_explorer/detection/bottom_navigation_view/bottom_navigation_view.dart';
import 'package:wild_explorer/detection/camera_screen.dart';
import 'package:wild_explorer/detection/challenge/all_challenge_screen.dart';
import 'package:wild_explorer/detection/challenge/challenge_screen.dart';
import 'package:wild_explorer/detection/detection_theme.dart';
import 'package:wild_explorer/detection/models/tabIcon_data.dart';

class DetectionHomeScreen extends StatefulWidget {
  const DetectionHomeScreen({super.key});

  @override
  _DetectionHomeScreenState createState() => _DetectionHomeScreenState();
}

class _DetectionHomeScreenState extends State<DetectionHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: DetectionTheme.background,
  );

  void callback() {
    animationController?.reverse().then<dynamic>((data) {
      if (!mounted) {
        return;
      }
      setState(() {
        for (int i = 0; i < tabIconsList.length; i++) {
          tabIconsList[i].isSelected = false;
        }
        tabIconsList[1].isSelected = true;
        tabBody = AllChallengeScreen(animationController: animationController);
      });
    });
  }

  @override
  void initState() {
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = ChallengeScreen(
      animationController: animationController,
      callback: callback,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DetectionTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void moveToCameraScreen(List<CameraDescription> cameras) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => CameraScreen(cameras: cameras),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          cameraClick: () async {
            final List<CameraDescription> cameras = await availableCameras();
            moveToCameraScreen(cameras);
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = ChallengeScreen(
                    animationController: animationController,
                    callback: callback,
                  );
                });
              });
            } else {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = AllChallengeScreen(
                      animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
