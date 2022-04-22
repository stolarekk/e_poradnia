import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/model/event.dart';

class EventEditingPage extends StatefulWidget {

  final Event? event;
  const EventEditingPage({Key? key, this.event}) : super(key: key);



  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {

  final _formKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState(){
    super.initState();

    if(widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }
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

            ],
          ),
        ),
      )

    );
  }

  List<Widget> buildEditingActions() => [
    ElevatedButton.icon(
        //style: ElevatedButton.styleFrom(
        //  primary: Colors.transparent,
        //  shadowColor: Colors.transparent,
        //),
        icon: Icon(Icons.done),
        label: Text('Zapisz zmiany'),
        onPressed: () {  },
    )
  ];

  Widget buildTitle() => TextFormField(
    style: TextStyle(fontSize: 24),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: 'Wprowadź nazwe wizyty'
    ),
    onFieldSubmitted: (_) {},
  );
}
