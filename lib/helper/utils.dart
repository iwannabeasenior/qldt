import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String datetimeFormatter(DateTime datetime) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(datetime);
    return formattedDate;
  }

  static DateTime stringToDateTime(String date) {
    List<String> splitDate ;
    splitDate = date.split('-');
    return DateTime(int.parse(splitDate[0]), int.parse(splitDate[1]), int.parse(splitDate[2]));
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

  static String convertToDirectLink(String googleDriveLink) {
    // Extract the file ID from the input link
    final uri = Uri.parse(googleDriveLink);
    final segments = uri.pathSegments;

    if (segments.contains('file') && segments.length >= 3) {
      final fileId = segments[2]; // Extract the file ID
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    } else {
      throw Exception('Invalid Google Drive link format');
    }
  }

  static String convertToDirectDownloadLink(String driveLink) {
    final regex = RegExp(r'file/d/([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(driveLink);

    if (match != null && match.groupCount > 0) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    } else {
      throw ArgumentError('Invalid Google Drive link format');
    }
  }

}