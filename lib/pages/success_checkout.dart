import 'package:flutter/material.dart';
import 'package:med_app/main_page.dart';
import 'package:med_app/widget/button_primary.dart';
import 'package:med_app/widget/general_logo_space.dart';
import 'package:med_app/widget/widget_illustration.dart';

class SuccessCheckout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GeneralLogoSpace(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(24),
        children: [
          SizedBox(
            height: 80,
          ),
          WidgetIllustration(
            image: "assets/order_success_ilustration.png",
            title: "Yeay, your order was successfully",
            subtitle1: "Consult with a doctor,",
            subtitle2: "Wherever and whenever you are",
          ),
          SizedBox(
            height: 30,
          ),
          ButtonPrimary(
            text: "BACK TO HOME",
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainPages()),
                  (route) => false);
            },
          )
        ],
      ),
    ));
  }
}
