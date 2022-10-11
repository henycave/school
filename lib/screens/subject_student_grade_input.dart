import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubjectStudentGradeInput extends StatefulWidget {
  final String studentId;
  final String subject;
  final String subjectName;
  final String gradeReference;

  SubjectStudentGradeInput(
      {this.studentId, this.subject, this.subjectName, this.gradeReference});

  @override
  _SubjectStudentGradeInputState createState() =>
      _SubjectStudentGradeInputState();
}

class _SubjectStudentGradeInputState extends State<SubjectStudentGradeInput> {
  final _firestore = FirebaseFirestore.instance;
  String resultId;
  String firstForty;
  String firstSixty;
  String secondForty;
  String secondSixty;
  String thirdForty;
  String thirdSixty;
  String fourthForty;
  String fourthSixty;
  Color firstSuccessSubmitColor = Colors.white;
  Color firstFailedSubmitColor = Colors.white;
  Color secondSuccessSubmitColor = Colors.white;
  Color secondFailedSubmitColor = Colors.white;
  Color thirdSuccessSubmitColor = Colors.white;
  Color thirdFailedSubmitColor = Colors.white;
  Color fourthSuccessSubmitColor = Colors.white;
  Color fourthFailedSubmitColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    bool checkInput(String sixty, String forty) {
      if (forty == null && sixty == null) {
        return true;
      } else if (double.tryParse(sixty) == null ||
          double.tryParse(forty) == null) {
        return true;
      } else if (double.tryParse(sixty) > 60 || double.tryParse(sixty) < 0) {
        return true;
      } else if (double.tryParse(forty) > 40 || double.tryParse(forty) < 0) {
        return true;
      } else
        return false;
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.teal,
            child: SafeArea(
              child: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: 'First Quarter',
                  ),
                  Tab(
                    text: 'Second Quarter',
                  ),
                  Tab(
                    text: 'Third Quarter',
                  ),
                  Tab(
                    text: 'Fourth Quarter',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(children: [
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('result')
                  .where('student', isEqualTo: widget.studentId)
                  .where('subject', isEqualTo: widget.subject)
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
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '40: ',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  firstForty = value;
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Text(
                              '60: ',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  firstSixty = value;
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        RaisedButton(
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.teal,
                          onPressed: () async {
                            if (firstForty != null && firstSixty == null) {
                              firstSixty = '0';
                            } else if (firstForty == null &&
                                firstSixty != null) {
                              firstForty = '0';
                            }
                            if (checkInput(firstSixty, firstForty)) {
                              setState(() {
                                firstFailedSubmitColor = Colors.redAccent;
                                firstSuccessSubmitColor = Colors.white;
                              });
                              return;
                            }
                            print(firstSixty);
                            print(firstForty);
                            await _firestore.collection('result').add({
                              'firstQuar': {
                                '40': firstForty,
                                '60': firstSixty,
                              },
                              'student': widget.studentId,
                              'subject': widget.subject,
                              'subjectName': widget.subjectName,
                            });
                            print(widget.gradeReference);
                            await _firestore
                                .collection('Grade')
                                .doc(widget.gradeReference)
                                .collection('operation logger')
                                .add({
                              'type': 'grade input',
                              'subject': widget.subjectName,
                              'date': DateTime.now(),
                            });
                            setState(() {
                              firstSuccessSubmitColor = Colors.teal;
                              firstFailedSubmitColor = Colors.white;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Align(
                              child: Text(
                                'success',
                                style:
                                    TextStyle(color: firstSuccessSubmitColor),
                              ),
                              alignment: Alignment.topRight,
                            ),
                            Align(
                              child: Text(
                                'failed',
                                style: TextStyle(color: firstFailedSubmitColor),
                              ),
                              alignment: Alignment.topRight,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                List<Map<String, String>> firstQuar = [];
                for (var document in documents) {
                  firstQuar.add({'40': document.data()['firstQuar']['40']});
                  firstQuar.add({'60': document.data()['firstQuar']['60']});
                  resultId = document.id;
                }
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '40: ',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                firstForty = value;
                              },
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20),
                                hintText: firstQuar[0]['40'].toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Text(
                            '60: ',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                firstSixty = value;
                              },
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20),
                                hintText: firstQuar[1]['60'].toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      RaisedButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.teal,
                        onPressed: () async {
                          if (firstForty != null && firstSixty == null) {
                            firstSixty = firstQuar[1]['60'].toString();
                          } else if (firstForty == null && firstSixty != null) {
                            firstForty = firstQuar[0]['40'].toString();
                          }
                          if (checkInput(firstSixty, firstForty)) {
                            setState(() {
                              firstFailedSubmitColor = Colors.redAccent;
                              firstSuccessSubmitColor = Colors.white;
                            });
                            return;
                          }
                          print(firstSixty);
                          print(firstForty);
                          await _firestore
                              .collection('result')
                              .doc(resultId)
                              .update({
                            'firstQuar': {
                              '40': firstForty,
                              '60': firstSixty,
                            },
                          });
                          await _firestore
                              .collection('Grade')
                              .doc(widget.gradeReference)
                              .collection('operation logger')
                              .add({
                            'type': 'grade input',
                            'subject': widget.subjectName,
                            'date': DateTime.now(),
                          });
                          setState(() {
                            firstSuccessSubmitColor = Colors.teal;
                            firstFailedSubmitColor = Colors.white;
                            firstQuar[0]['40'] = firstForty;
                            firstQuar[1]['60'] = firstSixty;
                          });
                        },
                      ),
                      Row(
                        children: [
                          Align(
                            child: Text(
                              'success',
                              style: TextStyle(color: firstSuccessSubmitColor),
                            ),
                            alignment: Alignment.topRight,
                          ),
                          Align(
                            child: Text(
                              'failed',
                              style: TextStyle(color: firstFailedSubmitColor),
                            ),
                            alignment: Alignment.topRight,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('result')
                  .where('student', isEqualTo: widget.studentId)
                  .where('subject', isEqualTo: widget.subject)
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
                  return Text('No Data');
                }
                List<Map<String, String>> secondQuar = [];
                for (var document in documents) {
                  if (document.data()['secondQuar'] == null) {
                    secondQuar.add({'40': '0'});
                    secondQuar.add({'60': '0'});
                    resultId = document.id;
                  } else {
                    secondQuar.add(
                        {'40': document.data()['secondQuar']['40'].toString()});
                    secondQuar.add(
                        {'60': document.data()['secondQuar']['60'].toString()});
                    resultId = document.id;
                  }
                }
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '40: ',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                secondForty = value;
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20),
                                hintText: secondQuar[0]['40'].toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Text(
                            '60: ',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                            height: 1,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                secondSixty = value;
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20),
                                hintText: secondQuar[1]['60'].toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      RaisedButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.teal,
                        onPressed: () async {
                          if (secondForty != null && secondSixty == null) {
                            secondSixty = secondQuar[1]['60'];
                          } else if (secondForty == null &&
                              secondSixty != null) {
                            secondForty = secondQuar[0]['40'];
                          }
                          if (checkInput(secondSixty, secondForty)) {
                            setState(() {
                              secondFailedSubmitColor = Colors.redAccent;
                              secondSuccessSubmitColor = Colors.white;
                            });
                            return;
                          }
                          await _firestore
                              .collection('result')
                              .doc(resultId)
                              .set(
                            {
                              'secondQuar': {
                                '40': secondForty,
                                '60': secondSixty
                              }
                            },
                            SetOptions(merge: true),
                          );
                          await _firestore
                              .collection('Grade')
                              .doc(widget.gradeReference)
                              .collection('operation logger')
                              .add({
                            'type': 'grade input',
                            'subject': widget.subjectName,
                            'date': DateTime.now(),
                          });
                          setState(() {
                            secondSuccessSubmitColor = Colors.teal;
                            secondFailedSubmitColor = Colors.white;
                          });
                        },
                      ),
                      Row(
                        children: [
                          Align(
                            child: Text(
                              'success',
                              style: TextStyle(color: secondSuccessSubmitColor),
                            ),
                            alignment: Alignment.topRight,
                          ),
                          Align(
                            child: Text(
                              'failed',
                              style: TextStyle(color: secondFailedSubmitColor),
                            ),
                            alignment: Alignment.topRight,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('result')
                  .where('student', isEqualTo: widget.studentId)
                  .where('subject', isEqualTo: widget.subject)
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
                  return Text('No Data');
                }
                List<Map<String, String>> thirdQuar = [];
                for (var document in documents) {
                  if (document.data()['thirdQuar'] == null) {
                    thirdQuar.add({'40': '0'});
                    thirdQuar.add({'60': '0'});
                    resultId = document.id;
                  } else {
                    thirdQuar.add(
                        {'40': document.data()['thirdQuar']['40'].toString()});
                    thirdQuar.add(
                        {'60': document.data()['thirdQuar']['60'].toString()});
                    resultId = document.id;
                  }
                }
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '40: ',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                thirdForty = value;
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20),
                                hintText: thirdQuar[0]['40'].toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Text(
                            '60: ',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                            height: 1,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                thirdSixty = value;
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20),
                                hintText: thirdQuar[1]['60'].toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      RaisedButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.teal,
                        onPressed: () async {
                          if (thirdForty != null && thirdSixty == null) {
                            thirdSixty = thirdQuar[1]['60'];
                          } else if (thirdForty == null && thirdSixty != null) {
                            thirdForty = thirdQuar[0]['40'];
                          }
                          if (checkInput(thirdSixty, thirdForty)) {
                            setState(() {
                              thirdFailedSubmitColor = Colors.redAccent;
                              thirdSuccessSubmitColor = Colors.white;
                            });
                            return;
                          }
                          await _firestore
                              .collection('result')
                              .doc(resultId)
                              .set(
                            {
                              'thirdQuar': {'40': thirdForty, '60': thirdSixty}
                            },
                            SetOptions(merge: true),
                          );
                          await _firestore
                              .collection('Grade')
                              .doc(widget.gradeReference)
                              .collection('operation logger')
                              .add({
                            'type': 'grade input',
                            'subject': widget.subjectName,
                            'date': DateTime.now(),
                          });
                          setState(() {
                            thirdSuccessSubmitColor = Colors.teal;
                            thirdFailedSubmitColor = Colors.white;
                          });
                        },
                      ),
                      Row(
                        children: [
                          Align(
                            child: Text(
                              'success',
                              style: TextStyle(color: thirdSuccessSubmitColor),
                            ),
                            alignment: Alignment.topRight,
                          ),
                          Align(
                            child: Text(
                              'failed',
                              style: TextStyle(color: thirdFailedSubmitColor),
                            ),
                            alignment: Alignment.topRight,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('result')
                  .where('student', isEqualTo: widget.studentId)
                  .where('subject', isEqualTo: widget.subject)
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
                  return Text('No Data');
                }
                List<Map<String, String>> fourthQuar = [];
                for (var document in documents) {
                  if (document.data()['fourthQuar'] == null) {
                    fourthQuar.add({'40': '0'});
                    fourthQuar.add({'60': '0'});
                    resultId = document.id;
                  } else {
                    fourthQuar.add(
                        {'40': document.data()['fourthQuar']['40'].toString()});
                    fourthQuar.add(
                        {'60': document.data()['fourthQuar']['60'].toString()});
                    resultId = document.id;
                  }
                }
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '40: ',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                fourthForty = value;
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20),
                                hintText: fourthQuar[0]['40'].toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Text(
                            '60: ',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                            height: 1,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                fourthSixty = value;
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20),
                                hintText: fourthQuar[1]['60'].toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      RaisedButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.teal,
                        onPressed: () async {
                          if (fourthForty != null && fourthSixty == null) {
                            fourthSixty = fourthQuar[1]['60'];
                          } else if (fourthForty == null &&
                              fourthSixty != null) {
                            fourthForty = fourthQuar[0]['40'];
                          }
                          if (checkInput(fourthSixty, fourthForty)) {
                            setState(() {
                              fourthFailedSubmitColor = Colors.redAccent;
                              fourthSuccessSubmitColor = Colors.white;
                            });
                            return;
                          }
                          await _firestore
                              .collection('result')
                              .doc(resultId)
                              .set(
                            {
                              'fourthQuar': {
                                '40': fourthForty,
                                '60': fourthSixty
                              }
                            },
                            SetOptions(merge: true),
                          );
                          await _firestore
                              .collection('Grade')
                              .doc(widget.gradeReference)
                              .collection('operation logger')
                              .add({
                            'type': 'grade input',
                            'subject': widget.subjectName,
                            'date': DateTime.now(),
                          });
                          setState(() {
                            fourthSuccessSubmitColor = Colors.teal;
                            fourthFailedSubmitColor = Colors.white;
                          });
                        },
                      ),
                      Row(
                        children: [
                          Align(
                            child: Text(
                              'success',
                              style: TextStyle(color: fourthSuccessSubmitColor),
                            ),
                            alignment: Alignment.topRight,
                          ),
                          Align(
                            child: Text(
                              'failed',
                              style: TextStyle(color: fourthFailedSubmitColor),
                            ),
                            alignment: Alignment.topRight,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
