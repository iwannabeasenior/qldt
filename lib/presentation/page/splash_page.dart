import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Splash Page", style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Splash2');
              },
              child: const Text("Go to Splash2"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFAE2C2C),
          // Thay đổi màu nền của BottomNavigationBar
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/notification.svg",
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill,
                ),
                label: '',
                backgroundColor: Color(0xFFAE2C2C)),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/group.svg",
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill,
                ),
                label: '',
                backgroundColor: Color(0xFFAE2C2C)),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "",
                width: 30,
                height: 30,
                fit: BoxFit.fill,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/chat-round-dots.svg",
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill,
                ),
                label: '',
                backgroundColor: Colors.transparent),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/setting.svg",
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill,
                ),
                label: '',
                backgroundColor: Colors.transparent),
          ]),
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
            color: const Color(0xFF2DB787),
            borderRadius: BorderRadius.circular(32)),
        child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
