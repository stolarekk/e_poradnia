import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/main.dart';
import 'package:test/views/register_screen.dart';

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
                  const Text("Witaj na swoim profilu!",
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
                        FirebaseAuth.instance
                            .userChanges()
                            .listen((User? user) {
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
                  const SizedBox(height: 28.0),
                  Container(
                      width: double.infinity,
                      child: RawMaterialButton(
                          fillColor: Colors.green,
                          elevation: 0.0,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          onPressed: () async {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterDataScreen()));
                          },
                          child: const Text("Zmień swoje dane",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ))))
                ])));
  }
}
