import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/views/doctor_views/doctor_profile_screen.dart';
import 'package:test/views/profile_screen.dart';
import 'package:test/views/main_calendar_screen.dart';
import 'package:intl/intl.dart';

class AddVisitDescriptionScreen extends StatefulWidget {
  const AddVisitDescriptionScreen({Key? key}) : super(key: key);

  @override
  State<AddVisitDescriptionScreen> createState() =>
      _AddVisitDescriptionScreenState();
}

class _AddVisitDescriptionScreenState extends State<AddVisitDescriptionScreen> {
  TextEditingController _descriptionController = TextEditingController();
  @override
  late String patientName;
  late String patientLastName;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj opis wizyty"),
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
              .collection("Events")
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
                itemBuilder: (context, index) => Card(
                      child: RawMaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Dodaj opis tej wizyty"),
                                    content: Text(snapshot.data!.docs[index]
                                            ["title"] +
                                        ", " +
                                        DateFormat('dd MMM yyy, H:mm').format(
                                            snapshot
                                                .data!.docs[index]["fromDate"]
                                                .toDate())),
                                    actions: [
                                      SizedBox(height: 10),
                                      Container(
                                        height: 200,
                                        child: TextField(
                                            maxLines: 20,
                                            controller: _descriptionController,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                hintText: "Wpisz opis wizyty",
                                                labelText: "Wpisz opis wizyty",
                                                prefixIcon: Icon(
                                                    Icons.design_services,
                                                    color: Colors.black))),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('Events')
                                                .doc(snapshot.data!.docs[index]
                                                    .reference.id)
                                                .update({
                                              "description":
                                                  _descriptionController.text,
                                            });
                                            _descriptionController.text = "";
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Dodaj opis",
                                            style: TextStyle(
                                                color: Colors.amber[700]),
                                          )),
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
    });
  }
}
