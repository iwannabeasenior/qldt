import 'package:flutter/material.dart';

class DetailInfo extends StatefulWidget {
  const DetailInfo({super.key});

  @override
  State<DetailInfo> createState() => DetailInfoState();
}

class DetailInfoState extends State<DetailInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Column(
              children: [
                Text(
                  'HUST',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                Text(
                  'Chỉnh sửa thông tin cá nhân',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                )
              ],
            ),
            backgroundColor: const Color(0xffAE2C2C),
            centerTitle: true,
            toolbarHeight: 115,
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(
              color: Colors.white
            ),
          ),
    ));
  }
}
