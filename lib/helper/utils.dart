import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String datetimeFormatter(DateTime datetime) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(datetime);
    return formattedDate;
  }
  static void showErrorDialog({required BuildContext context, required String message}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Notification'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close')
            ),
          ],
        )
    );
  }
  static String formatDateTime(String dateTime) {
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
  static Future<void> launchUrlString(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open url';
    }
  }
}