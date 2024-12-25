class ClassCreateRequest {
  String token;
  String classId;
  String className;
  String? classType;  // LT, BT, LT_BT
  String startDate;
  String endDate;
  int maxStudentAmount;

  // Constructor
  ClassCreateRequest({
    required this.token,
    required this.classId,
    required this.className,
    this.classType,
    required this.startDate,
    required this.endDate,
    required this.maxStudentAmount,
  });

  // Phương thức để chuyển đối tượng thành Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'class_id': classId,
      'class_name': className,
      'class_type': classType,
      'start_date': startDate,
      'end_date': endDate,
      'max_student_amount': maxStudentAmount,
    };
  }

  // Phương thức để tạo đối tượng từ Map (JSON)
  factory ClassCreateRequest.fromJson(Map<String, dynamic> json) {
    return ClassCreateRequest(
      token: json['token'],
      classId: json['class_id'],
      className: json['class_name'],
      classType: json['class_type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      maxStudentAmount: json['max_student_amount'],
    );
  }


}
