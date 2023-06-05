import 'package:flutter/widgets.dart';
import 'package:wild_explorer/chatopenai/chat_ai_screen.dart';
import 'package:wild_explorer/detection/detection_home_screen.dart';
import 'package:wild_explorer/discovery/discovery_home_screen.dart';
import 'package:wild_explorer/quizz/quizz_home_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png',
      navigateScreen: const ChatAIScreen(),
    ),
    HomeList(
        imagePath: 'assets/hotel/hotel_booking.png',
        navigateScreen: HotelHomeScreen()),
    HomeList(
      imagePath: 'assets/detection/fitness_app.png',
      navigateScreen: const DetectionHomeScreen(),
    ),
    HomeList(
        imagePath: 'assets/design_course/design_course.png',
        navigateScreen: const DiscoveryHomeScreen()),
  ];
}
