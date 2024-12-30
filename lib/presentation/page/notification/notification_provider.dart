import 'package:flutter/cupertino.dart';
import 'package:qldt/helper/constant.dart';
import 'package:http/http.dart' as http;

class NotificationProvider extends ChangeNotifier {
  Future<void> sendNotification(String token, String message, String toUser, String type) async {
    // Replace {{prefix}} with the actual base URL of your API
    String url = '${Constant.BASEURL}/it5023e/send_notification';

    // Create the request body
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add the form fields
    request.fields['token'] = token;
    request.fields['message'] = message;
    request.fields['toUser'] = toUser;
    request.fields['type'] = type;

    // Add the image file, if available
    // if (image != null) {
    //   request.files.add(
    //     await http.MultipartFile.fromPath('image', image.path, filename: basename(image.path)),
    //   );
    // }

    // Send the request and handle the response
    try {
      var response = await request.send();

      // Handle the response (e.g., check status code)
      if (response.statusCode == 200) {
        print('Notification sent successfully');
        final responseBody = await response.stream.bytesToString();
        print('Response: $responseBody');
      } else {
        print('Failed to send notification: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}