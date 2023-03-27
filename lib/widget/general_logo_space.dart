import 'package:flutter/material.dart';

class GeneralLogoSpace extends StatelessWidget {
  final Widget? child;
  GeneralLogoSpace({this.child});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Image.asset(
            "assets/healthlogo.png",
            width: 100,
          ),
          child ?? SizedBox()
        ],
      ),
    );
  }
}
