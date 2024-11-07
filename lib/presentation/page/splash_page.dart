import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QLDTColor.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Image.asset(
              "assets/main-image.png",
              width: 234,
              height: 234,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 50),
            Text("Hust Support",
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            Text("Ứng dụng mới phát hành với nhiều tính năng \n tích hợp 3 in 1 giúp sinh viên bách khoa \n trong việc quản lý ",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/LoginPage');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 50), // Dài ra toàn màn hình, chiều cao 50
              ),
              child: const Text("Get Started"),
            ),
          ],
        ),
      ),
    );
  }
}
