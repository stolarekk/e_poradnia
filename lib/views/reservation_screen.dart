import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/views/profile_screen.dart';
import 'package:test/views/main_calendar_screen.dart';
import 'package:intl/intl.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({Key? key}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  @override
  late String patientName;
  late String patientLastName;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rezerwacja wizyty"),
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
              //.orderBy("fromDate")
              .where("isFree", isEqualTo: true)
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
                                    title: Text(
                                        "Czy na pewno chcesz zarezerwować tę wizytę?"),
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
                                            getUsername();
                                            await FirebaseFirestore.instance
                                                .collection('Events')
                                                .doc(snapshot.data!.docs[index]
                                                    .reference.id)
                                                .update({
                                              'isFree': false,
                                              'patientId': FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              'patientLastName':
                                                  patientLastName,
                                              'patientName': patientName
                                            });
                                            await FirebaseFirestore.instance
                                                .collection('Notification')
                                                .add({
                                              'title': snapshot
                                                  .data!.docs[index]["title"],
                                              'fromDate': Timestamp.now(),
                                              'status': "Rezerwacja",
                                              'doctorId': snapshot.data!
                                                  .docs[index]["doctorId"],
                                              'patientId': snapshot.data!
                                                  .docs[index]["patientId"],
                                            });
                                            Navigator.pop(context);
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
