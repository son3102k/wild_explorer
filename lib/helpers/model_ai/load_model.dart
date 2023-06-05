import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' show join;

Future<String> savingModelFile() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  // final String modelDirectory = join(directory.path, 'mobilenetv2_v3.ptl');
  final String modelDirectory = join(directory.path, 'mobilenetv2.ptl');

  if (!File(modelDirectory).existsSync()) {
    final ByteData data =
        await rootBundle.load('assets/model_ai/mobilenetv2.ptl');
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(modelDirectory).writeAsBytes(bytes);
  }
  return modelDirectory;
}
