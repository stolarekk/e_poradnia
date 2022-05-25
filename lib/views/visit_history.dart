import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/views/profile_screen.dart';
import 'package:test/views/main_calendar_screen.dart';
import 'package:intl/intl.dart';

class VisitHistoryScreen extends StatefulWidget {
  const VisitHistoryScreen({Key? key}) : super(key: key);

  @override
  State<VisitHistoryScreen> createState() => _VisitHistoryScreenState();
}

class _VisitHistoryScreenState extends State<VisitHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historia wizyt"),
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
              .where("toDate", isLessThanOrEqualTo: DateTime.now())
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
}
