import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/model/event.dart';
import 'package:intl/intl.dart';
import '../model/event_provider.dart';
import 'package:provider/provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;
  const EventEditingPage({Key? key, this.event}) : super(key: key);

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  late String doctorName;
  late String doctorLastName;
  late String doctorType;

  Future<Event?> registerEventData(
      {required String title,
      required String description,
      required DateTime fromDate,
      required DateTime toDate,
      required bool isFree,
      required String doctorId,
      required String doctorName,
      required String doctorLastName,
      required String doctorType,
      required String patientId,
      required String patientName,
      required String patientLastName,
      required String patientHeight,
      required String patientWeight,
      required bool isAllDay}) async {
    try {
      await FirebaseFirestore.instance.collection('Events').add({
        'title': title,
        'description': description,
        'fromDate': fromDate,
        'toDate': toDate,
        'isFree': true,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'doctorLastName': doctorLastName,
        'doctorType': doctorType,
        'patientId': patientId,
        'patientName': patientName,
        'patientLastName': patientLastName,
        'patientHeight': patientHeight,
        'patientWeight': patientWeight,
        'isAllDay': false
      });
    } catch (err) {
      print(err.toString());
    }
    ;
  }

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: buildEditingActions(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildTitle(),
                SizedBox(height: 12),
                buildDateTimePickers(),
              ],
            ),
          ),
        ));
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          //style: ElevatedButton.styleFrom(
          //  primary: Colors.transparent,
          //  shadowColor: Colors.transparent,
          //),
          icon: Icon(Icons.done),
          label: Text('Zapisz zmiany'),
          onPressed: saveForm,
        )
      ];

  Widget buildTitle() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Wprowadź nazwe wizyty'),
        onFieldSubmitted: (_) => saveForm(),
        validator: (title) => title != null && title.isEmpty
            ? 'Musisz wprowadzić nazwę wizyty'
            : null,
        controller: titleController,
      );

  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => buildHeader(
        header: 'Data rozpoczęcia',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: DateFormat.yMMMEd().format(fromDate),
                onClicked: () => pickFromDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdownField(
                text: DateFormat.Hm().format(fromDate),
                onClicked: () => pickFromDateTime(pickDate: false),
              ),
            ),
          ],
        ),
      );

  Widget buildTo() => buildHeader(
        header: 'Data zakończenia',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: DateFormat.yMMMEd().format(toDate),
                onClicked: () => pickToDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdownField(
                text: DateFormat.Hm().format(toDate),
                onClicked: () => pickToDateTime(pickDate: false),
              ),
            ),
          ],
        ),
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
    );
    if (date == null) return;
    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2020, 1),
          lastDate: DateTime(2100));

      if (date == null) return null;

      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);

      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          child,
        ],
      );

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("UserData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      doctorName = (snap.data() as Map<String, dynamic>)['name'];
      doctorLastName = (snap.data() as Map<String, dynamic>)['lastname'];

      doctorType = (snap.data() as Map<String, dynamic>)['doctorType'];
    });

    if (isValid) {
      final event = Event(
          title: titleController.text,
          description: 'Brak opisu wizyty',
          from: fromDate,
          to: toDate,
          isFree: true,
          doctorId: FirebaseAuth.instance.currentUser!.uid,
          doctorName: doctorName,
          doctorLastName: doctorLastName,
          doctorType: doctorType,
          patientId: '',
          patientName: '',
          patientLastName: '',
          patientHeight: '',
          patientWeight: '',
          isAllDay: false);

      await registerEventData(
          title: event.title,
          description: event.description,
          fromDate: event.from,
          toDate: event.to,
          isFree: true,
          doctorId: event.doctorId,
          doctorName: event.doctorName,
          doctorLastName: event.doctorLastName,
          doctorType: event.doctorType,
          patientId: event.patientId,
          patientName: event.patientName,
          patientLastName: event.patientLastName,
          patientHeight: event.patientHeight,
          patientWeight: event.patientWeight,
          isAllDay: false);

      //final provider = Provider.of<EventProvider>(
      //  context,
      //  listen: false
      //);
      //provider.addEvent(event);

      Navigator.of(context).pop();
    }
  }
}
