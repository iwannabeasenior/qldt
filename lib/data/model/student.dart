// {
// "id":"20211012",
// "username": "hoangpro11512",
// "code": "20211012",
// "description": "Nguyen Huy Hoang lop IT1-03K66",
// "address": "Hanoi",
// "link": "fb.com",
// "city": "Vinh",
// "country": "Vietnam",
// "friend": 25,
// "coins": 1000
// },

class Student {
  String id;
  String username;
  String img;
  String code;
  String description;
  String address;
  String link;
  String city;
  String country;
  int friend;
  int coins;

  Student(
      {
        required this.id,
        required this.username,
        required this.img,
        required this.code,
        required this.description,
        required this.address,
        required this.link,
        required this.city,
        required this.country,
        required this.friend,
        required this.coins
      }
  );

  factory Student.fromJson(Map<String, dynamic>map) {
    return Student(
      id: map['id'],
      username: map['username'],
      img: map['img'],
      code: map['code'],
      description: map['description'],
      address: map['address'],
      link: map['link'],
      city: map['city'],
      country: map['country'],
      friend: map['friend'],
      coins: map['coins'],
  );
}

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Student && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  String toString() {
    return 'Student{id: $id, username: $username, img: $img, code: $code, '
        'description: $description, address: $address, link: $link, city: $city, '
        'country: $country, friend: $friend, coins: $coins}';
  }

}
