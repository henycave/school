import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TAttendanceInputScreen extends StatefulWidget {
  final String gradeRef;
  final QuerySnapshot attendanceList;

  TAttendanceInputScreen({this.gradeRef, this.attendanceList});

  @override
  _TAttendanceInputScreenState createState() => _TAttendanceInputScreenState();
}

class _TAttendanceInputScreenState extends State<TAttendanceInputScreen> {
  final _firestore = FirebaseFirestore.instance;
  final Map<String, bool> stateOfAttendance = {};
  bool isChecked = true;

  getDocuments(QuerySnapshot attendance) {
    for (var document in attendance.docs) {
      stateOfAttendance[document.id] = true;
    }
  }

  @override
  void initState() {
    getDocuments(widget.attendanceList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: stateOfAttendance.keys.map((String key) {
                  String studentName;
                  for (var document in widget.attendanceList.docs) {
                    if (key.toString() == document.id.toString()) {
                      studentName = document['fname'] + ' ' + document['lname'];
                    }
                  }
                  return Container(
                    color: Colors.teal,
                    child: CheckboxListTile(
                      title: Text(
                        studentName,
                        style: TextStyle(color: Colors.white),
                      ),
                      value: stateOfAttendance[key],
                      secondary: Icon(
                        Icons.person_pin,
                        color: Colors.white,
                      ),
                      onChanged: (bool value) {
                        setState(() {
                          stateOfAttendance[key] = value;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),

              // child: ListView.builder(
              //     itemCount: widget.attendanceList.docs.length,
              //     itemBuilder: (context, index) {
              //       String studentName =
              //           widget.attendanceList.docs.elementAt(index)['fname'] +
              //               ' ' +
              //               widget.attendanceList.docs.elementAt(index)['lname'];
              //       return ListTile(
              //         shape: CircleBorder(),
              //         leading: Icon(
              //           Icons.person_pin,
              //           color: Colors.white,
              //         ),
              //         title: Text(
              //           studentName,
              //           style: TextStyle(
              //             color: Colors.white,
              //           ),
              //         ),
              //         trailing: Checkbox(
              //           value: isChecked,
              //           onChanged: (value) {
              //             stateOfAttendance[widget.attendanceList.docs
              //                 .elementAt(index)
              //                 .id] = value;
              //             setState(() {
              //               isChecked = value;
              //             });
              //             print(stateOfAttendance[
              //                 widget.attendanceList.docs.elementAt(index).id]);
              //             print(widget.attendanceList.docs.elementAt(index).id);
              //             print(stateOfAttendance);
              //           },
              //         ),
              //         tileColor: Colors.teal,
              //       );
              //     }),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.topRight,
                child: RaisedButton(
                  child: Text('Submit'),
                  color: Colors.orange.shade500,
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    DateTime date = DateTime(now.year, now.month, now.day);
                    print(stateOfAttendance);
                    for (var key in stateOfAttendance.keys) {
                      // print(stateOfAttendance[key]);
                      // print(key);
                      await _firestore
                          .collection('students')
                          .doc(key)
                          .collection('attendance')
                          .add({
                        'date': date,
                        'status': stateOfAttendance[key],
                      });
                      print(key);
                      print(stateOfAttendance[key]);
                    }
                    await _firestore
                        .collection('Grade')
                        .doc(widget.gradeRef)
                        .collection('operation logger')
                        .add({
                      'type': 'Attendance',
                      'date': DateTime.now(),
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
