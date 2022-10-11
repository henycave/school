import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:school/models/meeting.dart';
import 'package:school/models/meeting_data_source.dart';

class AttendanceScreen extends StatefulWidget {
  static const String id = 'attendance_screen';
  final String studentRef;
  AttendanceScreen({this.studentRef});
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('students')
                .doc(widget.studentRef)
                .collection('attendance')
                .where('date',
                    isGreaterThanOrEqualTo:
                        DateTime(DateTime.now().year, DateTime.now().month, 1))
                .snapshots(),
            builder: (context, snapshots) {
              if (!snapshots.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlue,
                  ),
                );
              }
              var documents = snapshots.data.docs;
              Timestamp date;
              String status;
              List meeting = <Meeting>[];
              for (var document in documents) {
                date = document.data()['date'];
                status = document.data()['status'].toString();
                String eventName;
                Color color;
                if (status == 'true') {
                  eventName = '  Present';
                  color = Colors.teal;
                } else {
                  eventName = '  Absent';
                  color = Colors.red;
                }
                final DateTime startTime = date.toDate();
                final DateTime endTime =
                    startTime.add(const Duration(hours: 12));
                meeting.add(Meeting(
                    eventName: eventName,
                    isAllDay: true,
                    from: startTime,
                    to: endTime,
                    background: color));
              }
              return SfCalendar(
                view: CalendarView.month,
                showNavigationArrow: true,
                firstDayOfWeek: 1,
                dataSource: MeetingDataSource(meeting),
                monthViewSettings: MonthViewSettings(
                    showAgenda: true,
                    agendaViewHeight: 100,
                    agendaItemHeight: 70,
                    showTrailingAndLeadingDates: false,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              );
            },
          ),
        ),
      ),
    );
  }
}
