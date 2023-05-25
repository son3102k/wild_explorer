import 'package:flutter/material.dart';

import '../../chatopenai/utils/drop_down.dart';

class ChatService {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        backgroundColor: const Color(0xFF343541),
        builder: (context) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  "Choose Model:",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
                Flexible(flex: 2, child: ModelsDropDownWidget())
              ],
            ),
          );
        });
  }
}
