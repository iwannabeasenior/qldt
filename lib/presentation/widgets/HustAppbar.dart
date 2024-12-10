import 'package:flutter/material.dart';

class HustAppbar extends StatelessWidget {
  final String title;
  const HustAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text("HUST", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(title, style: TextStyle(fontSize: 25, color: Colors.white)),
        ],
      ),
      toolbarHeight: 115,
      centerTitle: true,
      backgroundColor: Color(0xFFAE2C2C),
    );
  }
}
