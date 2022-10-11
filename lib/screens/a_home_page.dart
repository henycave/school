import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school/screens/a_grade_teachers_screen.dart';
import 'a_profile_screen.dart';

class AHomePage extends StatefulWidget {
  final List<String> listOfAdministeredGrades;
  final String adminId;

  AHomePage({this.listOfAdministeredGrades, this.adminId});

  @override
  _AHomePageState createState() => _AHomePageState();
}

class _AHomePageState extends State<AHomePage> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('Grade').orderBy('grade').snapshots(),
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
              List<ListTile> gradeContainers = [];
              for (var document in documents) {
                if (widget.listOfAdministeredGrades
                    .contains(document.id.toString())) {
                  String gradeName = document.data()['grade'] +
                      '' +
                      document.data()['sectionName'];
                  String headTeacher =
                      document.data()['headTeacher'].toString();
                  String gradeRef = document.id.toString();
                  gradeContainers.add(
                    ListTile(
                      tileColor: Colors.lightBlue.shade300,
                      title: Text(
                        gradeName,
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.grade,
                        color: Colors.white,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AGradeTeacherScreen(
                                      gradeRef: gradeRef,
                                      headTeacher: headTeacher,
                                    )));
                      },
                    ),
                  );
                }
              }
              return Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AProfileScreen(
                                      adminId: widget.adminId,
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0).copyWith(right: 20),
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: AssetImage('images/polar-bear.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.all(6),
                        itemBuilder: (context, index) {
                          return gradeContainers.elementAt(index);
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              height: 3,
                              color: Colors.teal,
                            ),
                        itemCount: gradeContainers.length),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
