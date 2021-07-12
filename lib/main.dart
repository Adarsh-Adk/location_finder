import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_finder/Screens/HomeScreen/HomeScreen.dart';

import 'Constants/CTheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: CTheme.darkTheme,
      theme: CTheme.lightTheme,
      home: HomeScreen(),
    );
  }
}

