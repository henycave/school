import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school/screens/subject_student_grade_input.dart';

class GradeInputScreen extends StatefulWidget {
  final String gradeRef;
  final String subjectId;
  final String subjectName;

  GradeInputScreen({this.gradeRef, this.subjectId, this.subjectName});

  @override
  _GradeInputScreenState createState() => _GradeInputScreenState();
}

class _GradeInputScreenState extends State<GradeInputScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10).copyWith(top: 25),
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('students')
                .where('grade', isEqualTo: widget.gradeRef)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlue,
                  ),
                );
              }
              final documents = snapshot.data.docs;
              if (documents.isEmpty) {
                print('no data');
                return Text('No Data');
              }
              List<ListTile> studentTiles = [];
              for (var document in documents) {
                String studentName =
                    document.data()['fname'] + ' ' + document.data()['lname'];
                studentTiles.add(ListTile(
                  shape: CircleBorder(),
                  leading: Icon(
                    Icons.person_pin,
                    color: Colors.white,
                  ),
                  title: Text(
                    studentName,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                  tileColor: Colors.teal,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubjectStudentGradeInput(
                                  gradeReference: widget.gradeRef,
                                  studentId: document.id,
                                  subject: widget.subjectId,
                                  subjectName: widget.subjectName,
                                )));
                  },
                ));
              }
              return ListView(children: studentTiles);
            },
          ),
        ),
      ),
    );
  }
}
