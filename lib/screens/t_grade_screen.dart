import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school/components/reusable_subject_choice_card.dart';
import 'package:school/screens/grade_input_screen.dart';

class TGradeScreen extends StatefulWidget {
  final String gradeRef;
  final String teacherDocumentId;
  TGradeScreen({this.teacherDocumentId, this.gradeRef});
  @override
  _TGradeScreenState createState() => _TGradeScreenState();
}

class _TGradeScreenState extends State<TGradeScreen> {
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
              List<ReusableSubjectChoiceCard> teacherContainers = [];
              for (var documentOneOne in documentOne) {
                String subjectName = documentOneOne.data()['subjectName'];
                teacherContainers.add(
                  ReusableSubjectChoiceCard(
                    subjectName: subjectName,
                    color: Colors.teal.shade100,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GradeInputScreen(
                                    gradeRef: widget.gradeRef,
                                    subjectId: documentOneOne.id,
                                    subjectName: subjectName,
                                  )));
                    },
                  ),
                );
              }
              return ListView(
                children: teacherContainers,
              );
            },
          ),
        ),
      ),
    );
  }
}
