import 'dart:developer';

import 'package:crmproject/screens/AdminScreen/admin_screen.dart';
import 'package:crmproject/screens/ClientScreen/client_screen.dart';
import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:crmproject/screens/ManagerScreen/manager_profile_screen.dart';
import 'package:crmproject/screens/ResellerScreen/reseller_profile_screen.dart';
import 'package:crmproject/screens/SignUpScreen/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Background/Terminated message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    print(" FCM Token: $_token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(" Foreground message: ${message.notification?.title}");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(message.notification?.title ?? "No Title"),
          content: Text(message.notification?.body ?? "No Body"),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(" Opened from background: ${message.notification?.title}");
      _showPage("Opened from background: ${message.notification?.title}");
    });

    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print(" Opened from terminated: ${initialMessage.notification?.title}");
      _showPage(
          "Opened from terminated: ${initialMessage.notification?.title}");
    }
  }

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

  Widget _getInitialScreen() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return LoginScreen();
    } else {
      return FutureBuilder<DocumentSnapshot>(
        future:
        FirebaseFirestore.instance.collection("users").doc(user.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final role = data?["role"];

          if (role == "Admin") return const AdminScreen();
          if (role == "Manager") return ClientScreen(title: 'Manager Products',);
          if (role == "Reseller") return const ResellerScreen();
          return ClientScreen(); // default
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: _getInitialScreen(),
      getPages: [
        GetPage(name: "/signup", page: () => const SignUpScreen()),
        GetPage(name: "/login", page: () => LoginScreen()),
        GetPage(name: "/ClientScreen", page: () =>ClientScreen()),
        GetPage(name: "/ManagerScreen", page: () => const ManagerScreen()),
        GetPage(name: "/adminScreen", page: () => const AdminScreen()),
        GetPage(name: "/ResellerScreen", page: () => const ResellerScreen()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
