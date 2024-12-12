import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:qldt/presentation/bottom_icons.dart';
import 'package:qldt/presentation/page/chat/chat_page.dart';
import 'package:qldt/presentation/page/class/class_list.dart';
import 'package:qldt/presentation/page/notification/notification_page.dart';
import 'package:qldt/presentation/page/settings/settings_page.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pages = <Widget>[
    const NotificationPage(),
    ClassList(),
    const ChatPage(),
    const SettingsPage(),
  ];
  var icons = <IconData>[
    BottomIcon.bell_1,
    BottomIcon.class_icon,
    BottomIcon.chat,
    Icons.settings
  ];
  int _bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _bottomNavIndex,
        children: pages,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: icons,
          splashColor: QLDTColor.green,
          backgroundColor: QLDTColor.red,
          activeColor: QLDTColor.green,
          inactiveColor: Colors.white,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
            });
          }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: QLDTColor.green,
          child: const Text("+", style: TextStyle(fontSize: 20),),
          onPressed: () {
            Navigator.pushNamed(context, '/CreateClass');
          }
      ),
    );
  }
}
