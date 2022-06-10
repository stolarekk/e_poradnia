import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/main.dart';
import 'package:test/views/doctor_views/add_visit_description.dart';
import 'package:test/views/doctor_views/doctor_cancel_visit_screen.dart';
import 'package:test/views/register_data_screen.dart';
import 'package:test/views/register_screen.dart';
import 'package:test/views/main_calendar_screen.dart';
import 'package:intl/intl.dart';
import '../event_editing_page.dart';
import '../notification_screen.dart';
import '../reservation_screen.dart';
import 'doctor_notification_screen.dart';
import 'doctor_visit_history.dart';

class DoctorProfileHomePage extends StatefulWidget {
  const DoctorProfileHomePage({Key? key}) : super(key: key);

  @override
  State<DoctorProfileHomePage> createState() => _DoctorProfileHomePageState();
}

class _DoctorProfileHomePageState extends State<DoctorProfileHomePage> {
  int _selectedIndex = 0;

  final screens = [
    DoctorProfileScreen(),
    RegisterDataScreen(),
    MainCalendarScreen(),
    DoctorVisitHistoryScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Strona główna'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Twoje dane'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Kalendarz'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Historia wizyt'),
        ],
        selectedItemColor: Colors.black,
        selectedFontSize: 11,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 11,
      ),
    );
  }
}

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({Key? key}) : super(key: key);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  String name = "";
  String lastname = "";

  @override
  //void initState() {
  // super.initState();
  // getUsername();
  //}

  // void getUsername() async {
  //  DocumentSnapshot snap = await FirebaseFirestore.instance
  //     .collection("UserData")
  //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //     .get();
  // setState(() {
  //   name = (snap.data() as Map<String, dynamic>)['name'];
  //  lastname = (snap.data() as Map<String, dynamic>)['lastname'];
  //  });
  //}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Strona główna"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Wyloguj się',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              FirebaseAuth.instance.userChanges().listen((User? user) {
                if (user == null) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()));
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Pomyślnie wylogowano z konta')));
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("E-poradnia",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 5.0),
                const Text("Witaj na profilu doktora!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 40.0),
                Container(
                    height: 200,
                    child:
                        ListView(scrollDirection: Axis.horizontal, children: [
                      RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EventEditingPage()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.cyan[200],
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          margin: const EdgeInsets.only(right: 14),
                          width: 173,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.edit_calendar_rounded, size: 40.0),
                              Text('Ustal godziny wizyt',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DoctorCancellationScreen()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red[300],
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          //margin: const EdgeInsets.only(right: 8),
                          width: 173,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.cancel_presentation_rounded,
                                  size: 40.0),
                              Text('Odwołaj wizytę',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ])),
                const SizedBox(height: 14.0),
                Container(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DoctorNotyficationScreen()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.pink[100],
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: const EdgeInsets.only(right: 14),
                            width: 173,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.access_alarm_sharp, size: 40.0),
                                Text('Powiadomienia',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        RawMaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddVisitDescriptionScreen()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[200],
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            //margin: const EdgeInsets.only(right: 15),
                            width: 173,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.difference_outlined, size: 40.0),
                                Text('Dodaj opis wizyty',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 40.0),
              ])),
    );
  }
}
