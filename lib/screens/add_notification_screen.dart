import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class AddNotificationScreen extends StatefulWidget {
  final String gradeRef;
  AddNotificationScreen({this.gradeRef});
  @override
  _AddNotificationScreenState createState() => _AddNotificationScreenState();
}

class _AddNotificationScreenState extends State<AddNotificationScreen> {
  String type;
  String subject;
  DateTime pickedDate;
  Color successColor = Colors.white;
  Color failedColor = Colors.white;
  final _firestore = FirebaseFirestore.instance;

  selectDate(context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        pickedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                    decoration: kTextFiledDecoration.copyWith(hintText: ''),
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
                    decoration: kTextFiledDecoration.copyWith(hintText: ''),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Align(
                alignment: Alignment.topRight,
                child: RaisedButton(
                  onPressed: () async {
                    if (pickedDate == null) {
                      print(pickedDate);
                      setState(() {
                        failedColor = Colors.redAccent;
                        Navigator.pop(context);
                      });
                    } else {
                      try {
                        await _firestore
                            .collection('Grade')
                            .doc(widget.gradeRef)
                            .collection('notifications')
                            .add({
                          'type': type,
                          'subject': subject,
                          'date': pickedDate,
                        });
                        await _firestore
                            .collection('Grade')
                            .doc(widget.gradeRef)
                            .collection('operation logger')
                            .add({
                          'type': 'Notification',
                          'date': DateTime.now(),
                        });
                        Navigator.pop(context);
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Text('Save'),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
