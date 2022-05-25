import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'doctor_views/doctor_profile_screen.dart';


class NotyficationScreen extends StatefulWidget {
  const NotyficationScreen({Key? key}) : super(key: key);

  @override
  State<NotyficationScreen> createState() => _NotyficationScreenState();
}

class _NotyficationScreenState extends State<NotyficationScreen> {

  final Stream<QuerySnapshot> _eventsStream = FirebaseFirestore.instance
      .collection('Notification')
      .orderBy("fromDate", descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Powiadomienia"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DoctorProfileHomePage(),
              )),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Notification")
              .where("doctorId",
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
                itemBuilder: (context, index) =>
                    Card(
                      child: RawMaterialButton(
                        onPressed: () {},
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

                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(snapshot.data!.docs[index]
                                              ["title"] +
                                                  ", " +
                                                  DateFormat('dd MMM yyy, H:mm').format(
                                                      snapshot
                                                          .data!.docs[index]["fromDate"]
                                                          .toDate()))
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(snapshot.data!.docs[index]
                                              ["status"]),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            )),
                      ),
                    ));
          }),
    );
  }
}
