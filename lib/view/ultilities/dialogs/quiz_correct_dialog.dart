import 'package:flutter/material.dart';
import 'package:wild_explorer/learning/learning_theme.dart';

Future<void> showQuizCorrectDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Expanded(
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 100,
                ),
              ),
              Text(
                'Wonderful',
                style: TextStyle(
                  color: LearningTheme.buildLightTheme().primaryColor,
                  fontFamily: 'Rubik',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text('Keep it up!'),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 50,
                  width: 100,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor:
                          LearningTheme.buildLightTheme().primaryColor,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "next".toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
