import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
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
      body: SfCalendar(
        view: CalendarView.month,
        firstDayOfWeek: 1,
        initialSelectedDate: DateTime.now(),
      ),

    );
  }
}
