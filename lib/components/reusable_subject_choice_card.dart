import 'package:flutter/material.dart';

class ReusableSubjectChoiceCard extends StatelessWidget {
  final String subjectName;
  final Color color;
  final onTap;
  ReusableSubjectChoiceCard({this.onTap, this.color, this.subjectName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20)
              .copyWith(top: 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: Image.asset(
                  'images/teacher_icon.png',
                  width: 70,
                ),
              ),
              SizedBox(
                width: 20,
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
                    height: 5,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                ),
              ),
            ],
          )),
    );
  }
}
