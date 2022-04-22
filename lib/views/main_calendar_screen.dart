import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:test/views/event_editing_page.dart';
import 'package:test/views/profile_screen.dart';

class MainCalendarScreen extends StatefulWidget {
  const MainCalendarScreen({Key? key}) : super(key: key);

  @override
  State<MainCalendarScreen> createState() => _MainCalendarScreenState();
}

class _MainCalendarScreenState extends State<MainCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ProfileScreen())),
        ),
        title: Text("Kalendarz"),
        centerTitle: true,
      ),
      body: SfCalendar(
        view: CalendarView.month,
        firstDayOfWeek: 1,
        initialSelectedDate: DateTime.now(),
        dataSource: MeetingDataSource(_getDataSource()),
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showAgenda: true),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueGrey,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EventEditingPage())),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Dr Jan Nowak', startTime, endTime, const Color(0xFF700CB8), false));
    meetings.add(Meeting(
        'Dr Andrzej Nowak',
        startTime.add(const Duration(hours: 6)),
        endTime.add(const Duration(hours: 8)),
        const Color(0xFF0F8644),
        false));
    meetings.add(Meeting('Dr Jan Nowak', startTime.add(const Duration(days: 5)),
        endTime.add(const Duration(days: 5)), const Color(0xFF700CB8), false));
    meetings.add(Meeting(
        'Dr Jan Nowak',
        startTime.add(const Duration(days: 17)),
        endTime.add(const Duration(days: 21)),
        const Color(0xFF0F8644),
        false));
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
