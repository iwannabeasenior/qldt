class Student {
  String username;
  String description;
  String address;
  String link;
  String city;
  String country;

  Student({
    required this.username,
    required this.description,
    required this.address,
    required this.link,
    required this.city,
    required this.country,
  });

  // Khởi tạo dữ liệu mặc định
  static Student get defaultData {
    return Student(
      username: "user123",
      description: "Mô tả ngắn",
      address: "Địa chỉ ABC",
      link: "https://example.com",
      city: "Hà Nội",
      country: "Việt Nam",
    );
  }
}
