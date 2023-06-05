import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class ImageClassification {
  static const MethodChannel pytorchChannel = MethodChannel('pytorch_channel');

  static final Map<int, String> mapDiscovery = {
    0: 'cây mía',
    1: 'cây phong',
    2: 'cây sâm',
    3: 'cây quế',
    4: 'cây sấu',
    5: 'cây thông',
    6: 'cây thảo quả',
    7: 'cây trám',
    8: 'cây tràm',
    9: 'cây tre',
    10: 'cây xoan',
    11: 'cây xưa',
    12: 'cà phê',
    13: 'cây bồ kết',
    14: 'cây ca cao',
    15: 'cây chè',
    16: 'cây cao su',
    17: 'cây dó bầu',
    18: 'cây cọ dầu',
    19: 'cây điều',
    20: 'cây hồ tiêu',
    21: 'cây keo',
    22: 'cây lim',
    23: 'cây dừa',
    24: 'cây mây',
    25: 'cây lúa',
    26: 'cây ngô',
    27: 'cây khoai tây',
    28: 'dây khoai lang',
    29: 'cây khoai mì',
    30: 'cây lạc',
    31: 'cây su hào',
    32: 'cây su su',
    33: 'cây bầu',
    34: 'cây rau muống',
    35: 'cây cà tím',
    36: 'cây rau dền',
    37: 'cây rau cải',
    38: 'cây rau mùng tơi',
    39: 'cây rau mầm',
    40: 'cây rau má',
    41: 'cây tía tô',
    42: 'Hoa đỗ quyên',
    43: 'Hoa trà my',
    44: 'Hoa súng',
    45: 'Hoa sao nhái',
    46: 'Hoa thuỷ tiên',
    47: 'Hoa đào',
    48: 'Hoa sứ',
    49: 'Hoa sen',
    50: 'Hoa tường vi',
    51: 'Hoa đồng tiền',
    52: 'Hoa Ly',
    53: 'Hoa quỳnh anh',
    54: 'Hoa lan',
    55: 'Hoa loa kèn',
    56: 'Hoa mẫu đơn ta',
    57: 'Hoa hướng dương',
    58: 'Hoa phượng vĩ',
    59: 'Hoa lộc vừng',
    60: 'Hoa mười giờ',
    61: 'Hoa mai',
    62: 'Hoa dã quỳ',
    63: 'Hoa dâm bụt',
    64: 'Hoa cẩm tú cầu',
    65: 'Hoa dừa cạn',
    66: 'Hoa giấy',
    67: 'Hoa bằng lăng',
    68: 'Hoa huệ',
    69: 'Peacock',
    70: 'Quail',
    71: 'Emu',
    72: 'Pelican',
    73: 'Parrot',
    74: 'Penguin',
    75: 'Eagle',
    76: 'Pheasant',
    77: 'Sparrow',
    78: 'Owl',
    79: 'Kingfisher',
    80: 'Flamingo',
    81: 'Hummingbird',
    82: 'Magpie',
    83: 'Falcon',
    84: 'Anteater',
    85: 'Antelope',
    86: 'Armadillo',
    87: 'Badger',
    88: 'Bat',
    89: 'Bear',
    90: 'Beaver',
    91: 'Boar',
    92: 'Camel',
    93: 'Cat',
    94: 'Cheetah',
    95: 'Chimpanzee',
    96: 'Chinchilla',
    97: 'Chipmunk',
    98: 'Cow',
    99: 'Coyote',
    100: 'Deer',
    101: 'Dog',
    102: 'Donkey',
    103: 'Echidna',
    104: 'Elephant',
    105: 'Fox',
    106: 'Gazelle',
    107: 'Giant panda',
    108: 'Giraffe',
    109: 'Gorilla',
    110: 'Hippopotamus',
    111: 'Hyena',
    112: 'Lemur',
    113: 'Lion',
    114: 'Meerkat',
    115: 'Mole',
    116: 'Moose',
    117: 'Mule',
    118: 'Great white shark',
    119: 'Cuttlefish',
    120: 'Crab',
    121: 'Eel',
    122: 'Dolphin',
    123: 'Flounder',
    124: 'Lobster',
    125: 'Jellyfish',
    126: 'Manta Ray',
    127: 'Horseshoe crab',
    128: 'Barracuda',
    129: 'Clownfish',
    130: 'Coral',
    131: 'Platypus',
    132: 'Catfish',
    133: 'Tiger',
    134: 'Ox',
    135: 'Pig',
    136: 'Snake',
    137: 'Rat',
    138: 'Rabbit',
    139: 'Rooster',
    140: 'Monkey',
    141: 'Dragon',
    142: 'Goat',
    143: 'Horse',
    144: 'Dog',
    145: 'Cat',
    146: 'Ant',
    147: 'Beetle',
    148: 'Butterfly',
    149: 'Caterpillar',
    150: 'Centipede',
    151: 'Dragonfly',
    152: 'Housefly',
    153: 'Grasshopper',
    154: 'Ladybug',
    155: 'Millipede',
    156: 'Scorpion',
    157: 'Snail',
    158: 'Spider',
    159: 'Wasp',
    160: 'Worm',
    161: 'Bee'
  };

  static Future<Map<String, double>> getOutputDict(
      String? modelPath, Uint8List imageData, int dataLength) async {
    var para = {
      "modelPath": modelPath,
      "imageData": imageData,
      "dataLength": dataLength
    };
    final list =
        await pytorchChannel.invokeMethod("image_classification", para);
    var result = list.cast<double>() as List<double>;
    if (Platform.isAndroid) {
      result = result.map((e) => math.exp(e)).toList();
      final sum = result.reduce((value, element) => value + element);
      result = result.map((e) => e / sum).toList();
      log(result.toString());
    }
    var max = -1.0;
    var maxPos = 0;
    for (var i = 0; i < 162; i++) {
      if (result[i] > max) {
        max = result[i];
        maxPos = i;
      }
    }
    if (max < 0.5) max += 0.5;
    var output = {mapDiscovery[maxPos].toString(): max};
    return output;
  }
}
