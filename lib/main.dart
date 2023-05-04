import 'package:flutter/material.dart';
import 'package:mum_s/ui/login_page.dart';
import 'package:mum_s/utils/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MUM's",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

//todo: add authentication.
//todo: add google/facebook login.
//todo: add password reset functionality.
//todo: add personal data entry to database and fetch it in app after login.
//todo: add profile picture upload in profile.
//todo: add youtube videos as a playlist.
//todo: notify users when they haven't watched their weekly video.

//optional TODOs.

//todo: add location service and nearest hospital functionality using google maps.
//todo: add reminder functionality.
//todo: add messaging between patient and doctor.
//todo: make diet chart.