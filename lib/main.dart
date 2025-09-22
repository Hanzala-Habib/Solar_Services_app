
import 'dart:developer';

import 'package:crmproject/screens/HomeScreen/admin_screen.dart';
import 'package:crmproject/screens/HomeScreen/client_screen.dart';
import 'package:crmproject/screens/HomeScreen/manager_screen.dart';
import 'package:crmproject/screens/HomeScreen/reseller_screen.dart';
import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:crmproject/screens/SignUpScreen/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Background/Terminated message: ${message.notification?.title}");
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void _showPage(String text) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text("Notification Clicked")),
          body: Center(child: Text(text)),
        ),
      ),
    );
  }




  String? _token = "";

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  Future<void> _initFCM() async {
    await FirebaseMessaging.instance.requestPermission();

    String? token = await FirebaseMessaging.instance.getToken();
    setState(() => _token = token);
    print("✅ FCM Token: $_token");

    // 🔹 Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground message: ${message.notification?.title}");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(message.notification?.title ?? "No Title"),
          content: Text(message.notification?.body ?? "No Body"),
        ),
      );
    });

    // 🔹 When app is opened from background (notification tap)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📩 Opened from background: ${message.notification?.title}");
      _showPage("Opened from background: ${message.notification?.title}");
    });

    // 🔹 When app is opened from terminated state
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("📩 Opened from terminated: ${initialMessage.notification?.title}");
      _showPage("Opened from terminated: ${initialMessage.notification?.title}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      initialRoute: "/signup",
      getPages: [
        GetPage(name: "/signup", page: () => SignUpScreen()),
        GetPage(name: "/login", page: () => LoginScreen()),
        GetPage(name: "/ClientScreen", page: () =>ClientScreen() ),
        GetPage(name: "/ManagerScreen", page: () =>ManagerScreen()),
        GetPage(name: "/adminScreen", page: () => AdminScreen()),
        GetPage(name: "/ResellerScreen", page: () => ResellerScreen()),
      ],
      debugShowCheckedModeBanner: false,

    );
  }
}


