class Materials {
  final String id;
  final String classId;
  final String? materialName;
  final String? description;
  final String? materialLink;
  final String? materialType;

  Materials({
    required this.id,
    required this.classId,
    required this.materialName,
    required this.description,
    required this.materialLink,
    required this.materialType,
  });

  factory Materials.fromJson(Map<String, dynamic> json) {
    return Materials(
      id: json['id'],
      classId: json['class_id'],
      materialName: json['material_name'],
      description: json['description'],
      materialLink: json['material_link'],
      materialType: json['material_type'],
    );
  }
}
