import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../constants.dart';

class TeacherEditingScreen extends StatefulWidget {
  final String reference;

  TeacherEditingScreen({this.reference});

  @override
  _TeacherEditingScreenState createState() => _TeacherEditingScreenState();
}

class _TeacherEditingScreenState extends State<TeacherEditingScreen> {
  final _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String fName;
  String lName;
  String phoneNumber;
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection('teachers')
                .doc(widget.reference)
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
              if (document.isEmpty) {
                print('no data');
                return Text('No Data');
              }
              fName = document['fname'];
              lName = document['lname'];
              phoneNumber = document['phoneNumber'];
              return Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'First Name',
                            textAlign: TextAlign.right,
                            style:
                                KTextStyle.copyWith(color: Color(0xff171347)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: KBoxedContainer,
                            child: TextFormField(
                              onChanged: (value) {
                                fName = value;
                              },
                              keyboardType: TextInputType.text,
                              decoration: KTextFiledDecorationSecond.copyWith(
                                  hintText: document['fname']),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Last Name',
                            textAlign: TextAlign.right,
                            style:
                                KTextStyle.copyWith(color: Color(0xff171347)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: KBoxedContainer,
                            child: TextFormField(
                              onChanged: (value) {
                                lName = value;
                              },
                              keyboardType: TextInputType.text,
                              decoration: KTextFiledDecorationSecond.copyWith(
                                  hintText: document['lname']),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Phone Number',
                            textAlign: TextAlign.right,
                            style:
                                KTextStyle.copyWith(color: Color(0xff171347)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: KBoxedContainer,
                            child: TextFormField(
                              onChanged: (value) {
                                phoneNumber = value;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: KTextFiledDecorationSecond.copyWith(
                                  hintText: document['phoneNumber']),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Text(
                        'Success',
                        style: TextStyle(color: color),
                      ),
                      RaisedButton(
                        onPressed: () async {
                          if (fName == '' || fName == null) {
                            fName = document['fname'];
                          }
                          if (lName == '' || lName == null) {
                            lName = document['lname'];
                          }
                          if (phoneNumber == '' || phoneNumber == null) {
                            phoneNumber = document['phoneNumber'];
                          }
                          await _firestore
                              .collection('teachers')
                              .doc(widget.reference)
                              .update({
                            'fname': fName,
                            'lname': lName,
                            'phoneNumber': phoneNumber
                          });
                          setState(() {
                            color = Colors.green;
                          });
                        },
                        color: Colors.teal,
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
