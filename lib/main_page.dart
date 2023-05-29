import 'package:flutter/material.dart';
import 'package:med_app/pages/history_page.dart';
import 'package:med_app/pages/home_page.dart';
import 'package:med_app/pages/prescription_page.dart';
import 'package:med_app/pages/profile_page.dart';
//import 'package:med_app/pages/message_page.dart';
import 'package:med_app/theme.dart';

class MainPages extends StatefulWidget {
  @override
  _MainPagesState createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  int _selectIndex = 0;

  final _pageList = [
    HomePages(),
    HistoryPages(),
    PrescriptionPages(),
    ProfilePages(),
  ];

  onTappedItem(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList.elementAt(_selectIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: "History"),
          BottomNavigationBarItem(
              icon: Icon(Icons.note), label: "Prescription"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box_rounded), label: "Profile"),
        ],
        currentIndex: _selectIndex,
        onTap: onTappedItem,
        unselectedItemColor: grey35Color,
        selectedItemColor: Colors.cyan,
      ),
    );
  }
}
