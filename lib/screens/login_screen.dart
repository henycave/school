import 'package:flutter/material.dart';
import 'package:school/components/rounded_button.dart';
import 'package:school/constants.dart';
import 'package:school/screens/a_home_page.dart';
import 'package:school/screens/home_page_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:school/screens/t_home_page_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  String gradeRef;
  String studentDocumentId;
  String teacherDocumentId;
  bool showSpinner = false;
  String role;
  String adminId;
  List<String> listOfAdministeredGrades;
  getData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        email = loggedInUser.email.toString();
        print(email);
      }
      var document = await _firestore
          .collection('students')
          .where('email', isEqualTo: email)
          .get();
      var document1 = await _firestore
          .collection('teachers')
          .where('email', isEqualTo: email)
          .get();
      var document2 = await _firestore
          .collection('principal')
          .where('email', isEqualTo: email)
          .get();
      var document3 = await _firestore
          .collection('head master')
          .where('email', isEqualTo: email)
          .get();
      if (document.docs.isNotEmpty) {
        for (var document in document.docs) {
          role = 'student';
          print(document.data()['grade']);
          gradeRef = document.data()['grade'];
          studentDocumentId = document.id;
          print('student');
        }
      } else if (document1.docs.isNotEmpty) {
        for (var document in document1.docs) {
          role = 'teacher';
          print(document.data()['classHead'][0]);
          gradeRef = document.data()['classHead'][0];
          teacherDocumentId = document.id;
          print('teacher');
        }
      } else if (document2.docs.isNotEmpty) {
        for (var document in document2.docs) {
          role = 'admin';
          adminId = document.id;
          listOfAdministeredGrades = List.from(document.data()['principalOf']);
          print(document.data()['email']);
          print(listOfAdministeredGrades);
        }
      } else if (document3.docs.isNotEmpty) {
        for (var document in document3.docs) {
          role = 'master';
          print(document.data()['email']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Image.asset(
                    'images/girl_reading.png',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFiledDecoration.copyWith(
                        hintText: 'Enter your email')),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFiledDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 25,
                ),
                RoundedButton(
                  text: 'Login',
                  color: Colors.teal,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final signedUser = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      if (signedUser != null) {
                        await getData();
                        if (role == 'student') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePageScreen(
                                        gradeRef: gradeRef,
                                        studentDocumentId: studentDocumentId,
                                      )));
                        } else if (role == 'teacher') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => THomePageScree(
                                        gradeRef: gradeRef,
                                        teacherDocumentId: teacherDocumentId,
                                      )));
                        } else if (role == 'admin') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AHomePage(
                                        listOfAdministeredGrades:
                                            listOfAdministeredGrades,
                                        adminId: adminId,
                                      )));
                        } else if (role == 'master') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AHomePage()));
                        }
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
