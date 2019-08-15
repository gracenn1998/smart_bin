import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EditPage.dart';
import 'ListPage.dart';

class DetailPage extends StatefulWidget {
  final String tID;
  final String uID;
  const DetailPage({@required this.tID, @required this.uID});

  @override
  _DetailPageState createState() => _DetailPageState(tID, uID);
}

class _DetailPageState extends State<DetailPage> {

  String tID, uID;
  _DetailPageState(this.tID, this.uID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Detail',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(uID)
                .collection('binList')
                .where('tID', isEqualTo: tID).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: Text('Loading...')); else
              return showAllInfo(snapshot.data.documents[0]);
            }));
  }

  Widget showAllInfo(bin) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 5, top: 40, right: 5),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: idText(bin['tID']),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: rowText(bin['name'], bin['location'], bin['date']),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: memoText(bin['memo']),
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute<void>(builder: (context) {
                      return EditPage(
                        uID: uID,
                        tID: tID,
                      );
                    }));
                  },
                  child: Text("Edit"),
                ),
              ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ],
        ),
      ),
    );
  }

  Widget idText(id) {
    return Container(
      width: 350,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2.0)),
      child: Center(
        child: Text(
          id,
          textScaleFactor: 1.3,
        ),
      ),
    );
  }

  Widget rowText(name, location, date) {
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
            child: detailText(name, location, date),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      margin: EdgeInsets.all(5),
    );
  }

  Widget detailText(name, location, date) {
    return Column(children: <Widget>[
      detail(name),
      detail(location),
      detail(date),
    ], mainAxisAlignment: MainAxisAlignment.spaceBetween);
  }

  Widget detail(info) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      margin: EdgeInsets.only(top: 7, bottom: 7),
      width: 150,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2.0)),
      child: Center(
        child: Text(
          info,
          textScaleFactor: 1.1,
        ),
      ),
    );
  }

  Widget memoText(memo) {
    return Container(
      width: 350,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2.0)),
      child: Center(
        child: Text(
          memo,
          textScaleFactor: 1.2,
        ),
      ),
    );
  }
}
