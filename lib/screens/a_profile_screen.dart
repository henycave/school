import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class AProfileScreen extends StatefulWidget {
  final String adminId;

  AProfileScreen({this.adminId});

  @override
  _AProfileScreenState createState() => _AProfileScreenState();
}

class _AProfileScreenState extends State<AProfileScreen> {
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print(widget.adminId);
    return Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
          stream: _firestore
              .collection('principal')
              .doc(widget.adminId)
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
            String name = document['fname'] + ' ' + document['lname'];
            String headOf = document['headOf'];
            String email = document['email'];
            return Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                  'PRINCIPAL',
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
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.grade,
                      color: Colors.teal,
                    ),
                    title: Text(
                      'Head Of  $headOf',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.teal.shade900,
                        fontFamily: 'Source Sans Pro',
                      ),
                    ),
                  ),
                ),
                Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
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
          },
        )));
  }
}
