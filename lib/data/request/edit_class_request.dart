class EditClassRequest {
  String? token;
  String? classId;
  String? className;
  String? status;
  String? startDate;
  String? endDate;

  EditClassRequest({
    required this.token,
    required this.classId,
    required this.className,
    required this.status,
    required this.startDate,
    required this.endDate
  });
}