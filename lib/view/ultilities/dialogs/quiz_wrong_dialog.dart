import 'package:flutter/material.dart';
import 'package:wild_explorer/learning/learning_theme.dart';

Future<void> showQuizWrongDialog(
  BuildContext context,
  String? question,
  String? correctAnswer,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Expanded(
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 100,
                ),
              ),
              Text(
                'You can do better',
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
              Text('The correct answer is:'),
              SizedBox(
                height: 10,
              ),
              question != null
                  ? Text(
                      question,
                      textAlign: TextAlign.center,
                    )
                  : Text(''),
              SizedBox(
                height: 10,
              ),
              correctAnswer != null
                  ? Text(
                      '*' + correctAnswer + '*',
                      textAlign: TextAlign.center,
                    )
                  : Text(''),
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
