import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/views/profile_screen.dart';
import 'package:test/views/main_calendar_screen.dart';
import 'package:intl/intl.dart';

import 'doctor_profile_screen.dart';

class DoctorCancellationScreen extends StatefulWidget {
  const DoctorCancellationScreen({Key? key}) : super(key: key);

  @override
  State<DoctorCancellationScreen> createState() =>
      _DoctorCancellationScreenState();
}

class _DoctorCancellationScreenState extends State<DoctorCancellationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Odwołaj wizytę"),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Events")
                .where("doctorId",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                //.where("isFree", isEqualTo: false)
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
                                      title: Text(
                                          "Czy na pewno chcesz odwołać tę wizytę?"),
                                      content: Text(snapshot.data!.docs[index]
                                              ["title"] +
                                          ", " +
                                          DateFormat('dd MMM yyy, H:mm').format(
                                              snapshot
                                                  .data!.docs[index]["fromDate"]
                                                  .toDate())),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('Events')
                                                  .doc(snapshot.data!
                                                      .docs[index].reference.id)
                                                  .delete();
                                              await FirebaseFirestore.instance
                                                  .collection('Notification')
                                                  .add({
                                                'title': snapshot
                                                    .data!.docs[index]["title"],
                                                'fromDate': Timestamp.now(),
                                                'status':
                                                    "Odwołano przez doktora",
                                                'doctorId': snapshot.data!
                                                    .docs[index]["doctorId"],
                                                'symptoms': '',
                                                'patientId': snapshot.data!
                                                    .docs[index]["patientId"],
                                              });
                                            },
                                            child: Text(
                                              "TAK",
                                              style: TextStyle(
                                                  color: Colors.amber[700]),
                                            )),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("NIE",
                                                style: TextStyle(
                                                    color: Colors.amber[700])))
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
