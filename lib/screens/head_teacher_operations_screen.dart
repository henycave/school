import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school/components/notification_card.dart';
import 'package:school/screens/teacher_editing_screen.dart';

class HeadTeacherOperationsScreen extends StatefulWidget {
  final String headTeacherReference;
  final String gradeReference;

  HeadTeacherOperationsScreen({this.headTeacherReference, this.gradeReference});

  @override
  _HeadTeacherOperationsScreenState createState() =>
      _HeadTeacherOperationsScreenState();
}

class _HeadTeacherOperationsScreenState
    extends State<HeadTeacherOperationsScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherEditingScreen(
                                  reference: widget.headTeacherReference,
                                )));
                  },
                  child: Text(
                    'Edit Head Teacher',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.teal,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Grade')
                    .doc(widget.gradeReference)
                    .collection('operation logger')
                    .where('date',
                        isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day))
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
                    var title, subject, localDate, color;
                    final iconData = Icon(Icons.notifications);
                    if (document.data()['type'] == 'grade input') {
                      title = document.data()['type'];
                      subject = document.data()['subject'];
                      Timestamp date = document.data()['date'];
                      color = Color(0xFFF5D65E).withOpacity(0.5);
                      localDate = DateFormat.yMMMd()
                          .add_jm()
                          .format(date.toDate())
                          .toString();
                    } else if (document.data()['type'] == 'Notification') {
                      title = document.data()['type'];
                      subject = '';
                      Timestamp date = document.data()['date'];
                      color = Color(0xFFF5D65E).withOpacity(0.5);
                      localDate = DateFormat.yMMMd()
                          .add_jm()
                          .format(date.toDate())
                          .toString();
                    } else if (document.data()['type'] == 'Attendance') {
                      title = document.data()['type'];
                      subject = '';
                      Timestamp date = document.data()['date'];
                      color = Color(0xFFF5D65E).withOpacity(0.5);
                      localDate = DateFormat.yMMMd()
                          .add_jm()
                          .format(date.toDate())
                          .toString();
                    } else {
                      title = '';
                      subject = '';
                      localDate = DateTime.now();
                      color = Colors.orange;
                    }
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
            ],
          ),
        ),
      ),
    );
  }
}
