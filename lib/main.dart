import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'responsive/ResponsiveRhytmicScreen.dart';
import 'package:url_strategy/url_strategy.dart';




FirebaseOptions get firebaseOptions => const FirebaseOptions(
  apiKey: "AIzaSyAkROI2oh0ZIV8voA94nrkX54CFfCNmuvg",
  projectId: "breathing-technique",
  messagingSenderId: "592090337975",
  appId: "1:592090337975:web:fd274be50b183aa2233332",
);

Future main() async {


  WidgetsFlutterBinding.ensureInitialized();

  /// INITIALIZING FIREBASE
  await Firebase.initializeApp(options: firebaseOptions);
  setPathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ResponsiveRhythmicScreen()
    );
  }
}

