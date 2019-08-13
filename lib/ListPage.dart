import 'package:flutter/material.dart';
import 'EditPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DetailPage.dart';

class TrashBinList extends StatefulWidget {
  _TrashBinListState createState() => _TrashBinListState();
}

class _TrashBinListState extends State<TrashBinList> {
  String _selectedBin = null;

  @override

  Widget build(BuildContext context) {
    // TODO: implement build

    print('reload');

    if(_selectedBin != null) {
      return DetailPage(
        tID: _selectedBin,
      );
 //     Navigator.push(context, MaterialPageRoute<void>(builder: (context){
 //       return DetailPage(
 //           tID: 'T0001'
 //       );
 //     }));
    }

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
        stream: Firestore.instance.collection('STB').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemExtent: 100.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: /*1*/ (context, i) {
                return LSV(context, snapshot.data.documents[i]);
              });
        },
      );
  }

  Widget LSV(BuildContext context, DocumentSnapshot document) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: FlutterLogo(size: 100.0),
          title: Text(document['name']),
          subtitle: Text(document['location']),
          onTap: () {
            setState(() {
              _selectedBin = document['tID'];
            });
          },
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (context) {
                return EditPage();
              }));
            },
          ),
          isThreeLine: true,
        ),
      ],
    );
  }
}



