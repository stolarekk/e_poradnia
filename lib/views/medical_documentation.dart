import 'package:flutter/material.dart';
import 'package:test/views/profile_screen.dart';

class MedicalDocScreen extends StatefulWidget {
  const MedicalDocScreen({Key? key}) : super(key: key);

  @override
  State<MedicalDocScreen> createState() => _MedicalDocScreenState();
}

class _MedicalDocScreenState extends State<MedicalDocScreen> {
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
      body: Center(
          child: Text('Dokumentacja medyczna', style: TextStyle(fontSize: 20))),
    );
  }
}
