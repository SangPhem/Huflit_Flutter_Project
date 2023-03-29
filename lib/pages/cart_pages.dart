import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:med_app/network/api/url_api.dart';
import 'package:med_app/network/model/cart_model.dart';
import 'package:med_app/network/model/pref_profile_model.dart';
import 'package:med_app/theme.dart';
import 'package:med_app/widget/button_primary.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class CartPages extends StatefulWidget {
  
  @override 
 _CartPagesState createState() => _CartPagesState();
}

class _CartPagesState extends State<CartPages> {
  String? userID,fullname,address,phone;
  int delivery = 0;
  getPref() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUSer);
      fullname = sharedPreferences.getString(PrefProfile.name);
      address = sharedPreferences.getString(PrefProfile.address);
      phone = sharedPreferences.getString(PrefProfile.phone); 
    }); 
    getCart();
  }

  List<CartModel> listCart = [];
  getCart() async{
    listCart.clear();
    var urlGetCart = Uri.parse(BASEURL.getProductCart + userID!);
    final response = await http.get(urlGetCart);
    if (response.statusCode == 200 ){
      setState(() {
          final data = jsonDecode(response.body);
            for(Map item in data)
            {
              listCart.add(CartModel.fromJson(item));
            }
      });
      print(listCart[0].name);
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
        floatingActionButton: Container(
        padding: EdgeInsets.all(24),
        height: 220,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xfffcfcfc),
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30))),
          child: Column(children: [
            Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tổng cộng",
                style: regulerTextStyle.copyWith(fontSize: 16, color: greyBoldColor),
                ),
                  Text("VND 1800",
                style: boldTextStyle.copyWith(fontSize: 16),
                ),
              ],   
            ),
            SizedBox(
              height: 16),
            Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Phí vận chuyển",
                style: regulerTextStyle.copyWith(fontSize: 16, color: greyBoldColor),
                ),
                  Text(
                    delivery == 0 ? "Miễn Phí" : delivery as String,
                style: regulerTextStyle.copyWith(fontSize: 16),
                ),
              ],   
            ),
                        SizedBox(
              height: 16),
            Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tổng Tiền",
                style: regulerTextStyle.copyWith(fontSize: 16, color: greyBoldColor),
                ),
                  Text(
                    delivery == 0 ? "Miễn Phí" : delivery as String,
                style: boldTextStyle.copyWith(fontSize: 16),
                ),
              ],   
            ),
            SizedBox(
               height: 30
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ButtonPrimary(text: "Thanh Toán", onTap: (){}),
            )
          ],
        ),
      ),
      body: SafeArea(
        child:ListView(
          padding: EdgeInsets.only(bottom: 220),
      children: [
         Container( padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                  height: 70,child: Row(
                  children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,size: 32,color: greenColor,
                    ),
                  ),
                  SizedBox(width: 30,
                  ),
                  Text(
                  "Giỏ Hàng",
                  style: regulerTextStyle.copyWith(fontSize: 25),)
                  ])),
                  SizedBox(height: 24),
                  Container(padding:EdgeInsets.all(24) ,height: 166,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Thông tin",
                      style: regulerTextStyle.copyWith(fontSize: 20),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                        children: [
                         Text("Tên ",
                      style: regulerTextStyle.copyWith(fontSize: 16, color: greyBoldColor),
                      ),
                        Text("$fullname ",
                      style: regulerTextStyle.copyWith(fontSize: 16),
                      ),
                    ],          
                  ),
                  SizedBox(height: 8,
                  ),
                    Row(
                        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                        children: [
                         Text("Địa chỉ ",
                      style: regulerTextStyle.copyWith(fontSize: 16, color: greyBoldColor),
                      ),
                        Text("$address",
                      style: regulerTextStyle.copyWith(fontSize: 16),
                      ),
                    ],   
                  ),
                  SizedBox(height: 8,
                  ),
                    Row(
                        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                        children: [
                         Text("Số điện thoại ",
                      style: regulerTextStyle.copyWith(fontSize: 16, color: greyBoldColor),
                      ),
                        Text("$phone",
                      style: regulerTextStyle.copyWith(fontSize: 16),
                      ),
                    ],   
                  ),
                ], 
              )
            ),
            ListView.builder(
              itemCount: listCart.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context,i){
              final x = listCart[i];
              return Container(padding: EdgeInsets.all(24),
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
                    style: regulerTextStyle.copyWith(fontSize: 16),
                    ),
                    Row(children: [
                      IconButton(
                        icon: Icon(Icons.add_circle, 
                        color: greenColor
                        ), 
                        onPressed: (){}),
                        Text(x.quantity as String),
                        IconButton(
                        icon: Icon(
                          Icons.remove_circle, 
                          color: Color(0xfff0997a)
                        ), 
                        onPressed: (){}),
                     ],
                    ),
                    Text(x.price as String,style: boldTextStyle.copyWith(fontSize: 16),
                    )
                  ],
                  ),
                )
              ],
              ),
              Divider()
            ],
          )
        );
            })
      ],
    )),);
  }
}