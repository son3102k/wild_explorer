import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wild_explorer/detection/detection_theme.dart';
import 'package:wild_explorer/discovery/entity_info_screen.dart';
import 'package:wild_explorer/discovery/models/entity.dart';
import 'package:wild_explorer/engine/image_classification.dart';
import 'package:wild_explorer/main.dart';
import 'package:wild_explorer/model/question_generate_chat_openai.dart';
import 'package:wild_explorer/services/api/api_service.dart';

class DetectedScreen extends StatefulWidget {
  final File image;
  const DetectedScreen({super.key, required this.image});

  @override
  State<DetectedScreen> createState() => _DetectedScreenState();
}

class _DetectedScreenState extends State<DetectedScreen> {
  Entity? detectedEntity;

  Future<bool> fetchData() async {
    final bytesData = await widget.image.readAsBytes();
    final imageData = bytesData.buffer.asByteData();
    final output = await ImageClassification.getOutputDict(
      modelPath,
      imageData.buffer
          .asUint8List(imageData.offsetInBytes, imageData.lengthInBytes),
      imageData.lengthInBytes,
    );
    log(output.toString());
    if (output.values.first > 0.2) {
      final name = output.keys.first;
      detectedEntity = await ApiService().getEntityBy(name);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  moveTo() {
    if (detectedEntity != null) {
      Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => EntityInfoScreen(
            entity: detectedEntity!,
          ),
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: DetectionTheme.nearlyDarkBlue,
        elevation: 0,
      ),
      body: Container(
        child: FutureBuilder<bool>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.15,
                        color: DetectionTheme.nearlyDarkBlue,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Transform.translate(
                          offset: const Offset(0, 40),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: FileImage(widget.image),
                                ),
                                detectedEntity == null
                                    ? const SizedBox()
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          detectedEntity!.avatar,
                                          cacheKey: detectedEntity!.avatar,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: Column(
                        children: [
                          Text(
                            detectedEntity != null
                                ? "We belive this is a".toUpperCase()
                                : "We couldn't identify the exact species"
                                    .toUpperCase(),
                            style: DetectionTheme.h1_darkBlue,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          detectedEntity != null
                              ? Text(
                                  detectedEntity!.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 50),
                            height: 50,
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: DetectionTheme.nearlyDarkBlue,
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () {
                                moveTo();
                              },
                              child: Text(
                                detectedEntity != null
                                    ? "view detail".toUpperCase()
                                    : "take another photo".toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          SizedBox(
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: detectedEntity != null
                                  ? [
                                      Text(
                                        QuestionGenerateChatOpenai.generate(
                                          detectedEntity!.specie,
                                          detectedEntity!.name,
                                        ),
                                        style: DetectionTheme.h2_darkBlue,
                                      ),
                                      Text(
                                        QuestionGenerateChatOpenai.generate(
                                            detectedEntity!.specie,
                                            detectedEntity!.name),
                                        style: DetectionTheme.h2_darkBlue,
                                      ),
                                      Text(
                                        QuestionGenerateChatOpenai.generate(
                                            detectedEntity!.specie,
                                            detectedEntity!.name),
                                        style: DetectionTheme.h2_darkBlue,
                                      ),
                                    ]
                                  : [],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
