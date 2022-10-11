import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school/components/reusable_subject_card.dart';

class SubjectScreen extends StatefulWidget {
  static const String id = 'subject_screen';
  final String gradeRef;

  SubjectScreen({this.gradeRef});

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
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
                  List<ReusableSubjectCard> teacherContainers = [];
                  for (var documentOneOne in documentOne) {
                    String subjectName = documentOneOne.data()['subjectName'];
                    String teacherName;
                    String phoneNumber;
                    for (var documentTwoTwo in documentTwo) {
                      if (documentOneOne.data()['teacher'].toString() ==
                          documentTwoTwo.id.toString()) {
                        teacherName = documentTwoTwo.data()['fname'] +
                            documentTwoTwo.data()['lname'];
                        phoneNumber = documentTwoTwo.data()['phoneNumber'];
                      }
                    }
                    teacherContainers.add(
                      ReusableSubjectCard(
                        subjectName: subjectName,
                        teacherName: teacherName,
                        phoneNumber: phoneNumber,
                        color: Color(0xFFF5D65E),
                      ),
                    );
                  }
                  return ListView(
                    children: teacherContainers,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
