import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:school/components/reusable_card.dart';
import 'package:school/screens/school_screen.dart';
import 'package:school/screens/subject_screen.dart';
import 'package:school/screens/t_attendance_input_screen.dart';
import 'package:school/screens/t_grade_screen.dart';
import 'package:school/screens/t_profile_Screen.dart';

import 'classes.dart';

class THomePageScree extends StatefulWidget {
  static const String id = 't_home_page_screen';
  final String gradeRef;
  final String teacherDocumentId;
  THomePageScree({this.gradeRef, this.teacherDocumentId});
  @override
  _THomePageScreeState createState() => _THomePageScreeState();
}

class _THomePageScreeState extends State<THomePageScree> {
  final _firestore = FirebaseFirestore.instance;
  QuerySnapshot attendanceList;
  bool showSpinner = false;
  getDocuments() async {
    final attendance = await _firestore
        .collection('students')
        .where('grade', isEqualTo: widget.gradeRef)
        .get();
    attendanceList = attendance;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15).copyWith(top: 10),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TProfileScreen(
                                      teacherDocumentId:
                                          widget.teacherDocumentId,
                                      gradeRef: widget.gradeRef,
                                    )));
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.all(3.0).copyWith(right: 20),
                          child: CircleAvatar(
                            radius: 25.0,
                            backgroundImage:
                                AssetImage('images/polar-bear.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ReusableCard(
                            color: Color(0xFFF5D65E),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubjectScreen(
                                            gradeRef: widget.gradeRef,
                                          )));
                            },
                            image: Image.asset('images/books.png'),
                            title: 'SUBJECTS',
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            color: Color(0xFF9398F8),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TGradeScreen(
                                            gradeRef: widget.gradeRef,
                                          )));
                            },
                            image: Image.asset('images/grades.png'),
                            title: 'GRADES',
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ReusableCard(
                            color: Color(0xFF68BB9A),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Classes(
                                            gradeRef: widget.gradeRef,
                                          )));
                            },
                            image: Image.asset('images/schedule.png'),
                            title: 'NOTIFY',
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            color: Color(0xFFFFC493),
                            onTap: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                await getDocuments();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TAttendanceInputScreen(
                                              gradeRef: widget.gradeRef,
                                              attendanceList: attendanceList,
                                            )));
                              } catch (e) {
                                setState(() {
                                  showSpinner = false;
                                });
                                print(e);
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            },
                            image: Image.asset('images/attendance.png'),
                            title: 'ATTENDANCE',
                            textSize: 26.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ReusableCard(
                            color: Color(0xFFFF8061),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SchoolScreen()));
                            },
                            image: Hero(
                              child: Image.asset('images/school.png'),
                              tag: 'school',
                            ),
                            title: 'SCHOOL',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
