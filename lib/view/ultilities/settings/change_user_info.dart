import 'package:flutter/material.dart';
import 'package:wild_explorer/services/api/api_service.dart';

typedef ChangeSettingUserInfoCallBack = void Function(
    InfoType infoType, String value);

class ChangeUserInfo extends StatefulWidget {
  const ChangeUserInfo({
    super.key,
    this.title,
    required this.defaultValue,
    this.setAppUserInfo,
    required this.infoType,
    this.changeSettingUserInfoCallBack,
  });
  final String? title;
  final String defaultValue;
  final VoidCallback? setAppUserInfo;
  final InfoType infoType;
  final ChangeSettingUserInfoCallBack? changeSettingUserInfoCallBack;
  @override
  State<ChangeUserInfo> createState() => _ChangeUserInfoState();
}

class _ChangeUserInfoState extends State<ChangeUserInfo> {
  late final TextEditingController _controller;
  bool isChanged = false;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.text = widget.defaultValue;
    _controller.addListener(updateButtonState);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateButtonState() {
    setState(() {
      isChanged = _controller.text != widget.defaultValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
        actions: [
          TextButton(
            onPressed: () async {
              if (isChanged) {
                switch (widget.infoType) {
                  case InfoType.name:
                    bool success = await ApiService()
                        .setAppUserInfo(_controller.text, "", "");
                    if (success) {
                      widget.changeSettingUserInfoCallBack
                          ?.call(InfoType.name, _controller.text);
                    }
                    break;
                  case InfoType.phoneNumber:
                    bool success = await ApiService()
                        .setAppUserInfo("", _controller.text, "");
                    if (success) {
                      widget.changeSettingUserInfoCallBack
                          ?.call(InfoType.phoneNumber, _controller.text);
                    }
                    break;
                }
                widget.setAppUserInfo?.call();
                Navigator.of(context).pop();
              }
            },
            child: Text(
              "Done".toUpperCase(),
              style: TextStyle(
                color: isChanged ? Colors.white : Colors.white54,
                fontFamily: 'Rubik',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
        ),
      ),
    );
  }
}

enum InfoType { name, phoneNumber }
