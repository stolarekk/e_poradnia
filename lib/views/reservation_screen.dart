import 'package:flutter/material.dart';
import 'package:test/views/profile_screen.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({Key? key}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  @override
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
      body: Center(
          child: Text('Rezerwacja wizyt', style: TextStyle(fontSize: 20))),
    );
  }
}
