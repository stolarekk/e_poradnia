import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/views/profile_screen.dart';
import 'package:test/views/main_calendar_screen.dart';
import 'package:intl/intl.dart';

import 'doctor_profile_screen.dart';

class DoctorVisitHistoryScreen extends StatefulWidget {
  const DoctorVisitHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DoctorVisitHistoryScreen> createState() =>
      _DoctorVisitHistoryScreenState();
}

class _DoctorVisitHistoryScreenState extends State<DoctorVisitHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Historia wizyt"),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Events")
                .where("doctorId",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("isFree", isEqualTo: false)
                //.where("toDate", isLessThanOrEqualTo: DateTime.now())
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
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
                                                              ["patientName"]),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    labelText: "Imię pacjenta",
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
                                                                  .docs[index][
                                                              "patientLastName"]),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    labelText:
                                                        "Nazwisko pacjenta",
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
                                                                  .docs[index][
                                                              "patientWeight"]),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    labelText: "Waga pacjenta",
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
                                                                  .docs[index][
                                                              "patientHeight"]),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    labelText:
                                                        "Wzrost pacjenta",
                                                  )),
                                            ),
                                            Container(
                                              width: 350,
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: TextField(
                                                  maxLines: 4,
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
                                            Text(snapshot.data?.docs[index]
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
                                      Text(DateFormat('dd MMM yyy, H:mm')
                                          .format(snapshot
                                              .data!.docs[index]["fromDate"]
                                              .toDate())),
                                    ],
                                  )),
                                ],
                              )),
                        ),
                      ));
            }));
  }
}
