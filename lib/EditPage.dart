import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final memoController = TextEditingController();

  void dispose() {
    nameController.dispose();
    locationController.dispose();
    dateController.dispose();
    memoController.dispose();
    super.dispose();
  }

  Widget Eww(dt)
  {
    return Center(child: Text(dt['name']));
  }

  Widget testing(){
    return StreamBuilder(
      stream: Firestore.instance.collection('STB').snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return Center(child: Text("ERRR"));
        final dt = snapshot.data.documents[0];
        return Eww(dt);
      }
    );

  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: testing());/*SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 5, top: 40, right: 5),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: idText(),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: rowText(),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: memoTextField(),
                ),
                RaisedButton(
                  onPressed: () {
                   /* Firestore.instance.runTransaction((transaction) async{
                      await transaction.set(Firestore.instance.collection('STB').document('TB001'), {
                        'name' : nameController.text,
                        'location' : locationController.text,
                        'date' : dateController.text,
                        'memo' : memoController.text,
                      });
                    }).then((data) {print("upl");})
                    ;
                   */


                  },
                  child: Text('Click me'),
                ),
              ],
            ),
          ),
        ));
    */
  }

  Widget idText() {
    return Container(
      width: 350,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2.0)),
      child: Center(
        child: Text(
          'Smart Trashbin ID',
          textScaleFactor: 1.3,
        ),
      ),
    );
  }

  Widget rowText() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 150.0,
            height: 150.0,
            color: Colors.white,
            child: RaisedButton(
              child: Icon(Icons.delete,
                  color: const Color(0xFF000000), size: 120.0),
              textColor: Colors.black12,
              color: Colors.white,
            ),
          ),
          Container(
            width: 25,
            height: 50,
            decoration: BoxDecoration(border: null),
          ),
          Expanded(
            flex: 1,
            child: columnTextField(),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      margin: EdgeInsets.all(5),
    );
  }

  Widget columnTextField() {
    return Column(children: <Widget>[
      Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: TextField(
          controller: nameController,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
              contentPadding: EdgeInsets.all(5.0),
              hintText: 'Name'),
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: TextField(
          controller: locationController,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
              contentPadding: EdgeInsets.all(5.0),
              hintText: 'Location'),
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: TextField(
          controller: dateController,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
              contentPadding: EdgeInsets.all(5.0),
              hintText: 'Date'),
        ),
      ),
    ], mainAxisAlignment: MainAxisAlignment.spaceBetween);
  }

  Widget memoTextField() {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextField(
          controller: memoController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: TextStyle(fontSize: 21, color: Colors.black),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
            ),
            contentPadding: EdgeInsets.all(10),
            hintText: 'Memo',
          ),
        ));
  }
}
