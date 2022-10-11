import 'package:flutter/material.dart';

class ReusableSubjectCard extends StatelessWidget {
  final String subjectName;
  final String teacherName;
  final String phoneNumber;
  final Color color;

  ReusableSubjectCard({
    this.color,
    this.phoneNumber,
    this.subjectName,
    this.teacherName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20)
            .copyWith(top: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Image.asset(
                'images/teacher_icon.png',
                width: 100,
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.library_books,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      subjectName,
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    teacherName,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    phoneNumber,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
