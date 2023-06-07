import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wild_explorer/detection/detection_theme.dart';
import 'package:wild_explorer/discovery/models/entity.dart';
import 'package:wild_explorer/engine/image_classification.dart';
import 'package:wild_explorer/main.dart';
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
    if (output.values.first > 0.5) {
      final specieName = output.keys.first;
      detectedEntity = await ApiService().getEntityBy(specieName);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
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
              return SizedBox();
            } else {
              return Stack(
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
                                    backgroundImage: CachedNetworkImageProvider(
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
              );
            }
          },
        ),
      ),
    );
  }
}
