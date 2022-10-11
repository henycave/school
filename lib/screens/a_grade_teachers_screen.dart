import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school/screens/head_teacher_operations_screen.dart';
import 'package:school/screens/teacher_editing_screen.dart';

class AGradeTeacherScreen extends StatefulWidget {
  final String gradeRef;
  final String headTeacher;
  AGradeTeacherScreen({this.gradeRef, this.headTeacher});
  @override
  _AGradeTeacherScreenState createState() => _AGradeTeacherScreenState();
}

class _AGradeTeacherScreenState extends State<AGradeTeacherScreen> {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: _firestore
              .collection('subjects')
              .where('gradeSection', isEqualTo: widget.gradeRef)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlue,
                ),
              );
            }
            final documentOne = snapshot.data.docs;
            if (documentOne.isEmpty) {
              print('no data');
              return Text('No Data');
            }
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('teachers')
                  .where('teachingGrades', arrayContains: widget.gradeRef)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlue,
                    ),
                  );
                }
                final documentTwo = snapshot.data.docs;
                if (documentTwo.isEmpty) {
                  print('no data');
                  return Text('No Data');
                }
                List<ListTile> teacherContainers = [];
                for (var documentOneOne in documentOne) {
                  String subjectName = documentOneOne.data()['subjectName'];
                  String teacherName;
                  String teacherReference;
                  bool isHeadTeacher = false;
                  //String phoneNumber;
                  for (var documentTwoTwo in documentTwo) {
                    if (documentOneOne.data()['teacher'].toString() ==
                        documentTwoTwo.id.toString()) {
                      if (documentTwoTwo.id == widget.headTeacher) {
                        isHeadTeacher = true;
                      }
                      teacherName = documentTwoTwo.data()['fname'] +
                          ' ' +
                          documentTwoTwo.data()['lname'];
                      teacherReference = documentTwoTwo.id;
                      //phoneNumber = documentTwoTwo.data()['phoneNumber'];
                    }
                  }
                  teacherContainers.add(ListTile(
                    leading: isHeadTeacher
                        ? Icon(
                            Icons.grade,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.person_pin,
                            color: Colors.white,
                          ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.white,
                    ),
                    title: Text(
                      teacherName,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      subjectName,
                      style: TextStyle(color: Colors.white),
                    ),
                    tileColor: Colors.teal,
                    onTap: () {
                      isHeadTeacher
                          ? headOnTap()
                          : notHeadOnTap(teacherReference);
                    },
                  ));
                }
                return ListView.separated(
                  padding: EdgeInsets.all(6),
                  itemBuilder: (context, index) {
                    return teacherContainers.elementAt(index);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: 3,
                    color: Colors.teal,
                  ),
                  itemCount: teacherContainers.length,
                );
              },
            );
          },
        ),
      ),
    );
  }

  headOnTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HeadTeacherOperationsScreen(
                  headTeacherReference: widget.headTeacher,
                  gradeReference: widget.gradeRef,
                )));
  }

  notHeadOnTap(String reference) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TeacherEditingScreen(
                  reference: reference,
                )));
  }
}
