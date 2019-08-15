import 'package:flutter/material.dart';
import 'EditPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DetailPage.dart';
import 'package:smartbin2/utils/dtb_helper.dart';
import 'package:smartbin2/models/userid.dart';
import 'package:smartbin2/AddDetailInfo.dart';

class TrashBinList extends StatefulWidget {
  _TrashBinListState createState() => _TrashBinListState();
}

class _TrashBinListState extends State<TrashBinList> {
  String uID;
  DatabaseHelper databaseHelper = DatabaseHelper();
  final _idController = TextEditingController();
  final _keyController = TextEditingController();

  void dispose(){
    _idController.dispose();
    _keyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    print('list page');

//    await databaseHelper.getUser();

    databaseHelper.getUser().then((user) {
      if(uID == null) {
        setState(() {
          uID = user.uID;
          print("user id: ");
          print(uID);
        });
      }

    });
//
//    print("user id: ");
//    print(uID);

    return Scaffold(
      appBar: AppBar(title: Text('trashbin management')),
      floatingActionButton: buildFABAdd(),
      body: listbuild(context),
    );
  }

  Widget listbuild(BuildContext context) {

    return StreamBuilder(
        stream: Firestore.instance.collection('users').document(uID).collection('binList').snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting)
            return Center( child: CircularProgressIndicator());
          else
          return ListView.builder(
              padding: const EdgeInsets.only(top:10.0, bottom: 10.0),
              itemExtent: 100.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: /*1*/ (context, i) {
                return LSV(context, snapshot.data.documents[i]);
              });

//            return getBinListView(snapshot.data.documents);
        },
      );
  }

  Widget LSV(BuildContext context, DocumentSnapshot document) {
    final name = document['name'] == null ? document['tID']: document['name'];
    final location = document['location'] == null ?
    "Did not add detail info": document['location'];

    return ListView(
      children: <Widget>[
        ListTile(
          leading: FlutterLogo(size: 100.0),
          title: Text(name),
          subtitle: Text(location),
          onTap: () {
            Navigator.push(context, MaterialPageRoute<void>(builder: (context){
              if (document['name'] == null)
                return
                  AddInfo(tID: document['tID'], uID: uID);
              return DetailPage(
                  tID: document['tID'],
                uID: uID,
              );

            }));
          },
          trailing: IconButton(
            icon: Icon(Icons.close),
           // onPressed: () {
           //   Navigator.push(context, MaterialPageRoute<void>(builder: (context) {
           //     return EditPage();
           //   }));
           // },              // Please add the remove function HERE !! Thank you !!
          ),
          isThreeLine: true,
        ),
      ],
    );
  }



  Widget buildFABAdd(){
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      onPressed: (){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text("Add New Smart Bin"),
                content: FABContent(),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Add"),
                    onPressed: (){
                      if (_idController != null) {
                        var docRef = Firestore.instance.
                        collection("STB").document(_idController.text);
                        docRef.get().then((doc) {
                          if (doc.exists) {
                            if (doc['key'] == _keyController.text) {
                              Navigator.of(context).pop();

                              Firestore.instance.collection("users").
                              document(uID).collection('binList').
                              document(_idController.text).setData({
                                'tID': _idController.text,
                                'bin1': false,
                                'bin2': false,

                              });

                              _showDialog("Added Successfully!");
                            } else _showDialog("Wrong ID or key");
                          }
                          else _showDialog("Wrong ID or key");
                        });
                      } //if

                    },
                  ),

                  FlatButton(
                    child: Text("Close"),
                    onPressed: ()=> Navigator.of(context).pop(),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  Widget _showDialog(str)
  {
    showDialog(context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            content: new Text(str),
            actions: <Widget>[
              new FlatButton(onPressed: () => Navigator.of(context).pop(), child: new Text("Close"))
            ],
          );
        }
    );
  }

  Widget FABContent() {
    return Container(
      height: 160,
      child: Column(
        children: <Widget>[
          Container(
            child: TextField(
              decoration: InputDecoration(labelText: 'Smart Bin ID'),
              controller: _idController,
            ),
          ),
          Container(
            child: TextField(
              controller: _keyController,
              decoration:
              InputDecoration(labelText: 'SmartBin Key'),
            ),
          )
        ],
      ),
    );
  }
}



