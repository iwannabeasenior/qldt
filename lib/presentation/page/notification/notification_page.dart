import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:qldt/helper/constant.dart';
import 'package:qldt/helper/utils.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';



enum NotiType {
  ABSENCE,
  ACCEPT_ABSENCE_REQUEST,
  REJECT_ABSENCE_REQUEST,
  ASSIGNMENT_GRADE;

  static NotiType fromStringType(String type) {
    return switch(type) {
      "ABSENCE" => NotiType.ABSENCE,
      "ACCEPT_ABSENCE_REQUEST" => NotiType.ACCEPT_ABSENCE_REQUEST,
      "REJECT_ABSENCE_REQUEST" => NotiType.REJECT_ABSENCE_REQUEST,
      "ASSIGNMENT_GRADE" => NotiType.ASSIGNMENT_GRADE,
      _ => NotiType.ABSENCE
    };
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];
  int unreadCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
    fetchUnreadNotificationCount();
  }

  Future<void> fetchNotifications() async {
    final url = Uri.parse("${Constant.BASEURL}/it5023e/get_notifications"); // Replace with your URL
    final payload = {
      "token": UserPreferences.getToken(),
      "index": 0,
      "count": 4,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['meta']['code'] == "1000") {
          setState(() {
            notifications = List<Map<String, dynamic>>.from(jsonResponse['data']);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${jsonResponse['meta']['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch notifications")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> fetchUnreadNotificationCount() async {
    final url = Uri.parse("${Constant.BASEURL}/it5023e/get_unread_notification_count"); // Replace with your API URL
    final payload = {
      "token": UserPreferences.getToken(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['meta']['code'] == "1000") {
          setState(() {
            unreadCount = jsonResponse['data'] ?? 0;
          });
        }
      }
    } catch (e) {
      Logger().d("HelloNhiDay: $e");
    }
  }
  Future<void> markAsRead(int notificationId) async {
    final url = Uri.parse("${Constant.BASEURL}/it5023e/mark_notification_as_read"); // Replace with your API URL
    final payload = {
      "token": UserPreferences.getToken(),
      "notification_id": notificationId.toString(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['meta']['code'] == "1000") {
          setState(() {
            notifications = notifications.map((notification) {
              if (notification['id'] == notificationId) {
                notification['status'] = "READ";
              }
              return notification;
            }).toList();
          });
        }
      }
    } catch (e) {
      Logger().d("HelloNhiDay: $e");
    }
  }

  void forwardNotification() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFAE2C2C),
        toolbarHeight: 115,
        title: Column(
          children: [
            Text(
              'HUST',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Thông báo',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? Center(child: Text("No notifications found"))
          : ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16), // More balanced padding
        separatorBuilder: (context, index) {
          return Divider(color: Colors.grey.shade300, thickness: 1); // Adds a subtle divider
        },
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final isUnread = notification['status'] == "UNREAD";
          final notificationTime = notification['sent_time'] ?? "";
          final type = NotiType.fromStringType(notification['type']);

          return Container(
            margin: EdgeInsets.only(bottom: 12), // Add some spacing between items
            decoration: BoxDecoration(
              color: Colors.white, // Clean white background for list items
              borderRadius: BorderRadius.circular(12), // Rounded corners for each item
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ], // Shadow effect to lift the card
            ),
            child: ListTile(
              onTap: () {
                if (isUnread) {
                  markAsRead(notification['id']);
                  switch(type) {
                    case NotiType.ABSENCE:
                      //navigate
                    case NotiType.ACCEPT_ABSENCE_REQUEST:
                      //navigate
                    case NotiType.REJECT_ABSENCE_REQUEST:
                      //navigate
                    case NotiType.ASSIGNMENT_GRADE:
                      //navigate
                  }
                }
              },
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Consistent padding inside the tile
              leading: Icon(
                Icons.notifications,
                color: isUnread ? Colors.redAccent : Colors.grey, // Highlight unread notifications
              ),
              title: Text(
                notification['title_push_notification'] ?? "No Title",
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                notification['message'] ?? "No Message",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5, // Better line spacing for readability
                ),
              ),
              trailing: Text(
                Utils.formatDateTime(notificationTime),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600, // Subtle date/time color
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
