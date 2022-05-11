import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/views/profile_screen.dart';
import 'package:test/views/register_screen.dart';

import 'doctor_views/doctor_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userType = "";

  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("E-poradnia",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold)),
                const Text("Zaloguj się na konto pacjenta",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 54.0),
                TextField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "Wpisz e-mail",
                        prefixIcon: Icon(Icons.mail, color: Colors.black))),
                const SizedBox(height: 26.0),
                TextField(
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Wpisz hasło",
                        prefixIcon: Icon(Icons.lock, color: Colors.black))),
                const SizedBox(height: 2.0),
                /*Container(
                  child: RawMaterialButton(
                      fillColor: Colors.amber,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                      },
                      child: const Text("Register",
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0))),
                ),*/
                RawMaterialButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                    },
                    child: const Text(
                      'Nie masz konta? Zarejestruj się!',
                      style: TextStyle(color: Colors.black),
                    )),

                /*Container(
                  child: RawMaterialButton(
                      fillColor: Colors.blueGrey,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => RegisterDataScreen()));
                      },
                      child: const Text("Register Data",
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0))),
                ),*/
                const SizedBox(height: 28.0),
                Container(
                    width: double.infinity,
                    child: RawMaterialButton(
                        fillColor: Colors.amber,
                        elevation: 0.0,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        onPressed: () async {
                          User? user = await loginUsingEmailPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                              context: context);
                          //odczyt rangi użytkownika - rozpoznawanie czy pacjent czy doktor
                          DocumentSnapshot snap = await FirebaseFirestore
                              .instance
                              .collection("UserData")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .get();
                          setState(() {
                            userType = (snap.data()
                                as Map<String, dynamic>)['usertype'];
                          });
                          //
                          if (user != null && userType == 'patient') {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ProfileHomePage()));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Pomyślnie zalogowano na konto pacjenta')));
                          }
                          if (user != null && userType == 'doctor') {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DoctorProfileHomePage()));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Pomyślnie zalogowano na konto doktora')));
                          }
                        },
                        child: const Text("Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold)))),
                /*Container(
                  child: RawMaterialButton(
                      fillColor: Colors.red,
                      onPressed: () {
                        print(FirebaseAuth.instance.currentUser);
                      },
                      child: const Text("Current User",
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0))),
                ),*/
              ])),
    );
  }
}
