import 'package:flutter/material.dart';
import 'ListPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
//          caption: TextStyle(
//              fontSize: 22.0
//          ),
          body1: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        primarySwatch: Colors.blue,
      ),
      home: TrashBinList(),
    );
  }

}
