import 'package:flutter/material.dart';
import 'package:school/constants.dart';
import 'package:school/components/reusable_list_tile.dart';
import 'package:school/components/reusable_breaking_line.dart';

class SchoolScreen extends StatefulWidget {
  static const String id = 'school_screen';
  @override
  _SchoolScreenState createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFFFF8061),
                  ),
                  margin: EdgeInsets.all(20).copyWith(top: 30, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      Flexible(
                          child: Hero(
                              tag: 'school',
                              child: Image.asset('images/school.png'))),
                      Text(
                        'Code Academy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Pyasa in front of the Anbesa shoes building',
                        style: kSmallTextStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '0918611828',
                        style: kSmallTextStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                height: 1,
                width: 3,
                color: Colors.teal,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(20).copyWith(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFFFFC493),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        ReusableListTile(
                          title: 'Email',
                          text: 'CodeAcademy@gmail.com',
                        ),
                        ReusableBreakingLine(),
                        ReusableListTile(
                          title: 'Website',
                          text: 'www.CodeAcademy.com',
                        ),
                        ReusableBreakingLine(),
                        ReusableListTile(
                          title: 'School Dean',
                          text: 'Boss Man',
                        ),
                        ReusableBreakingLine(),
                        ReusableListTile(
                          title: 'Total Students',
                          text: '1000',
                        ),
                        ReusableBreakingLine(),
                        ReusableListTile(
                          title: 'Total Teachers',
                          text: '30',
                        ),
                        ReusableBreakingLine(),
                        ReusableListTile(
                          title: 'Teaching Grades',
                          text: '1-12',
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(left: 35),
                child: Text('Developed by Henok Worede, henycave@gmail.com'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
