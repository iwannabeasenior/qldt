import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
}