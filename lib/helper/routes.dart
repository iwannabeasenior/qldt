import 'package:flutter/material.dart';
import 'package:qldt/presentation/page/auth/login/login_page.dart';
import 'package:qldt/presentation/page/auth/signup/signup_page.dart';
import 'package:qldt/presentation/page/chat/chat_detail.dart';
import 'package:qldt/presentation/page/chat/chat_page.dart';
import 'package:qldt/presentation/page/class/class_detail.dart';
import 'package:qldt/presentation/page/class/material/edit_material.dart';
import 'package:qldt/presentation/page/home_page.dart';
import 'package:qldt/presentation/page/manage_class/create_class.dart';
import 'package:qldt/presentation/page/manage_class/open_class_list.dart';
import 'package:qldt/presentation/page/manage_class/register_for_class.dart';
import 'package:qldt/presentation/page/settings/settings_page.dart';
import 'package:qldt/presentation/page/splash_page.dart';

class Routes {
  static dynamic route() {
    return {
      'SplashPage': (BuildContext context) => const SplashPage(),
      'LoginPage': (context) => const LoginPage(),
      'HomePage': (context) => const HomePage(),
      'RegisterForClassPage' : (context) => const RegisterForClass(),
      'OpenClassList': (context) => const OpenClassList(),
      'CreateClass': (context) => const CreateClass(),
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
      case 'LoginPage':
        return MaterialPageRoute(builder: (context) {
          return const LoginPage();
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
      case 'RegisterForClassPage':
        return MaterialPageRoute(builder: (context) {
          return const RegisterForClass();
        });
      case 'OpenClassList':
        return MaterialPageRoute(builder: (context) {
          return const OpenClassList();
        });
      case 'CreateClass':
        return MaterialPageRoute(builder: (context) {
          return const CreateClass();
        });
      case 'ClassDetail':
        final classID = settings.arguments;
        return MaterialPageRoute(builder: (context) {
          return ClassDetail(classID: classID);
        });
      case 'EditMaterial':
        return MaterialPageRoute(builder: (context) {
          return EditMaterialPage();
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
