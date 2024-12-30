import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/remote/api_service_it4788.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';
import 'package:qldt/data/repo/absence_repository.dart';
import 'package:qldt/data/repo/attendance_repository.dart';
import 'package:qldt/data/repo/assignment_repository.dart';
import 'package:qldt/data/repo/auth_repository.dart';
import 'package:qldt/data/repo/class_repository.dart';
import 'package:qldt/data/repo/manage_class_repository.dart';
import 'package:qldt/data/repo/material_repository.dart';
import 'package:qldt/firebase_options.dart';
import 'package:qldt/helper/routes.dart';
import 'package:qldt/presentation/page/class/class_list_provider.dart';
import 'package:qldt/presentation/page/class/dashboard/info_class/class_info_provider.dart';
import 'package:qldt/presentation/page/notification/notification_provider.dart';
import 'package:qldt/presentation/page/settings/settings_provider.dart';
import 'package:qldt/presentation/page/settings/user_info/user_provider.dart';
import 'package:qldt/presentation/page/class/dashboard/dashboard/absence/absence_provider.dart';
import 'package:qldt/presentation/page/class/dashboard/dashboard/attendance/attendance_provider.dart';
import 'package:qldt/presentation/page/class/material/material_provider.dart';
import 'package:qldt/presentation/page/manage_class/manage_class_provider.dart';
import 'package:qldt/presentation/page/class/homework/lecturer/lecturer_assignments_provider.dart';
import 'package:qldt/presentation/pref/get_shared_preferences.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await FirebaseMessaging.instance.requestPermission();

  await GetSharedPreferences.instance.init();


  String initialRoute;

  if (await UserPreferences.getToken() == null) {
    if (await UserPreferences.checkFirstTime()) {
      initialRoute = 'SplashPage';

    } else {
      initialRoute = 'LoginPage';
    }
  } else {
    initialRoute = 'HomePage';
  }
  // initialRoute = 'UserSearchPage';
  runApp(
      MyApp(intialRoute: initialRoute)
  );
}

// This widget is the root of your application.

class MyApp extends StatefulWidget {

  MyApp({super.key, required this.intialRoute});

  String intialRoute;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final api1 = ApiServiceIT4788Impl();

  final api2 = ApiServiceIT5023EImpl();

  late final AuthRepository authRepo = AuthRepositoryImpl(api1);

  late final ClassRepo classRepo = ClassRepoImpl(api: api2);

  late final MaterialRepo materialRepo = MaterialRepoImpl(api: api2);

  late final AbsenceRepo absenceRepo = AbsenceRepoImpl(api: api2);

  late final AttendanceRepo attendanceRepo = AttendanceRepoImpl(api: api2);
  late final ManageClassRepo manageClassRepo = ManageClassRepoImpl(api: api2);
  late final AssignmentRepo assignmentRepo = AssignmentRepoImpl(api: api2);

  late StompClient stompClient;
  late Future<void> _stompClientFuture;

  // fcm
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String? _fcmToken;


  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Future<void> setupFlutterNotifications() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //   AndroidInitializationSettings('@mipmap/ic_launcher');
  //
  //   const InitializationSettings initializationSettings =
  //   InitializationSettings(android: initializationSettingsAndroid);
  //
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  // Future<void> showNotification(RemoteMessage message) async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //   AndroidNotificationDetails(
  //     'your_channel_id', // Channel ID
  //     'Your Channel Name', // Channel Name
  //     channelDescription: 'Your channel description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //
  //   const NotificationDetails notificationDetails =
  //   NotificationDetails(android: androidNotificationDetails);
  //
  //   // await flutterLocalNotificationsPlugin.show(
  //   //   0, // Notification ID
  //   //   message.notification?.title, // Title
  //   //   message.notification?.body, // Body
  //   //   notificationDetails,
  //   // );
  // }

  Future<void> _getFCMToken() async {
    String? token = await _firebaseMessaging.getToken(vapidKey: "BDlFd79VwMbXPTsRBLp693l6O_2uKECth0eoSbzsv0oPnsI7FT2Ms_v2TngFZmVRV_BS4uTe10t4CapdIEf-yRk");
    _fcmToken = token;
    Logger().d("fcm token: ${token}");
    UserPreferences.setFCMToken(_fcmToken ?? "");
  }

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.

    print("Handling a background message");
  }

  Future<void> _requestPermission() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      FirebaseMessaging.onMessage.listen((message) {
        // handle income message
        Logger().d("Message from foreground");
      });

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _initStompClient() async {
    stompClient = StompClient(
      config: StompConfig.sockJS(
          url: 'http://157.66.24.126:8080/ws',
          onConnect: (frame) {},
          beforeConnect: () async => print('before connect to socket'),
          stompConnectHeaders: {'Authorization': 'Bearer ${UserPreferences.getToken()}'},
          webSocketConnectHeaders: {'Authorization': 'Bearer ${UserPreferences.getToken()}'},
          onWebSocketError: (e) => print('error' + e.toString()),
          onStompError: (d) => print('error stomp'),
          onDisconnect: (f) => print('disconnected socket'),
          onWebSocketDone: () => print("socket established")
      ),
    );
    stompClient.activate();
  }

  @override
  void initState() {
    super.initState();
    // setupFlutterNotifications();
    _requestPermission();

    _getFCMToken();
    // how do i know that initstomp finish before it used in provider.value

    _stompClientFuture = _initStompClient();
  }

  @override
  void dispose() {
    super.dispose();

    stompClient.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _stompClientFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error initializing StompClient: ${snapshot.error}"));
        }
        return _buildApp();
      },
    );
  }

  Widget _buildApp() {
    return MultiProvider(
      providers: [
        Provider.value(value: stompClient),
        Provider.value(value: authRepo),
        Provider.value(value: classRepo),
        Provider.value(value: materialRepo),
        Provider.value(value: absenceRepo),
        Provider.value(value: attendanceRepo),
        Provider.value(value: manageClassRepo),
        Provider.value(value: assignmentRepo),
        ChangeNotifierProvider(create: (_) => UserProvider(authRepo)),
        ChangeNotifierProvider(create: (_) => SettingsProvider(authRepo)),
        ChangeNotifierProvider(create: (_) => MaterialProvider(materialRepo)),
        ChangeNotifierProvider(create: (_) => AbsenceProvider(absenceRepo)),
        ChangeNotifierProvider(create: (_) => AttendanceProvider(attendanceRepo)),
        ChangeNotifierProvider(create: (_) => ManageClassProvider(manageClassRepo)),
        ChangeNotifierProvider(create: (_) => LecturerAssignmentProvider(assignmentRepo)),
        ChangeNotifierProvider(create: (_) => ClassInfoProvider(classRepo)),
        ChangeNotifierProvider(create: (_) => ClassListProvider(repo: classRepo)),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routes: Routes.route(),
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
        initialRoute: widget.intialRoute,
      ),
    );
  }
}