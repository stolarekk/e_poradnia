import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/views/profile_screen.dart';
import 'package:test/views/main_calendar_screen.dart';
import 'package:intl/intl.dart';

class MedicalDocScreen extends StatefulWidget {
  const MedicalDocScreen({Key? key}) : super(key: key);

  @override
  State<MedicalDocScreen> createState() => _MedicalDocScreenState();
}

class _MedicalDocScreenState extends State<MedicalDocScreen> {
  late String patientName;
  late String patientLastName;
  late String patientHeight;
  late String patientWeight;
  late String patientBirthdate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dokumentacja medyczna"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ProfileHomePage(),
          )),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Events")
              .where("patientId",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Card(
                      child: RawMaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    insetPadding: EdgeInsets.all(16.0),
                                    title: Text("Opis wizyty"),
                                    actions: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 350,
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: TextField(
                                                readOnly: true,
                                                controller:
                                                    TextEditingController(
                                                        text: snapshot.data!
                                                                .docs[index]
                                                            ["title"]),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  labelText: "Tytuł wizyty",
                                                )),
                                          ),
                                          Container(
                                            width: 350,
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: TextField(
                                                readOnly: true,
                                                controller:
                                                    TextEditingController(
                                                        text: snapshot.data!
                                                                .docs[index]
                                                            ["doctorName"]),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  labelText: "Imię doktora",
                                                )),
                                          ),
                                          Container(
                                            width: 350,
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: TextField(
                                                readOnly: true,
                                                controller:
                                                    TextEditingController(
                                                        text: snapshot.data!
                                                                .docs[index]
                                                            ["doctorLastName"]),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  labelText: "Nazwisko doktora",
                                                )),
                                          ),
                                          Container(
                                            width: 350,
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: TextField(
                                                readOnly: true,
                                                controller:
                                                    TextEditingController(
                                                        text: snapshot.data!
                                                                .docs[index]
                                                            ["doctorType"]),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  labelText:
                                                      "Specjalizacja doktora",
                                                )),
                                          ),
                                          Container(
                                            width: 350,
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: TextField(
                                                maxLines: 8,
                                                readOnly: true,
                                                controller:
                                                    TextEditingController(
                                                        text: snapshot.data!
                                                                .docs[index]
                                                            ["description"]),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  labelText: "Opis wizyty",
                                                )),
                                          ),
                                          Container(
                                            width: 350,
                                            margin: const EdgeInsets.only(
                                                bottom: 25),
                                            child: TextField(
                                                readOnly: true,
                                                controller: TextEditingController(
                                                    text: DateFormat(
                                                            'dd MMM yyy, H:mm')
                                                        .format(snapshot
                                                            .data!
                                                            .docs[index]
                                                                ["fromDate"]
                                                            .toDate())),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  labelText: "Data wizyty",
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ));
                        },
                        child: Container(
                            height: 60,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(snapshot.data!.docs[index]
                                              ["title"]),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(DateFormat('dd MMM yyy, H:mm').format(
                                        snapshot.data!.docs[index]["fromDate"]
                                            .toDate())),
                                  ],
                                )),
                              ],
                            )),
                      ),
                    ));
          }),
    );
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("UserData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      patientName = (snap.data() as Map<String, dynamic>)['name'];
      patientLastName = (snap.data() as Map<String, dynamic>)['lastname'];
      patientHeight = (snap.data() as Map<String, dynamic>)['height'];
      patientWeight = (snap.data() as Map<String, dynamic>)['weight'];
      patientBirthdate = (snap.data() as Map<String, dynamic>)['birthdate'];
    });
  }
}
