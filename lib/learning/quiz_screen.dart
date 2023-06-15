import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wild_explorer/learning/learning_theme.dart';
import 'package:wild_explorer/learning/model/answer.dart';
import 'package:wild_explorer/learning/model/question.dart';
import 'package:wild_explorer/services/api/api_service.dart';
import 'package:wild_explorer/view/ultilities/dialogs/quiz_correct_dialog.dart';
import 'package:wild_explorer/view/ultilities/dialogs/quiz_wrong_dialog.dart';

class QuizScreen extends StatefulWidget {
  final int quizId;
  final String title;
  const QuizScreen({super.key, required this.quizId, required this.title});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _isLoading = false;
  List<Question>? questionList;
  int _index = 0;
  List<bool> questionNumber = List.filled(5, false);

  Future<bool> fetchData() async {
    if (questionList != null) {
      if (questionList!.isEmpty) {
        questionList = await ApiService().getQuiz(widget.quizId);
      }
    } else {
      questionList = await ApiService().getQuiz(widget.quizId);
    }
    await Future.delayed(Duration(milliseconds: 500));
    return true;
  }

  void next() {
    setState(() {
      _index += 1;
    });
  }

  Future<void> newQuiz() async {
    setState(() {
      _isLoading = true;
      _index = 0;
      questionList = null;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || _isLoading) {
            return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getUITopBar(),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: _index < 5
                          ? Column(
                              children: [
                                getUIProgessBar(),
                                SizedBox(
                                  height: 30,
                                ),
                                getUIQuestion(),
                                SizedBox(
                                  height: 30,
                                ),
                                getUIAnswers(),
                              ],
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quiz complete',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Rubik',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Your score is: ' + getScore() + ' / 5',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      constraints:
                                          BoxConstraints(maxHeight: 120),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          'Never give up!',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                LearningTheme.buildLightTheme()
                                                    .primaryColor,
                                            textStyle:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          onPressed: () async {
                                            await newQuiz();
                                          },
                                          child: Text(
                                            "Play a new quiz".toUpperCase(),
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
                            ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget getUIProgessBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.from(
        questionNumber.asMap().entries.map((entry) {
          int idx = entry.key;
          bool val = entry.value;
          int length = questionNumber.length;
          return Row(
            children: [
              (idx > 0 && idx < length)
                  ? Container(
                      width: 30,
                      height: 5,
                      color: idx < _index
                          ? (val == true ? Colors.green : Colors.red)
                          : Colors.grey[300],
                    )
                  : SizedBox(),
              ClipOval(
                child: Container(
                  width: 30,
                  height: 30,
                  color: idx < _index
                      ? (val == true ? Colors.green : Colors.red)
                      : Colors.grey[400],
                  child: idx < _index
                      ? (val == true
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.close,
                              color: Colors.white,
                            ))
                      : (idx == _index
                          ? Icon(
                              Icons.question_mark,
                              color: Colors.white,
                            )
                          : Container()),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget getUIQuestion() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: BoxConstraints(maxHeight: 120),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: (questionList != null
            ? (questionList!.isNotEmpty
                ? Text(
                    questionList![_index].content,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Rubik'),
                  )
                : Container())
            : Container()),
      ),
    );
  }

  Widget getUIAnswers() {
    List<Answer> answerList = <Answer>[];
    if (questionList != null) {
      if (questionList!.isNotEmpty) {
        answerList = questionList![_index].answerList;
      }
    }
    return Column(
      children: List<Widget>.from(answerList.asMap().entries.map((entry) {
        int idx = entry.key;
        Answer val = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: InkWell(
            onTap: () {
              if (val.id == questionList![_index].correctAnswerId) {
                questionNumber[_index] = true;
                showQuizCorrectDialog(context);
              } else {
                questionNumber[_index] = false;
                showQuizWrongDialog(
                  context,
                  questionList![_index].content,
                  findCorrectAnswer(),
                );
              }
              next();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: LearningTheme.buildLightTheme().primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    child: Text(
                      idxToText(idx),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Rubik',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        right: 10,
                      ),
                      child: SizedBox(
                        height: 60,
                        child: AutoSizeText(
                          val.content,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Rubik',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      })),
    );
  }

  Widget getUITopBar() {
    return SizedBox(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/cup-svgrepo-com.svg",
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    color: LearningTheme.buildLightTheme().primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: const Text(
                      'Quiz',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: LearningTheme.buildLightTheme().primaryColor,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String idxToText(int idx) {
    switch (idx) {
      case 0:
        return 'A';
      case 1:
        return 'B';
      case 2:
        return 'C';
      case 3:
        return 'D';
      default:
        return 'A';
    }
  }

  String findCorrectAnswer() {
    int correctAnswerId = questionList![_index].correctAnswerId;
    List<Answer> listAnswer = questionList![_index].answerList;
    for (int i = 0; i < listAnswer.length; i++) {
      if (correctAnswerId == listAnswer[i].id) {
        return listAnswer[i].content;
      }
    }
    return '';
  }

  String getScore() {
    int score = 0;
    for (int i = 0; i < questionNumber.length; i++) {
      if (questionNumber[i] == true) {
        score++;
      }
    }
    return score.toString();
  }
}
