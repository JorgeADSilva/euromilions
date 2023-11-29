import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euromilions/dashboard_content.dart';
import 'package:euromilions/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Euromilhões - Arrifanenses',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Constants.bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: Constants.secondaryColor,
        ),
        home: const Scaffold(
            body:
                DashboardContent() //UserInformation(), /*DashboardContent()*/ //UserInformation(),
            ));
  }
}