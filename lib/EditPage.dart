import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:smartbin2/style.dart';


class EditPage extends StatefulWidget {
//  final String tID;
  final String uID;
  final binInfo;
  const EditPage({@required this.uID, @required this.binInfo});

  @override
  _EditPageState createState() => _EditPageState(uID, binInfo);
}

class _EditPageState extends State<EditPage> {

  String tID, uID;
  var binInfo;
  _EditPageState(this.uID, this.binInfo);

  File _image;

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
//  final _dateController = TextEditingController();
  final _memoController = TextEditingController();

  DocumentSnapshot bin;
  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
//    _dateController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  initState() {
    _nameController.text = binInfo['name'];
    _locationController.text = binInfo['location'];
//    _dateController.text = bin['idCard'];
    _memoController.text = binInfo['memo'];
    tID = binInfo['tID'];
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

  @override
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
/*
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
*/
  Widget build(BuildContext context) {
    print('reload');
    String name, location, memo;
//    Firestore.instance.collection('users')
//        .document(uID)
//        .collection('binList')
//        .where('tID', isEqualTo: tID).getDocuments()
//        .then((bin) {
//          _locationController.text = bin.documents[0]['location'];
////          _nameController.text = bin.documents[0]['name'];
//          _memoController.text = bin.documents[0]['memo'];
//        }
//        );

//    _nameController.text = binInfo['name'];
//    _locationController.text = binInfo['location'];
////    _dateController.text = bin['idCard'];
//    _memoController.text = binInfo['memo'];


    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(
            'Edit',
            style: appBarTxTStyle, textAlign: TextAlign.center,
          )),
        ),
        body: SingleChildScrollView(
          child: editAll()
        ),
//        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
    );

  }

  Widget editAll() {
    return Container(
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
                  'name' : _nameController.text,
                  'location' : _locationController.text,
//                    'date' : _dateController.text,
                  'memo' : _memoController.text,
                });
              }).then((data) {print("upl");})
              ;
              Navigator.of(context).pop();
            },
            child: Text('Save', style: buttonTxtStyle),
          ),

        ],
      ),
    );
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
    return Column(
        children: <Widget>[
          details('Name', _nameController),
          details('Location', _locationController),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween
    );
  }

  Widget details(field, controller) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      height: 55,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
            contentPadding: EdgeInsets.all(5.0),
            hintText: field),
        style: txtFieldStyle,
      ),
    );
  }

  Widget memoTextField() {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextField(
          controller: _memoController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: txtFieldStyle,
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