import 'package:wild_explorer/app_theme.dart';
import 'package:wild_explorer/custom_drawer/drawer_user_controller.dart';
import 'package:wild_explorer/custom_drawer/home_drawer.dart';
import 'package:wild_explorer/feedback_screen.dart';
import 'package:wild_explorer/help_screen.dart';
import 'package:wild_explorer/home_screen.dart';
import 'package:wild_explorer/invite_friend_screen.dart';
import 'package:flutter/material.dart';
import 'package:wild_explorer/model/app-user-info.dart';
import 'package:wild_explorer/services/api/api_service.dart';
import 'package:wild_explorer/setting_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  AppUserInfo? userInfo;

  Future<void> fetchData() async {
    final res = await ApiService().getUserInfo();
    setState(() {
      userInfo = res;
    });
  }

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const HomeScreen();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            userInfo: userInfo,
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const HomeScreen();
          });
          break;
        case DrawerIndex.Help:
          setState(() {
            screenView = HelpScreen();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = FeedbackScreen();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = InviteFriend();
          });
          break;
        case DrawerIndex.Settings:
          setState(() {
            screenView = SettingScreen(
              userInfo: userInfo,
              setAppUserInfo: () async {
                await fetchData();
              },
            );
          });
          break;
        default:
          break;
      }
    }
  }
}
