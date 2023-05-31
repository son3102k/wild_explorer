import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wild_explorer/detection/detection_theme.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  CameraMenu option = CameraMenu.camera;
  File? _image;
  // ignore: prefer_typing_uninitialized_variables
  late final _picker;

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _picker = ImagePicker();
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            goBack(context);
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      // final output = await ImageClassification.getOutputDict(
      //                 modelPath,
      //                 imageData.buffer.asUint8List(
      //                     imageData.offsetInBytes, imageData.lengthInBytes),
      //                 imageData.lengthInBytes);
    }
  }

  Future<void> _captureImage() async {
    if (controller.value.isInitialized) {
      final XFile image = await controller.takePicture();

      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    } else {
      return CameraPreview(
        controller,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              IconButton(
                onPressed: () {
                  goBack(context);
                },
                icon: const Icon(Icons.close_rounded),
                color: Colors.white,
              ),
              Expanded(child: Container()),
              Align(
                alignment: Alignment.center,
                child: ClipOval(
                  child: Container(
                    color: DetectionTheme.nearlyWhite,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: InkResponse(
                        highlightShape: BoxShape.circle,
                        onTap: () async {
                          await _captureImage();
                          log(_image.toString());
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: DetectionTheme.nearlyWhite,
                            border: Border.all(
                              color: Colors.green,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            option = CameraMenu.camera;
                          });
                        },
                        child: Text(
                          CameraMenu.camera.name.toUpperCase(),
                          style: DetectionTheme.buttonText,
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: option == CameraMenu.camera
                            ? Border(
                                bottom: BorderSide(
                                color: Colors.green,
                                width: 2,
                              ))
                            : null,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextButton(
                        onPressed: () async {
                          setState(() {});
                          await _openImagePicker();
                          log(_image.toString());
                        },
                        child: Text(
                          CameraMenu.photos.name.toUpperCase(),
                          style: DetectionTheme.buttonText,
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: option == CameraMenu.photos
                            ? Border(
                                bottom: BorderSide(
                                color: Colors.green,
                                width: 2,
                              ))
                            : null,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

enum CameraMenu {
  camera,
  photos,
}
