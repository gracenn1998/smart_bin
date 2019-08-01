import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
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
                )
              ],
            ),
          ),
        ));
  }

  Widget idText() {
    return Container(
      width: 350,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2.0)),
      child: Center(
        child: Text('Smart Trashbin ID', textScaleFactor: 1.3,),
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
                  color: const Color(0xFF000000),
                  size: 120.0),
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
