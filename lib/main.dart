import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/remote/api_service.dart';
import 'package:qldt/data/repo/class_repository.dart';
import 'package:qldt/helper/routes.dart';
import 'package:qldt/presentation/pref/get_shared_preferences.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await GetSharedPreferences.instance.init();

  String initialRoute;

  if (await UserPreferences.getToken() == null) {
    if (await UserPreferences.checkFirstTime()) {
      // initialRoute = 'SplashPage';
      // initialRoute = 'RegisterForClassPage';
      initialRoute = 'CreateClass';


    } else {
      initialRoute = 'SignInPage';
    }
  } else {
    initialRoute = 'HomePage';
  }
  Logger().d('intitialpage is: $initialRoute');
  runApp(MyApp(intialRoute: initialRoute));
}

// This widget is the root of your application.

class MyApp extends StatelessWidget {

  MyApp({super.key, required this.intialRoute});

  String intialRoute;

  final classRepo = ClassRepositoryImpl(ApiServiceImpl());
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
        providers: [
          Provider.value(value: classRepo),
        ],
      child:  MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routes: Routes.route(),
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
        initialRoute: intialRoute,
      ));
  }
}