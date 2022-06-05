import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:test/model/event_provider.dart';
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
        title: Text("Kalendarz"),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getDataFromFirebase(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('none');
              case ConnectionState.done:
                return Scaffold(
                  body: SfCalendar(
                    view: CalendarView.month,
                    firstDayOfWeek: 1,
                    initialSelectedDate: DateTime.now(),
                    //dataSource: MeetingDataSource(_getDataSource()),
                    dataSource:
                        MeetingDataSource(snapshot.data as List<Meeting>),
                    monthViewSettings: const MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.appointment,
                        showAgenda: true),
                  ),
                );

              default:
                return Text('default');
            }
          },
        ),
      ),
    );
  }

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Events');

  Future<List<Meeting>> _getDataFromFirebase() async {
    final List<Meeting> meetings = <Meeting>[];

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("UserData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    String userType = (snap.data() as Map<String, dynamic>)['usertype'];

    QuerySnapshot querySnapshot;

    if (userType == 'patient') {
      querySnapshot = await _collectionRef
          .where("patientId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
    } else {
      querySnapshot = await _collectionRef
          .where("doctorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
    }

    // QuerySnapshot querySnapshot = await _collectionRef.where!("patientId",
    //     isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

    final allEventsData =
        List<dynamic>.from(querySnapshot.docs.map((doc) => doc.data()));

    allEventsData.forEach((element) {
      Color meetColor;
      if(element['isFree']){
        meetColor = const Color(0xFF09975F);
      } else{
        meetColor = const Color(0xFF860F5A);
      }
      meetings.add(Meeting(element['title'], element['fromDate'].toDate(),
          element['toDate'].toDate(), meetColor, false));
    });
    return meetings;

    // meetings.add(Meeting(
    //     'Dr Jan Nowak',
    //     startTime.add(const Duration(days: 17)),
    //     endTime.add(const Duration(days: 21)),
    //     const Color(0xFF0F8644),
    //     false));

    // DocumentSnapshot snap = await FirebaseFirestore
    //     .instance
    //     .collection("Events")
    //     .doc('GWEGlDb0l8IUQFFFf6DT')
    //     .get();
    // var eventName = (snap.data() as Map<String, dynamic>)['title'];
    // print(eventName);
    // var fromDate = (snap.data() as Map<String, dynamic>)['fromDate'];
    // //print(fromDate);
    // var toDate = (snap.data() as Map<String, dynamic>)['toDate'];
    // //print(toDate);
    // meetings.add(Meeting(
    //     eventName,
    //     fromDate.toDate(),
    //     toDate.toDate(),
    //     const Color(0xFF860F5A),
    //     false
    // ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    final FirebaseController cont = FirebaseController();

    // meetings.add(Meeting(
    //     'Dr Jan Nowak', startTime, endTime, const Color(0xFF700CB8), false));
    // meetings.add(Meeting(
    //     'Dr Andrzej Nowak',
    //     startTime.add(const Duration(hours: 6)),
    //     endTime.add(const Duration(hours: 8)),
    //     const Color(0xFF0F8644),
    //     false));
    // meetings.add(Meeting('Dr Jan Nowak', startTime.add(const Duration(days: 5)),
    //     endTime.add(const Duration(days: 5)), const Color(0xFF700CB8), false));
    meetings.add(Meeting(
        'Dr Jan Nowak',
        startTime.add(const Duration(days: 17)),
        endTime.add(const Duration(days: 21)),
        const Color(0xFF0F8644),
        false));

    print(meetings[0].eventName);
    print(meetings[0].from);
    print(meetings[0].to);
    print(meetings[0].background);
    print(meetings[0].isAllDay);

    //meetings.add(cont.getDataSourceFromFirebase());

    return meetings;
  }
}

class FirebaseController {
  Future<Meeting> getEventFromFirebaseFuture() async {
    Meeting meetingData;

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("Events")
        .doc('GWEGlDb0l8IUQFFFf6DT')
        .get();

    var eventName = (snap.data() as Map<String, dynamic>)['title'];
    eventName = getTitleFromFirebase();
    print(eventName);

    var fromDate = (snap.data() as Map<String, dynamic>)['fromDate'];
    //print(fromDate);

    var toDate = (snap.data() as Map<String, dynamic>)['toDate'];
    //print(toDate);

    meetingData = Meeting(eventName, fromDate.toDate(), toDate.toDate(),
        const Color(0xFF860F5A), false);

    print('Z bazy');
    print(meetingData.eventName);
    print(meetingData.from);
    print(meetingData.to);
    print(meetingData.background);
    print(meetingData.isAllDay);

    return meetingData;
  }

  Meeting getDataSourceFromFirebase() {
    Meeting meet = getEventFromFirebaseFuture() as Meeting;

    return meet;
  }

  Future<String> getTitleFromFirebase() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("Events")
        .doc('GWEGlDb0l8IUQFFFf6DT')
        .get();

    var eventName = (snap.data() as Map<String, dynamic>)['title'];
    return eventName;
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
