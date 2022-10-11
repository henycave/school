import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  final String studentRef;
  final String gradeRef;
  ProfileScreen({this.studentRef, this.gradeRef});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection('students')
                .doc(widget.studentRef)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlue,
                  ),
                );
              }
              final documentOne = snapshot.data.data();
              if (documentOne.isEmpty) {
                print('no data');
                return Text('No Data');
              }
              return StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('Grade')
                      .doc(widget.gradeRef)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlue,
                        ),
                      );
                    }
                    final documentTwo = snapshot.data.data();
                    if (documentTwo.isEmpty) {
                      print('no data');
                      return Text('No Data');
                    }

                    String name =
                        documentOne['fname'] + ' ' + documentOne['lname'];
                    String email = documentOne['email'];
                    String grade =
                        documentTwo['grade'] + documentTwo['sectionName'];

                    return Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: RaisedButton(
                                elevation: 15,
                                child: Text(
                                  'Log out',
                                  style: TextStyle(
                                    color: Colors.teal.shade900,
                                    fontSize: 15,
                                  ),
                                ),
                                color: Colors.white,
                                onPressed: () async {
                                  await _auth.signOut();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: AssetImage('images/user.jpg'),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: 'Pacifico',
                            fontSize: 40.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'STUDENT',
                          style: TextStyle(
                            fontFamily: 'Source Sans Pro',
                            color: Colors.teal.shade100,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.5,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: 150,
                          child: Divider(
                            color: Colors.teal.shade100,
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 25.0),
                          child: ListTile(
                            leading: Icon(
                              Icons.grade,
                              color: Colors.teal,
                            ),
                            title: Text(
                              'Grade $grade',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.teal.shade900,
                                fontFamily: 'Source Sans Pro',
                              ),
                            ),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 25.0),
                          child: ListTile(
                            leading: Icon(
                              Icons.email,
                              color: Colors.teal,
                            ),
                            title: Text(
                              email,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.teal.shade900,
                                fontFamily: 'Source Sans Pro',
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            }),
      ),
    );
  }
}
