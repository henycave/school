import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class NotificationEditingScreen extends StatefulWidget {
  final String notificationId;
  final String gradeRef;

  NotificationEditingScreen({this.notificationId, this.gradeRef});

  @override
  _NotificationEditingScreenState createState() =>
      _NotificationEditingScreenState();
}

class _NotificationEditingScreenState extends State<NotificationEditingScreen> {
  final _firestore = FirebaseFirestore.instance;
  String type;
  String subject;
  DateTime beforeDate;
  DateTime pickedDate;
  Color successColor = Colors.white;
  Color failedColor = Colors.white;
  selectDate(context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: beforeDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != beforeDate) {
      setState(() {
        pickedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _firestore
              .collection('Grade')
              .doc(widget.gradeRef)
              .collection('notifications')
              .doc(widget.notificationId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlue,
                ),
              );
            }
            final document = snapshot.data.data();
            if (document == null) {
              print('no data');
              return Text('No Data');
            } else if (document.isEmpty) {
              print('no data');
              return Text('No Data');
            }
            type = document['type'];
            subject = document['subject'];
            beforeDate = document['date'].toDate();
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                  .copyWith(bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type',
                        style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                      ),
                      TextField(
                        onChanged: (value) {
                          type = value;
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFiledDecoration.copyWith(
                            hintText: document['type']),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Subject',
                        style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                      ),
                      TextField(
                        onChanged: (value) {
                          subject = value;
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFiledDecoration.copyWith(
                            hintText: document['subject']),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          RaisedButton(
                            onPressed: () => selectDate(context),
                            child: Text(
                              'pick a date',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.teal,
                          ),
                          Text('Failed', style: TextStyle(color: failedColor)),
                          Text(
                            'Successful',
                            style: TextStyle(color: successColor),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        onPressed: () async {
                          await _firestore
                              .collection('Grade')
                              .doc(widget.gradeRef)
                              .collection('notifications')
                              .doc(widget.notificationId)
                              .delete();
                          Navigator.pop(context);
                        },
                        child: Text('Delete'),
                        color: Colors.redAccent,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          print(beforeDate);
                          try {
                            await _firestore
                                .collection('Grade')
                                .doc(widget.gradeRef)
                                .collection('notifications')
                                .doc(widget.notificationId)
                                .update({
                              'type': type,
                              'subject': subject,
                              'date':
                                  pickedDate == null ? beforeDate : pickedDate,
                            });
                          } catch (e) {
                            setState(() {
                              failedColor = Colors.redAccent;
                            });
                            print(e);
                          }
                          setState(() {
                            successColor = Colors.green;
                          });
                        },
                        child: Text('Save'),
                        color: Colors.green,
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
