import 'package:flutter/material.dart';
import 'package:wild_explorer/app_theme.dart';
import 'package:wild_explorer/extensions/buildcontext/loc.dart';
import 'package:wild_explorer/model/app-user-info.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key, this.userInfo});
  final AppUserInfo? userInfo;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
      color: isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor:
              isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 16,
                    right: 16,
                  ),
                ),
                Container(
                  height: 60,
                  child: Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    color: Color.fromRGBO(239, 249, 255, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderText("Account"),
                        CustomButton(
                            "Name", widget.userInfo?.name ?? "", () {}),
                        CustomButton(
                            "Email", widget.userInfo?.email ?? "", () {}),
                        AvatarButton(widget.userInfo?.avatarLink ?? "", () {}),
                        CustomButton("Phone number",
                            widget.userInfo?.phoneNumber ?? "", () {}),
                        Divider(),
                        HeaderText("General"),
                        CustomButton(
                            "Display language", context.loc.localeName, () {}),
                        CustomButton(
                            "Theme",
                            MediaQuery.of(context).platformBrightness.name,
                            () {}),
                        CustomButton("About us", "", () {}),
                        CustomButton("Donation", "", () {}),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget HeaderText(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 20,
        bottom: 20,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromRGBO(0, 182, 240, 1),
          ),
        ),
      ),
    );
  }

  Widget CustomButton(String title, String value, VoidCallback? callback) {
    return Material(
      color: Colors.white.withOpacity(0.0),
      child: InkWell(
        splashColor: Color.fromRGBO(0, 182, 240, 1).withOpacity(0.1),
        highlightColor: Color.fromRGBO(0, 182, 240, 1).withOpacity(0.1),
        onTap: () {
          callback?.call();
        },
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 30,
              right: 30,
              bottom: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  value,
                  style: AppTheme.subtitle,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget AvatarButton(String avatarLink, VoidCallback? callback) {
    return Material(
      color: Colors.white.withOpacity(0.0),
      child: InkWell(
        splashColor: Color.fromRGBO(0, 182, 240, 1).withOpacity(0.1),
        highlightColor: Color.fromRGBO(0, 182, 240, 1).withOpacity(0.1),
        onTap: () {
          callback?.call();
        },
        child: SizedBox(
          width: double.infinity,
          height: 80,
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 30,
              right: 30,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Avatar",
                    style: AppTheme.title,
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.6),
                          offset: const Offset(2.0, 4.0),
                          blurRadius: 8),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    child: widget.userInfo != null
                        ? (widget.userInfo!.avatarLink != ""
                            ? Image.network(
                                widget.userInfo!.avatarLink,
                                fit: BoxFit.scaleDown,
                              )
                            : Image.asset(
                                'assets/images/userImage.jpg',
                                fit: BoxFit.scaleDown,
                              ))
                        : Image.asset(
                            'assets/images/userImage.jpg',
                            fit: BoxFit.scaleDown,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
