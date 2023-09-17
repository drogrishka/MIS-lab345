import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Models/list_item.dart';


class CalendarPage extends StatefulWidget {
  final List<ListItem> list;

  const CalendarPage({super.key, required this.list});

  @override
  State<CalendarPage> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {

  @override
  Widget build(BuildContext context) {

  List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  widget.list.forEach((e) => meetings.add(Appointment(
    startTime: e.date,
    endTime: e.date.add(const Duration(hours: 2)),
    subject: e.subject,
    color: Colors.blue
  )));
  return meetings;
}

    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 1,
        dataSource: MeetingDataSource(getAppointments()),
      ),
    );

  }
}

class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}