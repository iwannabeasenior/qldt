import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/presentation/page/auth/signin_page.dart';
import 'package:qldt/presentation/page/auth/signup_page.dart';
import 'package:qldt/presentation/page/chat/chat_detail.dart';
import 'package:qldt/presentation/page/chat/chat_page.dart';
import 'package:qldt/presentation/page/home_page.dart';
import 'package:qldt/presentation/page/settings/settings_page.dart';
import 'package:qldt/presentation/page/splash_page.dart';

class Routes {
  static dynamic route() {
    return {
      'SplashPage': (BuildContext context) => const SplashPage(),
      'SignInPage': (context) => const SignInPage(),
      'HomePage': (context) => const HomePage(),
    };
  }
  static Route? onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name!.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch(pathElements[1]) {
      case 'HomePage':
        return MaterialPageRoute(builder: (context) {
          return const HomePage();
        });
      case 'SignInPage':
        return MaterialPageRoute(builder: (context) {
          return const SignInPage();
        });
      case 'SignUpPage':
        return MaterialPageRoute(builder: (context) {
          return const SignUpPage();
        });
      case 'Splash2':
        return MaterialPageRoute(builder: (context) {
          return const SplashPage();
        });
      case 'ChatDetail':
        var args = settings.arguments as Partner;
        return MaterialPageRoute(builder: (context) {
          return ChatDetail(partner: args);
        });
      case 'SettingsPage':
        return MaterialPageRoute(builder: (context) {
          return const SettingsPage();
        });
      case 'ClassPage':
        return MaterialPageRoute(builder: (context) {
          return const SettingsPage();
        });
      case 'NotificationPage':
        return MaterialPageRoute(builder: (context) {
          return const SettingsPage();
        });
      default:
        return onUnknownRoute(const RouteSettings(name: '/Feature'));
    }
  }
  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
            appBar: AppBar(),
            body: const Center(
                child: Text("Unknown Page")
            )
        )
    );
  }
}
