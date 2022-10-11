import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  static const String id = 'schedule_screen';
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Schedule'),
        ),
      ),
    );
  }
}
