import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school/screens/loading_page_screen.dart';
import 'package:school/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

final controller = PageController(initialPage: 1);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: await getLandingPage(),
    ),
  );
}

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<Widget> getLandingPage() async {
  return StreamBuilder(
    stream: _auth.authStateChanges(),
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        return LoadingPageScreen(
          isAlreadyLoggedIn: true,
          email: _auth.currentUser.email,
        );
      }
      return LoginScreen();
    },
  );
}
