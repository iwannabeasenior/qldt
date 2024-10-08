import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/remote/api_service.dart';
import 'package:qldt/data/repo/class_repository.dart';
import 'package:qldt/helper/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final classRepo = ClassRepositoryImpl(ApiServiceImpl());
  // This widget is the root of your application.
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
        initialRoute: "SplashPage",
      ));
  }
}