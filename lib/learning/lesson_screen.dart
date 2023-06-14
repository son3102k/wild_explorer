import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wild_explorer/learning/learning_theme.dart';
import 'package:wild_explorer/learning/model/lesson_detail.dart';
import 'package:wild_explorer/services/api/api_service.dart';

class LessonScreen extends StatefulWidget {
  final String title;
  final int lessonId;
  const LessonScreen({super.key, required this.title, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  LessonDetail? detail;

  Future<bool> fetchData() async {
    detail ??= await ApiService().getLessonDetail(widget.lessonId);
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List<String> sections = detail?.content.split('\\n') ?? <String>[];

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
      body: SingleChildScrollView(
        child: SizedBox(
          child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                return Column(
                  children: [
                    getUITopBar(),
                    Container(
                      color: Colors.white,
                      child: Column(children: [
                        ...sections.map((content) {
                          return Container(
                            margin: EdgeInsets.only(
                              top: 20,
                              bottom: 20,
                            ),
                            width: MediaQuery.of(context).size.width * 0.9,
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
                                content,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                ),
                              ),
                            ),
                          );
                        }),
                      ]),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
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
                  "assets/icons/book-closed-svgrepo-com.svg",
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
                      'Lesson',
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
}
