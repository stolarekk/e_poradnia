import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/main.dart';
import 'package:test/views/register_data_screen.dart';
import 'package:test/views/register_screen.dart';
import 'package:test/views/main_calendar_screen.dart';

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
    Center(
        child:
            Text('Historia wizyt - w budowie', style: TextStyle(fontSize: 60)))
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
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("E-poradnia",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold)),
                const Text("Witaj na swoim profilu, doktorze!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(
                      Icons.arrow_back_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Wyloguj się",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      FirebaseAuth.instance.userChanges().listen((User? user) {
                        if (user == null) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                      });
                    }),
                /*Container(
                child: RawMaterialButton(
                    fillColor: Colors.red,
                    onPressed: () {
                      print(FirebaseAuth.instance.currentUser);
                    },
                    child: const Text("Current User",
                        style: TextStyle(color: Colors.white, fontSize: 18.0))),
              ),*/
              ])),
    );
  }
}
