import 'package:flutter/material.dart';
import 'package:med_app/network/model/pref_profile_model.dart';
import 'package:med_app/pages/login_page.dart';
import 'package:med_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePages extends StatefulWidget {
  @override
  _ProfilePagesState createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> {
  String? fullName, createdDate, phone, email, address;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      fullName = sharedPreferences.getString(PrefProfile.name);
      createdDate = sharedPreferences.getString(PrefProfile.cretedAt);
      phone = sharedPreferences.getString(PrefProfile.phone);
      email = sharedPreferences.getString(PrefProfile.email);
      address = sharedPreferences.getString(PrefProfile.address);
    });
  }

  signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(PrefProfile.idUSer);
    sharedPreferences.remove(PrefProfile.name);
    sharedPreferences.remove(PrefProfile.email);
    sharedPreferences.remove(PrefProfile.phone);
    sharedPreferences.remove(PrefProfile.address);
    sharedPreferences.remove(PrefProfile.cretedAt);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPages()),
        (route) => false);
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Profile",
                  style: regulerTextStyle.copyWith(fontSize: 25),
                ),
                InkWell(
                  onTap: () {
                    signOut();
                  },
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.cyan,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName.toString(),
                  style: boldTextStyle.copyWith(fontSize: 18),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Tham gia vào " + createdDate.toString(),
                  style: lightTextStyle,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: whiteColor,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Số điện thoại",
                  style: lightTextStyle,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  phone.toString(),
                  style: boldTextStyle.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email",
                  style: lightTextStyle,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  email.toString(),
                  style: boldTextStyle.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: whiteColor,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Địa chỉ",
                  style: lightTextStyle,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  address.toString(),
                  style: boldTextStyle.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
