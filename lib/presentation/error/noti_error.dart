import 'package:flutter/material.dart';

void showDialogError({required context, required int code}) {
  String message;
  switch(code) {
    case 1000:

    case 9992:
      message = 'Bài viết không tổn tại';
    case 9993:
      message = 'Mã xác thực không đúng';
    case 9994:
      message = 'Không có dữ liệu hoặc không còn dữ liệu';
    case 9995:
      message = 'Không có người dùng này';
    case 9996:
      message = 'Người dùng đã tổn tại';
    case 9997:
      message = 'Phương thức không đúng';
    case 9998:
      message = 'Sai token';
    case 9999:
      message = 'Lỗi exception';
    case 1001:
      message = 'Lỗi mất kết nối DB';
    case 1002:
      message = 'Số lượng tham số không đầy đủ';
    case 1003:
      message = 'Kiểu tham số không đúng đắn';
    case 1004:
      message = 'Giá trị của tham số không hợp lệ';
    case 1005:
      message = 'Lỗi không rõ';
    case 1006:
      message = 'Cỡ file vượt mức cho phép';
    case 1007:
      message = 'Upload thất bại';
    case 1008:
      message = 'Số lượng hình ảnh vượt quá quy định';
    case 1009:
      message = 'Không có quyền truy cập tài nguyên';
    case 1010:
      message = 'Hành động đã được người dùng thực hiện trước đây';
    default:
      message = 'Lỗi không xác định';
  }
  if (code != 1000) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Có lỗi xảy ra"),
        content: Text(message)
      )
    );
  }
}