import 'dart:io';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path show join;

Future<String> savingModelFile() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  // final String modelDirectory = join(directory.path, 'mobilenetv2_v3.ptl');
  final String modelDirectory = path.join(directory.path, 'mobilenetv2.ptl');

  if (!File(modelDirectory).existsSync()) {
    final ByteData data =
        await rootBundle.load('assets/model_ai/mobilenetv2.ptl');
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(modelDirectory).writeAsBytes(bytes);
  }
  return modelDirectory;
}
