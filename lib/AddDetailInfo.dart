import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:smartbin2/DetailPage.dart';

class AddInfo extends StatefulWidget {
  final String tID;
  final String uID;
  const AddInfo({@required this.tID, this.uID});
  @override
  AddInfoState createState() => AddInfoState(tID, uID);
}

class AddInfoState extends State<AddInfo> {
  String tID;
  String uID;
  AddInfoState(this.tID, this.uID);
  File _image;
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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Detail Information',
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
                ),
                RaisedButton(
                  onPressed: () {

                    Firestore.instance.runTransaction((transaction) async{
                      await transaction.update(Firestore.instance.collection('users')
                          .document(uID)
                          .collection('binList').document(tID), {
                        'name' : nameController.text,
                        'location' : locationController.text,
                        'date' : dateController.text,
                        'memo' : memoController.text,
                      });
                    }).then((data) {
                      print("upl");
                      showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: new Text(
                                  "Added successfully"),
                              actions: <Widget>[
                                new FlatButton(onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                    child: new Text("Close"))
                              ],
                            );
                          }
                      );
                    });

                  },
                  child: Text('Add'),
                ),
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
        child: Text(
          'Smart Trashbin $tID',
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
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Where do you want to get a picture?'),
                        content: Container(
                            height: 130, //later add
                            child: Column(
                              children: <Widget>[
                                RaisedButton(
                                  child: Text('Camera'),
                                  onPressed: () {
                                    getCameraImage();
                                  },
                                ),
                                RaisedButton(
                                  child: Text('My Galley'),
                                  onPressed: () {
                                    getGalleryImage();
                                  },
                                )
                              ],
                            )
                        ),
                      );
                    }
                );

              },
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


  getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }


  Widget addImage(){
    return AlertDialog(
      title: Text('Where do you want to get a picture?'),
      content: Container(
          height: null, //later add
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('Camera'),
                onPressed: () {
                  return getCameraImage();
                },
              ),
              RaisedButton(
                child: Text('My Galley'),
                onPressed: () {
                  return getGalleryImage();
                },
              )
            ],
          )
      ),
    );
  }

}