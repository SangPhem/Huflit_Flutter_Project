import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:med_app/main_page.dart';
import 'package:med_app/network/api/url_api.dart';
import 'package:med_app/network/model/cart_model.dart';
import 'package:med_app/network/model/pref_profile_model.dart';
import 'package:med_app/pages/success_checkout.dart';
import 'package:med_app/theme.dart';
import 'package:med_app/widget/button_primary.dart';
import 'package:med_app/widget/widget_illustration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class CartPages extends StatefulWidget {
  final VoidCallback method;
  CartPages(this.method);
  @override
  _CartPagesState createState() => _CartPagesState();
}

class _CartPagesState extends State<CartPages> {
  final price = NumberFormat("#,##0", "EN_US");
  String? userID, fullname, address, phone;
  int delivery = 0;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUSer);
      fullname = sharedPreferences.getString(PrefProfile.name);
      address = sharedPreferences.getString(PrefProfile.address);
      phone = sharedPreferences.getString(PrefProfile.phone);
    });
    getCart();
    cartTotalPrice();
  }

  List<CartModel> listCart = [];
  getCart() async {
    listCart.clear();
    var urlGetCart = Uri.parse(BASEURL.getProductCart + userID!);
    final response = await http.get(urlGetCart);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map item in data) {
          listCart.add(CartModel.fromJson(item));
        }
      });
      print(listCart[0].name);
    }
  }

  void refresh() {
    return getCart();
  }

  updateQuantity(String tipe, CartModel model) async {
    var urlUpdateQuantity = Uri.parse(BASEURL.updateQuantityProductCart);
    final respone = await http
        .post(urlUpdateQuantity, body: {"cartID": model, "tipe": tipe});
    final data = jsonDecode(respone.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      print(message);
      setState(() {
        getPref();
        widget.method();
      });
    } else {
      print(message);
      setState(() {
        getPref();
      });
    }
  }

  checkout() async {
    var urlCheckout = Uri.parse(BASEURL.checkout);
    final responne = await http.post(urlCheckout, body: {
      "idUser": userID,
    });
    final data = jsonDecode(responne.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SuccessCheckout()),
          (route) => false);
    } else {
      print(message);
    }
  }

  var sumPrice = "0";
  int totalPayment = 0;
  cartTotalPrice() async {
    var urlTotalPrice = Uri.parse(BASEURL.totalPriceCart + userID!);
    final response = await http.get(urlTotalPrice);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String total = data['Total'];
      setState(() {
        sumPrice = total;
        totalPayment = sumPrice == null ? 0 : int.parse(sumPrice) + delivery;
      });
      print(sumPrice);
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: listCart.length == 0
          ? SizedBox()
          : Container(
              padding: EdgeInsets.all(24),
              height: 220,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xfffcfcfc),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tổng cộng",
                        style: regulerTextStyle.copyWith(
                            fontSize: 16, color: greyBoldColor),
                      ),
                      Text(
                        "VND " + price.format(int.parse(sumPrice)),
                        style: boldTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Phí vận chuyển",
                        style: regulerTextStyle.copyWith(
                            fontSize: 16, color: greyBoldColor),
                      ),
                      Text(
                        delivery == 0 ? "Miễn Phí" : delivery as String,
                        style: regulerTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tổng Tiền",
                        style: regulerTextStyle.copyWith(
                            fontSize: 16, color: greyBoldColor),
                      ),
                      Text(
                        "VND " + price.format(totalPayment),
                        style: boldTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ButtonPrimary(
                        text: "Thanh Toán",
                        onTap: () {
                          checkout();
                        }),
                  )
                ],
              ),
            ),
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.only(bottom: 220),
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              height: 70,
              child: Row(children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 32,
                    color: greenColor,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  "Giỏ Hàng",
                  style: regulerTextStyle.copyWith(fontSize: 25),
                )
              ])),
          listCart.length == 0 || listCart.length == null
              ? Container(
                  padding: EdgeInsets.all(24),
                  margin: EdgeInsets.only(top: 30),
                  child: WidgetIllustration(
                    image: "assets/empty_cart_ilustration.png",
                    title: "Giỏ hàng trống",
                    subtitle1: "Giỏ hàng của bạn hiện không có vật phẩm nào, ",
                    subtitle2: "chọn vật phẩm từ MEDHEALTH",
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ButtonPrimary(
                        text: "MUA NGAY",
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPages()),
                              (route) => false);
                        },
                      ),
                    ),
                  ))
              : SizedBox(height: 24),
          Container(
              padding: EdgeInsets.all(24),
              height: 166,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thông tin",
                    style: regulerTextStyle.copyWith(fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tên ",
                        style: regulerTextStyle.copyWith(
                            fontSize: 16, color: greyBoldColor),
                      ),
                      Text(
                        "$fullname ",
                        style: regulerTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Địa chỉ ",
                        style: regulerTextStyle.copyWith(
                            fontSize: 16, color: greyBoldColor),
                      ),
                      Text(
                        "$address",
                        style: regulerTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Số điện thoại ",
                        style: regulerTextStyle.copyWith(
                            fontSize: 16, color: greyBoldColor),
                      ),
                      Text(
                        "$phone",
                        style: regulerTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              )),
          ListView.builder(
              itemCount: listCart.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, i) {
                final x = listCart[i];
                return Container(
                    padding: EdgeInsets.all(24),
                    color: whiteColor,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              x.image as String,
                              width: 170,
                              height: 120,
                            ),
                            Container(
                              width: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    x.name as String,
                                    style:
                                        regulerTextStyle.copyWith(fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.add_circle,
                                              color: greenColor),
                                          onPressed: () {
                                            updateQuantity("tambah", x);
                                          }),
                                      Text(x.quantity as String),
                                      IconButton(
                                          icon: Icon(Icons.remove_circle,
                                              color: Color(0xfff0997a)),
                                          onPressed: () {
                                            updateQuantity("kurang", x);
                                          }),
                                    ],
                                  ),
                                  Text(
                                    price.format(int.parse(x.price as String)),
                                    style: boldTextStyle.copyWith(fontSize: 16),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider()
                      ],
                    ));
              })
        ],
      )),
    );
  }
}
