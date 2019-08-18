import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DetailPage.dart';
import 'package:smartbin2/utils/dtb_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smartbin2/AddDetailInfo.dart';
import 'package:smartbin2/style.dart';
import 'dart:convert';
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

  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fcm.configure(
      onMessage: (Map<String, dynamic> msg) {
        print("onMessage: $msg");
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(msg['notification']['title'], style: titleStyle,),
                subtitle: Text(msg['notification']['body'], style: subTitleStyle),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('See information'), //
                  onPressed: () {

                    Navigator.push(context, MaterialPageRoute<void>(builder: (context){
                      return DetailPage(
                        uID: uID,
                        tID: msg['data']['tID'],
                      );

                    }));
//                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )

              ],
            )
        );
      },
      onResume: (Map<String, dynamic> msg) {
        print("onResume: $msg");
        print(msg['data']['tID']);
        Navigator.push(context, MaterialPageRoute<void>(builder: (context){
          return DetailPage(
            uID: uID,
            tID: msg['data']['tID'],
          );

        }));
      },
      onLaunch: (Map<String, dynamic> msg) {
        print("onLaunch: $msg");
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) =>
//                    DetailPage(
//                      uID: uID,
//                      tID: msg['data']['tID'],
//                    )
//            )
//        );
      },
    );

    _fcm.requestNotificationPermissions(
        IosNotificationSettings(

        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

//    await databaseHelper.getUser();

    databaseHelper.getUser().then((user) {
      if(uID == null) {
        setState(() {
          uID = user.uID;
//          _fcm.subscribeToTopic(uID);
          print("user id: ");
          print(uID);
        });
      }

    });

    return Scaffold(
      appBar: AppBar(title:  Center(child: Text('Trashbin Management', style: appBarTxTStyle, textAlign: TextAlign.center,)),),
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
          else {
            var len = snapshot.data.documents.length;
            var done = false;
            return ListView.builder(
                padding: const EdgeInsets.only(top:10.0, bottom: 10.0),
                itemExtent: 100.0,
                itemCount: len,
                itemBuilder: /*1*/ (context, i) {
                  if(!done) {
                    _fcm.subscribeToTopic(snapshot.data.documents[i]['tID']);
                  }
                  if(i == (len-1)) { //stop subscri topic again when reload
                    done = true;
                  }
                  return LSV(context, snapshot.data.documents[i]);
                });

//            return getBinListView(snapshot.data.documents);
          }
          }

      );
  }

  Widget LSV(BuildContext context, DocumentSnapshot document) {
    final name = document['name'] == null ? document['tID']: document['name'];




    return ListView(
      children: <Widget>[
        StreamBuilder(
          stream: Firestore.instance.collection('STB').where('tID', isEqualTo: document['tID']).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return Text('loading...', style: subTitleNormStyle,);

            //else
            var doc = snapshot.data.documents[0];
            String name = doc['name'] == null ? doc['tID']: doc['name'];
            String location = doc['location'];
            if(location == null) {
              location = "Add detailed information necessary";
            }

            return ListTile(
            leading: Container(width: 100, height:  100, child: imageFromBase64String(doc['img']),),
            title: Text(name),
            subtitle: Text(location, style: doc['location'] == null? subTitleStyle : subTitleNormStyle,),
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (context){
                if (doc['name'] == null)
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
               onPressed: () {
                 confirmDelete(context, document['tID']);
               },
            ),
            isThreeLine: true,
          );
          },
        ),
      ],
    );
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
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

  void confirmDelete(BuildContext context, id) {
    var confirmDialog = AlertDialog(
      title: Text('Do you want to remove this bin?', style: titleStyle,),
      content: null,
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('No'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            Firestore.instance.collection('users').document(uID).collection('binList').document(id).delete();
          },
          child: Text(
            'Remove',
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => confirmDialog
    );
  }
}



