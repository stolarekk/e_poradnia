import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/main.dart';
import 'package:test/views/cancel_visit_screen.dart';
import 'package:test/views/medical_documentation.dart';
import 'package:test/views/register_data_screen.dart';
import 'package:test/views/register_screen.dart';
import 'package:intl/intl.dart';
import 'package:test/views/reservation_screen.dart';
import 'package:test/views/visit_history.dart';
import 'main_calendar_screen.dart';

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({Key? key}) : super(key: key);

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  int _selectedIndex = 0;

  final screens = [
    ProfileScreen(),
    RegisterDataScreen(),
    MainCalendarScreen(),
    VisitHistoryScreen()
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                const Text("Witaj na swoim profilu!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 40.0),
                Container(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ReservationScreen()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.lightGreen[200],
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: const EdgeInsets.only(right: 8),
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.edit_calendar_rounded, size: 40.0),
                                Text('Zarezerwuj wizytę',
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
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CancellationScreen()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red[200],
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: const EdgeInsets.only(right: 8),
                            width: 150,
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
                        RawMaterialButton(
                          onPressed: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: const EdgeInsets.only(right: 8),
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.call_missed_outgoing_rounded,
                                    size: 40.0),
                                Text('Przełóż wizytę',
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
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MedicalDocScreen()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber[200],
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: const EdgeInsets.only(right: 10),
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.difference_outlined, size: 40.0),
                                Text('Dokumentacja med.',
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
                const Text("Twoje wizyty:",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20.0),
                Container(
                  height: 150,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    Container(
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  new DateFormat.yMd()
                                      .add_Hm()
                                      .format(DateTime.now())
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              Text("Okulista",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20.0),
                              Text("dr Andrzej Nowak",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  )),
                              Text("E-Poradnia ul. Lecznicza 27A",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  )),
                              Text("Gabinet 3",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  )),
                            ],
                          ),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  new DateFormat.yMd()
                                      .add_Hm()
                                      .format(DateTime.now())
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              Text("Kardiolog",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20.0),
                              Text("dr Jan Nowak",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  )),
                              Text("E-Poradnia ul. Lecznicza 27A",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  )),
                              Text("Gabinet 11",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  )),
                            ],
                          ),
                        ))
                  ]),
                )
              ])),
    );
  }
}
