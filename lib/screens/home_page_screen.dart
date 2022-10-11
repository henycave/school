import 'package:flutter/material.dart';
import 'package:school/screens/attendance_screen.dart';
import 'package:school/screens/grade_screen.dart';
import 'package:school/screens/profile_screen.dart';
import 'package:school/screens/schedule_screen.dart';
import 'package:school/screens/school_screen.dart';
import 'package:school/screens/subject_screen.dart';
import '../components/reusable_card.dart';
import '../components/notification_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomePageScreen extends StatefulWidget {
  static const String id = 'home_page_screen';
  final String gradeRef;
  final String studentDocumentId;

  HomePageScreen({this.gradeRef, this.studentDocumentId});

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0).copyWith(left: 20),
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                    studentRef: widget.studentDocumentId,
                                    gradeRef: widget.gradeRef,
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
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Grade')
                    .doc(widget.gradeRef)
                    .collection('notifications')
                    .where('date', isGreaterThan: DateTime.now())
                    .orderBy('date')
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
                    return Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(15),
                        children: <Widget>[
                          Image.asset(
                            'images/happy.png',
                            height: 100,
                          ),
                          Center(
                            child: Text(
                              'No Notifications',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final List<Widget> notifications = [];
                  for (var document in documents) {
                    final iconData = Icon(Icons.donut_small);
                    final title = document.data()['type'];
                    final subject = document.data()['subject'];
                    final Timestamp date = document.data()['date'];
                    final color = Color(0xFFF5D65E).withOpacity(0.5);
                    String localDate = DateFormat.yMMMd()
                        .add_jm()
                        .format(date.toDate())
                        .toString();
                    final notificationWidget = NotificationCard(
                      iconData: iconData,
                      title: title,
                      submitDate: localDate,
                      subject: subject,
                      color: color,
                    );
                    notifications.add(notificationWidget);
                    notifications.add(
                      SizedBox(
                        height: 15,
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(15),
                      children: notifications,
                    ),
                  );
                },
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
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
                                        builder: (context) => GradeScreen(
                                              studentDocumentId:
                                                  widget.studentDocumentId,
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
                                        builder: (context) =>
                                            ScheduleScreen()));
                              },
                              image: Image.asset('images/schedule.png'),
                              title: 'SCHEDULE',
                            ),
                          ),
                          Expanded(
                            child: ReusableCard(
                              color: Color(0xFFFFC493),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AttendanceScreen(
                                              studentRef:
                                                  widget.studentDocumentId,
                                            )));
                              },
                              image: Image.asset('images/attendance.png'),
                              title: 'ATTENDANCE',
                              textSize: 23.0,
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
            ],
          ),
        ),
      ),
    );
  }
}
