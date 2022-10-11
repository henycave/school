import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school/components/notification_card.dart';
import 'package:school/screens/notification_editing_screen.dart';

import 'add_notification_screen.dart';

class Classes extends StatefulWidget {
  final gradeRef;

  Classes({this.gradeRef});

  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Align(
                alignment: Alignment.topRight,
                child: RaisedButton(
                  color: Colors.amber,
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => AddNotificationScreen(
                              gradeRef: widget.gradeRef,
                            ));
                  },
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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
                    print('no data');
                    return ListView(
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationEditingScreen(
                                      notificationId: document.id,
                                      gradeRef: widget.gradeRef,
                                    )));
                      },
                    );
                    notifications.add(notificationWidget);
                    notifications.add(
                      SizedBox(
                        height: 15,
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(15),
                          children: notifications,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
