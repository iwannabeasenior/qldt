import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

 @override
  State<NotificationPage> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationPage> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Android',
      'date': '24/09/2024',
      'content': 'Đã có điểm cuối kì Android',
      'details': 'Điểm cuối kì Android',
      'score': '9.5',
      'isExpanded': false
    },
    {
      'title': 'PPTTKHT',
      'date': '24/09/2024',
      'content': 'Đã có điểm cuối kì PPTTKHT',
      'details': 'Điểm cuối kì PPTTKHT',
      'score': '9.0',
      'isExpanded': false
    },
    {
      'title': 'Giải tích 1',
      'date': '13/04/2024',
      'content': 'Đã có điểm quá trình Giải tích 1',
      'details': 'Điểm quá trình Giải tích 1',
      'score': '8.5',
      'isExpanded': false
    },
    {
      'title': 'OOP',
      'date': '24/09/2024',
      'content': 'Đã có điểm quá trình OOP',
      'details': 'Điểm quá trình OOP',
      'score': '8.7',
      'isExpanded': false
    },
  ];

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
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          var notification = notifications[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HUST',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      Text(notification['date']),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['title'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      Text(notification['content']),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              notification['isExpanded'] =
                              !notification['isExpanded'];
                            });
                          },
                          child: Text(
                            'Chi tiết',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (notification['isExpanded'])
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(notification['details'],
                              style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          Text(notification['score'],
                              style: TextStyle(fontSize: 40)),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                notification['isExpanded'] = false;
                              });
                            },
                            child: Text('Đóng'),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
