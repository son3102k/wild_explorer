class ChatImages {
  static const String imagePath = "assets/images";
  static const String userImage = "$imagePath/person.png";
  static const String openaiLogo = "$imagePath/openai_logo.jpg";
  static const String botImage = "$imagePath/chat_logo.png";
}

class OpenAIEndpoints {
  static String API_KEY = "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";
  static String baseUrl = "https://api.openai.com";
  static String getAllModels = "$baseUrl/v1/models";
  static String sendMessage = "$baseUrl/v1/completions";
}
