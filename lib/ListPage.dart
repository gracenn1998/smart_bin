import 'package:flutter/material.dart';
import 'EditPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DetailPage.dart';
import 'package:smartbin2/utils/dtb_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TrashBinList extends StatefulWidget {
  _TrashBinListState createState() => _TrashBinListState();
}

class _TrashBinListState extends State<TrashBinList> {
  String uID;
  DatabaseHelper databaseHelper = DatabaseHelper();

  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fcm.configure(
      onMessage: (Map<String, dynamic> msg) {
        print("onMessage: $msg");
//        print(_selectedDriverID);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(msg['notification']['title']),
                subtitle: Text(msg['notification']['body']),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('See information'), //
                  onPressed: () {
                    print(msg['data']['tID']);
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
    print('list page');

//    await databaseHelper.getUser();

    databaseHelper.getUser().then((user) {
      if(uID == null) {
        setState(() {
          uID = user.uID;
          _fcm.subscribeToTopic(uID);
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Add trashbin"),
                    content: Container(
                      height: 160,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: TextField(
                              decoration: InputDecoration(labelText: 'ID'),
                              //controller: _idController,
                            ),
                          ),
                          Container(
                            child: TextField(
                              decoration:
                              InputDecoration(labelText: 'Password'),
                            ),
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            print('added...');
                            //print(_idController.text);
                            Navigator.of(context).pop();
                          },
                          child: Text("Add"))
                    ],
                  );
                });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pink),
      body: listbuild(context),
    );
  }

  Widget listbuild(BuildContext context) {

    return StreamBuilder(
        stream: Firestore.instance.collection('users').document(uID).collection('binList').snapshots(),
        builder: (context, snapshot) {

          if(!snapshot.hasData) return Center(child: Text('Loading...', ),);
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
    return ListView(
      children: <Widget>[
        ListTile(
          leading: FlutterLogo(size: 100.0),
          title: Text(document['tID']),
          subtitle: Text(document['location']),
          onTap: () {
            Navigator.push(context, MaterialPageRoute<void>(builder: (context){
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
}



