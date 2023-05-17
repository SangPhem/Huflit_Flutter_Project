import 'package:flutter/material.dart';
import 'package:med_app/pages/login_page.dart';

//import 'package:med_app/screens/welcome_screen.dart';
import 'package:med_app/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: greenColor),
      home: LoginPages(),
    );
  }
}
