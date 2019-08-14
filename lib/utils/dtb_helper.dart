import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:smartbin2/models/userid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String userTable = 'user_table';
  String colID = 'uID';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {

    _databaseHelper = DatabaseHelper._createInstance();

    return _databaseHelper;
  }

  Future<Database> get database async {

    if(_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

//  final Future<Database> database = openDatabase(
//    // Set the path to the database. Note: Using the `join` function from the
//    // `path` package is best practice to ensure the path is correctly
//    // constructed for each platform.
//    join(getDatabasesPath().toString(), 'user.db'),
//    onCreate: (db, version) {
//      return db.execute(
//          'CREATE TABLE $userTable($colID INTERGER PRIMARY KEY)'
//      );
//    }
//  );

  Future<Database> initializeDatabase() async {
    //get directory path for both android & ios to store data
//    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(getDatabasesPath().toString(), 'user.db') ;

    //open/create dtb at a given path
    var userDTB = await openDatabase(path, version: 1, onCreate: _createDb);
    return userDTB;
  }

  void _createDb(Database db, int newVersion) async {
    print('create new user when first time run app');

    await db.execute('CREATE TABLE $userTable($colID INTERGER PRIMARY KEY)');
    String newID = await addDataFireStore();
//    print(newID);

    User thisUser = User(newID);
    db.insert(userTable, thisUser.toMap());
//    await insertUser(thisUser);

  }

  //fetch operation
  getUserMapList() async {
    Database db = await this.database;
//    var result = await db.rawQuery('SELECT * FROM $userTable');
    var result = await db.query(userTable);
    return result;
  }

  //insert
  Future<int> insertUser(User user) async {
    Database db = await this.database;
    var result = await db.insert(userTable, user.toMap());
    return result;
  }

  Future<String> addDataFireStore () async {
    String lastID, newID;
    //get last user id
    await Firestore.instance.collection('users')
        .orderBy('uID', descending: true).limit(1).getDocuments().then((driver) {
      lastID = driver.documents[0].data['uID'];
    });

    //set new id
    newID = generateNewDriverID(lastID);

    //listen if have changes
    var streamSub = Firestore.instance.collection('users')
        .orderBy('uID', descending: true).limit(1).snapshots().listen((driver){
      lastID = driver.documents[0]['uID'];
      newID = generateNewDriverID(lastID);
    });

    Firestore.instance.runTransaction((transaction) async{
      await transaction.set(Firestore.instance.collection("users").document(newID), {
        'uID' : newID,
      });
    }).then((data){
      streamSub.cancel();
    });

    return newID;
  }

  String generateNewDriverID(String lastID) {
    //generate new id
    String idCounter = (int.parse(lastID.substring(3)) + 1).toString();
    while(idCounter.length < 4) {
      idCounter = '0' + idCounter;
    }
    String newID = 'U' + idCounter;

    return newID;
  }

  Future<User> getUser() async {
//    await deleteDatabase(join(getDatabasesPath().toString(), 'user.db'));
//    print('deleted');
//    User thisUser = User('U0003');
//    await insertUser(thisUser);
//    print('get user here');
    var userMap = await getUserMapList();
//    print('1111');
//    print(User.fromMapObject(userMap[0]).uID);

//    for(int i = 0; i < userMap.length; i++) {
//      print(User.fromMapObject(userMap[i]).uID);
//    }
    return User.fromMapObject(userMap[0]);
  }



}