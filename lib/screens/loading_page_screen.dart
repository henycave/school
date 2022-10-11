import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:school/screens/a_home_page.dart';
import 'package:school/screens/home_page_screen.dart';
import 'package:school/screens/t_home_page_screen.dart';

class LoadingPageScreen extends StatefulWidget {
  final bool isAlreadyLoggedIn;
  final String email;

  LoadingPageScreen({this.isAlreadyLoggedIn, this.email});

  @override
  _LoadingPageScreenState createState() => _LoadingPageScreenState();
}

class _LoadingPageScreenState extends State<LoadingPageScreen> {
  String gradeRef;
  String studentDocumentId;
  String teacherDocumentId;
  List<String> listOfAdministeredGrades;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    checkIfStudent(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.teal,
          size: 100.0,
        ),
      ),
    );
  }

  checkIfStudent(String email) async {
    try {
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
          print(document.data()['grade']);
          gradeRef = document.data()['grade'];
          studentDocumentId = document.id;
          print('student');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomePageScreen(
              gradeRef: gradeRef,
              studentDocumentId: studentDocumentId,
            );
          }));
        }
      } else if (document1.docs.isNotEmpty) {
        for (var document in document1.docs) {
          print(document.data()['classHead'][0]);
          gradeRef = document.data()['classHead'][0];
          teacherDocumentId = document.id;
          print('teacher');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return THomePageScree(
              gradeRef: gradeRef,
              teacherDocumentId: teacherDocumentId,
            );
          }));
        }
      } else if (document2.docs.isNotEmpty) {
        for (var document in document2.docs) {
          listOfAdministeredGrades = List.from(document.data()['principalOf']);
          String adminId = document.id;
          print(document.data()['email']);
          print(listOfAdministeredGrades);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AHomePage(
              listOfAdministeredGrades: listOfAdministeredGrades,
              adminId: adminId,
            );
          }));
        }
      } else if (document3.docs.isNotEmpty) {
        for (var document in document3.docs) {
          print(document.data()['email']);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AHomePage();
          }));
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
