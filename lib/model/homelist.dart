import 'package:flutter/widgets.dart';
import 'package:wild_explorer/chatopenai/chat_ai_screen.dart';
import 'package:wild_explorer/detection/detection_home_screen.dart';
import 'package:wild_explorer/discovery/discovery_home_screen.dart';
import 'package:wild_explorer/learning/learning_home_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/chatopenai/open-ai-chatgpt.jpg',
      navigateScreen: const ChatAIScreen(),
    ),
    HomeList(
        imagePath: 'assets/learning/learning.jpg',
        navigateScreen: LearnHomeScreen()),
    HomeList(
      imagePath: 'assets/detection/detection.png',
      navigateScreen: const DetectionHomeScreen(),
    ),
    HomeList(
        imagePath: 'assets/discovery/discovery.jpg',
        navigateScreen: const DiscoveryHomeScreen()),
  ];
}
