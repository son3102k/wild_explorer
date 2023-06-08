class ApiConstants {
  static String baseUrl = 'http://172.16.1.80:8081/';
  static String getPopularAnimalEntityUrl =
      'get/entity-top-n?tag_id=1&number=10';
  static String getPopularPlantEntityUrl =
      'get/entity-top-n?tag_id=2&number=10';
  static String getFiveAnimalEntityUrl = 'get/entity-top-n?tag_id=1&number=5';
  static String getFivePlantEntityUrl = 'get/entity-top-n?tag_id=2&number=5';
  static String getEntityByName = 'get/entity?name=';
  static String getQuizListData = 'quiz/list';
}
