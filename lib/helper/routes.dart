import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qldt/presentation/page/auth/signin_page.dart';
import 'package:qldt/presentation/page/auth/signup_page.dart';
import 'package:qldt/presentation/page/home_page.dart';
import 'package:qldt/presentation/page/splash_page.dart';

class Routes {
  static dynamic route() {
    return {
      'SplashPage': (BuildContext context) => const SplashPage(),
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
          return SignInPage();
        });
      case 'SignUpPage':
        return MaterialPageRoute(builder: (context) {
          return SignUpPage();
        });
      default:
        return onUnknownRoute(const RouteSettings(name: '/Feature'));
    }
  }
  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
            appBar: AppBar(),
            body: Center(
                child: Text("Unknown Page")
            )
        )
    );
  }
}
