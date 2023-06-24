import 'dart:math';

import 'package:wild_explorer/discovery/discovery_home_screen.dart';

class QuestionGenerateChatOpenai {
  static final List<String> _plantTemplateListQuestion = [
    'Is ___ a flowering plant?',
    'What are the common uses of ___ in traditional medicine?'
        'How does ___ adapt to its specific environment?',
    'What are the main characteristics of ___?',
    'Can ___ tolerate extreme weather conditions?',
    'What is the lifecycle of ___?',
    'How does ___ reproduce?',
    'What are the economic benefits of cultivating ___?',
    'What are the ecological roles of ___ in its ecosystem?',
    'How does ___ obtain nutrients from its surroundings?',
    'What are the unique features of ___ that distinguish it from other plants?'
        'How does ___ interact with other organisms in its habitat?',
    'What are the preferred growing conditions for ___?',
    'How does ___ defend itself against predators or pests?',
    'What are the main threats to the survival of ___ in the wild?',
  ];

  static final List<String> _animalTemplateListQuestion = [
    'Is ___ a mammal, reptile, or bird?',
    'What are the typical habitats of ___?',
    'How does ___ hunt or gather food?',
    'What are the unique physical adaptations of ___?',
    'How does ___ communicate with other members of its species?',
    'What are the natural predators of ___?',
    'What is the average lifespan of ___ in the wild?',
    'Does ___ migrate during certain seasons?',
    'How does ___ defend itself from potential threats?',
    'What are the reproductive behaviors of ___?',
    'Is ___ a solitary animal or does it live in groups?',
    'How does ___ navigate its surroundings?',
    'What is the role of ___ in its ecosystem?',
    'Are there any conservation efforts in place to protect ___?',
    'How does ___ interact with humans, if at all?',
  ];

  static final List<String> _generalTemplateListQuestion = [
    'What is the habitat of ___?',
    'How does ___ obtain its food?',
    'What are the unique characteristics of ___?',
    'How does ___ protect itself from predators?',
    'What is the reproductive process of ___?',
    'How does ___ adapt to its environment?',
    'What role does ___ play in its ecosystem?',
    'How does ___ interact with other species?',
    'What are the common behaviors of ___?',
    'How does ___ contribute to the balance of the ecosystem?',
  ];

  static final Map<String, CategoryType> _specieType = {
    'Bird'.toLowerCase(): CategoryType.animal,
    'Landing Mammal'.toLowerCase(): CategoryType.animal,
    'Zodiac'.toLowerCase(): CategoryType.animal,
    'Insects'.toLowerCase(): CategoryType.animal,
    'Marsupials'.toLowerCase(): CategoryType.animal,
    'Reptiles'.toLowerCase(): CategoryType.animal,
    'Cây công nghiệp'.toLowerCase(): CategoryType.plant,
    'Cây nông nghiệp'.toLowerCase(): CategoryType.plant,
    'Hoa'.toLowerCase(): CategoryType.plant,
  };

  static String generate(String specie, String name) {
    String question = _generalTemplateListQuestion[0].replaceAll("___", name);
    final String key = specie.toLowerCase();
    if (_specieType.containsKey(key)) {
      CategoryType type = _specieType[key]!;
      if (type == CategoryType.animal) {
        int randomIndex = Random().nextInt(_animalTemplateListQuestion.length);
        question =
            _animalTemplateListQuestion[randomIndex].replaceAll('___', name);
      } else if (type == CategoryType.plant) {
        int randomIndex = Random().nextInt(_plantTemplateListQuestion.length);
        question =
            _plantTemplateListQuestion[randomIndex].replaceAll('___', name);
      }
    } else {
      int randomIndex = Random().nextInt(_generalTemplateListQuestion.length);
      question =
          _generalTemplateListQuestion[randomIndex].replaceAll('___', name);
    }
    return question;
  }
}
