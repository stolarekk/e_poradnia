import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/views/login_screen.dart';
import 'package:test/views/profile_screen.dart';

/*class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Code'),
      ),
      body: Center(child: Text('You have pressed the button $_count times.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}*/

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static Future<User?> registerUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
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
                const Text("Zarejestruj nowe konto!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 44.0),
                TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "Wpisz e-mail",
                        prefixIcon: Icon(Icons.mail, color: Colors.black))),
                const SizedBox(height: 26.0),
                TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Wpisz hasło",
                        prefixIcon: Icon(Icons.lock, color: Colors.black))),
                const SizedBox(height: 88.0),
                Container(
                    width: double.infinity,
                    child: RawMaterialButton(
                        fillColor: Colors.amber,
                        elevation: 0.0,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        onPressed: () async {
                          User? user = await registerUsingEmailPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                              context: context);
                          print(user);

                          if (user != null) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          }
                        },
                        child: const Text("Register",
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

//wpisywanie danych po rejestracji:

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
                decoration: const InputDecoration(
                    hintText: "Wpisz swoje imię",
                    prefixIcon: Icon(Icons.mail, color: Colors.black))),
            const SizedBox(height: 16.0),
            //nazwisko
            TextField(
                controller: _lastnameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    hintText: "Wpisz swoje nazwisko",
                    prefixIcon: Icon(Icons.lock, color: Colors.black))),
            const SizedBox(height: 16.0),
            //data urodzenia
            TextField(
                controller: _birthdateController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                    hintText: "Wpisz swoją datę urodzenia",
                    prefixIcon: Icon(Icons.lock, color: Colors.black))),
            const SizedBox(height: 16.0),
            TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "Wpisz swoją wagę [kg]",
                    prefixIcon: Icon(Icons.lock, color: Colors.black))),
            const SizedBox(height: 16.0),
            TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
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
