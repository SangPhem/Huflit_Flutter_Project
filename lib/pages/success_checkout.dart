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
            title: "Đơn đặt hàng của bạn đã thành công",
            subtitle1: "Hãy tham khảo ý kiến sĩ,",
            subtitle2: "Bất kì ở đâu và nơi đâu",
          ),
          SizedBox(
            height: 30,
          ),
          ButtonPrimary(
            text: "QUAY VỀ TRANG CHỦ",
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
