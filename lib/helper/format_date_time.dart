import 'package:intl/intl.dart';

class FormatDateTime {
  String formatDateTime(String dateTime) {
    // Chuyển chuỗi thành đối tượng DateTime
    DateTime parsedDate = DateTime.parse(dateTime);

    // Lấy giờ và phút
    String hour = parsedDate.hour.toString().padLeft(2, '0');
    String minute = parsedDate.minute.toString().padLeft(2, '0');

    // Định dạng ngày tháng năm
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

    // Kết hợp thành chuỗi theo định dạng mong muốn
    return '${hour}h${minute}p - $formattedDate';
  }
}