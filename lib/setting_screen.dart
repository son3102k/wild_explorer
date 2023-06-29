import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wild_explorer/app_theme.dart';
import 'package:wild_explorer/extensions/buildcontext/loc.dart';
import 'package:wild_explorer/model/app-user-info.dart';
import 'package:wild_explorer/services/api/api_service.dart';
import 'package:wild_explorer/view/ultilities/settings/change_user_info.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key, this.userInfo, this.setAppUserInfo});
  final AppUserInfo? userInfo;
  final VoidCallback? setAppUserInfo;
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late AppUserInfo? settingUserInfo;
  late CameraController controller;
  File? _image;
  late final _picker;
  @override
  void initState() {
    super.initState();
    settingUserInfo = widget.userInfo;
    _picker = ImagePicker();
  }

  void moveToChangeUserInfo(
      String title, String defaultValue, InfoType infoType) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => ChangeUserInfo(
          title: title,
          defaultValue: defaultValue,
          setAppUserInfo: () {
            widget.setAppUserInfo?.call();
          },
          infoType: infoType,
          changeSettingUserInfoCallBack: (infoType, value) {
            changeSettingUserInfoCallBack(infoType, value);
          },
        ),
      ),
    );
  }

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    } else {
      setState(() {
        _image = null;
      });
    }
  }

  void changeSettingUserInfoCallBack(InfoType infoType, String value) {
    if (settingUserInfo != null) {
      if (infoType == InfoType.name) {
        AppUserInfo tmp = AppUserInfo(
          email: settingUserInfo!.email,
          avatarLink: settingUserInfo!.avatarLink,
          phoneNumber: settingUserInfo!.phoneNumber,
          name: value,
        );
        setState(() {
          settingUserInfo = tmp;
        });
      }
      if (infoType == InfoType.phoneNumber) {
        AppUserInfo tmp = AppUserInfo(
          email: settingUserInfo!.email,
          avatarLink: settingUserInfo!.avatarLink,
          phoneNumber: value,
          name: settingUserInfo!.name,
        );
        setState(() {
          settingUserInfo = tmp;
        });
      }
    }
  }

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
                        CustomButton("Name", settingUserInfo?.name ?? "", () {
                          moveToChangeUserInfo(
                            'Username',
                            settingUserInfo?.name ?? "",
                            InfoType.name,
                          );
                        }),
                        CustomButton(
                            "Email", settingUserInfo?.email ?? "", () {}),
                        AvatarButton(settingUserInfo?.avatarLink ?? "",
                            () async {
                          await availableCameras();
                          await _openImagePicker();
                          if (_image != null) {
                            String base64String =
                                await convertFileToBase64(_image);
                            bool success = await ApiService()
                                .setAppUserInfo("", "", base64String);
                            if (success) {
                              widget.setAppUserInfo?.call();
                            }
                          }
                        }),
                        CustomButton(
                            "Phone number", settingUserInfo?.phoneNumber ?? "",
                            () {
                          moveToChangeUserInfo(
                            'Phone number',
                            settingUserInfo?.phoneNumber ?? "",
                            InfoType.phoneNumber,
                          );
                        }),
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
                    child: settingUserInfo != null
                        ? (settingUserInfo!.avatarLink != ""
                            ? (_image == null
                                ? Image.network(
                                    settingUserInfo!.avatarLink,
                                    fit: BoxFit.scaleDown,
                                  )
                                : Image.file(
                                    _image!,
                                    fit: BoxFit.scaleDown,
                                  ))
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

  Future<String> convertFileToBase64(File? file) async {
    if (file == null) {
      return '';
    }

    List<int> fileBytes = await file.readAsBytes();
    String base64Image = base64Encode(fileBytes);

    return base64Image;
  }
}
