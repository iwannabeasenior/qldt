// {
// "id": "1",
// "name": "Hoang"
// }

class Lecture {
  String id;
  String name;

  Lecture(
      {
        required this.id,
        required this.name,
      }
      );

  factory Lecture.fromJson(Map<String, dynamic>map) {
    return Lecture(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Lecture && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  String toString() {
    return 'Lecture{id: $id, name: $name}';
  }

}
