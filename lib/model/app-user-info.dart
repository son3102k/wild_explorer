class AppUserInfo {
  final String email;
  final String avatarLink;
  final String phoneNumber;
  final String name;
  AppUserInfo({
    required this.email,
    required this.avatarLink,
    required this.phoneNumber,
    required this.name,
  });

  factory AppUserInfo.fromJson(Map<String, dynamic> json) {
    return AppUserInfo(
      email: json["email"],
      avatarLink: json["avatarLink"] ?? "",
      phoneNumber: json["phoneNumber"],
      name: json["name"],
    );
  }
}
