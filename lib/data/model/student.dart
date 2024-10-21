class Student {
  String username;
  String code;
  String description;
  String address;
  String link;
  String city;
  String country;
  int coins;
  int friend;

  Student({
    required this.username,
    required this.code,
    required this.description,
    required this.address,
    required this.link,
    required this.city,
    required this.country,
    required this.coins,
    required this.friend,
  });

  // Khởi tạo dữ liệu mặc định
  static Student get defaultData {
    return Student(
      username: "user123",
      code: "20211012",
      description: "Mô tả ngắn",
      address: "Địa chỉ ABC",
      link: "https://example.com",
      city: "Hà Nội",
      country: "Việt Nam",
      coins: 10000,
      friend: 25,
    );
  }
}
