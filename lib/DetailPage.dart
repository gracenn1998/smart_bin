import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EditPage.dart';
import 'package:smartbin2/style.dart';

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
    var binDoc;
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(
            'Detail',
            style: appBarTxTStyle, textAlign: TextAlign.center,
          )),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  //editttt
                  Navigator.push(context, MaterialPageRoute<void>(builder: (context) {
                    return EditPage(
                      uID: uID,
                      binInfo: binDoc,
                    );
                  }));
//                  Navigator.push(context, MaterialPageRoute(builder: (context) {
//                    return EditDriverInfo(
//                      dID: dID,
//                    );
//                  }));
                },
              ),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('STB')
                .where('tID', isEqualTo: tID).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: Text('Loading...'));
              else {
//                print('ok');
                binDoc = snapshot.data.documents[0];
                return showAllInfo(binDoc);
              }

            }),

    );
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
              child: rowText(bin['name'], bin['location']),
            ),
            Row(
              children: <Widget>[
                subBinStatus(bin['bin1'], bin['bin2'])

              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: memoText(bin['memo']),
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
          'Smart Trashbin $tID',
          textScaleFactor: 1.3,
        ),
      ),
    );
  }

  Widget rowText(name, location) {
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
            child: detailText(name, location),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      margin: EdgeInsets.all(5),
    );
  }

  Widget detailText(name, location) {
    return Column(children: <Widget>[
      detail(name),
      detail(location),
    ], mainAxisAlignment: MainAxisAlignment.spaceBetween);
  }

  Widget detail(info) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      margin: EdgeInsets.only(top: 7, bottom: 7),
      width: 150,
      height: 50,
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
      height: 100,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2.0)),
      child: Center(
        child: SingleChildScrollView(
          child:  Text(
            memo,
            textScaleFactor: 1.2,
          ),
        ),
      ),
    );
  }

  Widget subBinStatus(bin1, bin2) {
    var bin1status = bin1.toString() == 'true'? 'Full' : 'Normal';
    var bin2status = bin2.toString() == 'true'? 'Full' : 'Normal';

    const TextStyle fullStatusStyle = TextStyle(
        color: Colors.deepOrange
    );

    const TextStyle normalStatusStyle = TextStyle(
        color: Colors.black
    );

    return Column(
      children: <Widget>[
        Row (
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              margin: EdgeInsets.only(top: 7, bottom: 7, right: 10),
              width: 170,
              height: 45,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2.0)),
              child: Center(
                child: Text(
                  'Recycling: ' + bin1status,
                  style: bin1status == 'Full' ? binStatusStyle(1) : binStatusStyle(0),
                  textScaleFactor: 1.1,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              margin: EdgeInsets.only(top: 7, bottom: 7),
              width: 170,
              height: 45,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2.0)),
              child: Center(
                child: Text(
                  'Non-recycling: ' + bin2status,
                  style: bin2status == 'Full' ? binStatusStyle(1) : binStatusStyle(0),
                  textScaleFactor: 1.1,
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }
}
