import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:med_app/network/api/url_api.dart';
// import 'package:med_app/network/api/url_api.dart';
import 'package:med_app/network/model/history_model.dart';
import 'package:med_app/network/model/pref_profile_model.dart';
import 'package:med_app/theme.dart';
import 'package:med_app/widget/card_history.dart';
import 'package:med_app/widget/widget_illustration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HistoryPages extends StatefulWidget {
  @override
  _HistoryPagesState createState() => _HistoryPagesState();
}

class _HistoryPagesState extends State<HistoryPages> {
  List<HistoryOrdelModel> list = [];
  String? userID;

  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUSer);
    });
    getHistory();
  }

  getHistory() async {
    list.clear();
    var urlHistory = Uri.parse(BASEURL.historyOrder + userID!);
    final response = await http.get(urlHistory);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map item in data) {
          list.add(HistoryOrdelModel.fromJson(item));
        }
        print(list[0]);
      });
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
      body: list.length == 0
          ? Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  WidgetIllustration(
                    image: "assets/no_history_ilustration.png",
                    subtitle1: "Bạn chưa có lịch sử đặt hàng ",
                    subtitle2: "Hãy Đặt hàng ngay",
                    title: "Oops,There are no history order",
                  ),
                ],
              ),
            )
          : SafeArea(
              child: ListView(children: [
                Container(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                    height: 70,
                    child: Text(
                      "Lịch sử",
                      style: regulerTextStyle.copyWith(fontSize: 25),
                    )),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final x = list[i];
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        child: CardHistory(
                          model: x,
                        ),
                      );
                    }),
              ]),
            ),
    );
  }
}
