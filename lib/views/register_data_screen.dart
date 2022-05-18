import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'profile_screen.dart';

class RegisterDataScreen extends StatefulWidget {
  const RegisterDataScreen({Key? key}) : super(key: key);

  @override
  State<RegisterDataScreen> createState() => _RegisterDataScreenState();
}

class _RegisterDataScreenState extends State<RegisterDataScreen> {
  Future<User?> registerUserData(
      {required String name,
      required String lastname,
      required String birthdate,
      required String weight,
      required String height}) async {
    try {
      if (FirebaseAuth.instance.currentUser!.uid != null &&
          name.isNotEmpty &&
          lastname.isNotEmpty &&
          birthdate.isNotEmpty &&
          weight.isNotEmpty &&
          height.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'name': name,
          'lastname': lastname,
          'userid': FirebaseAuth.instance.currentUser!.uid,
          'height': height,
          'birthdate': birthdate,
          'weight': weight,
        });
      }
    } catch (err) {
      print(err.toString());
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _lastnameController = TextEditingController();
    final TextEditingController _birthdateController = TextEditingController();
    final TextEditingController _heightController = TextEditingController();
    final TextEditingController _weightController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Twoje dane"),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(children: [
            const Text("E-poradnia",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold)),
            const Text("Podaj swoje dane",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 44.0),
            //imie
            TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    hintText: "Wpisz swoje imię",
                    prefixIcon: Icon(Icons.mail, color: Colors.black))),
            const SizedBox(height: 16.0),
            //nazwisko
            TextField(
                controller: _lastnameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    hintText: "Wpisz swoje nazwisko",
                    prefixIcon: Icon(Icons.lock, color: Colors.black))),
            const SizedBox(height: 16.0),
            //data urodzenia
            TextField(
                controller: _birthdateController,
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    hintText: "Wpisz swoją datę urodzenia",
                    prefixIcon: Icon(Icons.lock, color: Colors.black))),
            const SizedBox(height: 16.0),
            TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    hintText: "Wpisz swoją wagę [kg]",
                    prefixIcon: Icon(Icons.lock, color: Colors.black))),
            const SizedBox(height: 16.0),
            TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                    hintText: "Wpisz swój wzrost [cm]",
                    prefixIcon: Icon(Icons.lock, color: Colors.black))),
            const SizedBox(height: 18.0),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                  fillColor: Colors.amber,
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () async {
                    await registerUserData(
                        name: _nameController.text,
                        lastname: _lastnameController.text,
                        birthdate: _birthdateController.text,
                        weight: _weightController.text,
                        height: _heightController.text);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ProfileScreen()));
                  },
                  child: const Text("Zapisz dane",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold))),
              /*RawMaterialButton(
                              fillColor: Colors.red,
                              elevation: 0.0,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              onPressed: () {
                                print(FirebaseAuth.instance.currentUser);
                              },
                              child: const Text("Current User",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0)))*/
            ),
          ])),
    );
  }
}
