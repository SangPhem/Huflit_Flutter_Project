import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:med_app/network/api/url_api.dart';
import 'package:med_app/network/model/pref_profile_model.dart';
import 'package:med_app/network/model/product_model.dart';
import 'package:med_app/pages/cart_pages.dart';
import 'package:med_app/pages/detail_product.dart';
import 'package:med_app/pages/search_product.dart';
import 'package:med_app/theme.dart';
import 'package:med_app/widget/card_category.dart';
import 'package:med_app/widget/card_product.dart';
import 'package:med_app/widget/button_primary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrescriptionPages extends StatefulWidget {
  @override
  _PrescriptionPagesState createState() => _PrescriptionPagesState();
}

class _PrescriptionPagesState extends State<PrescriptionPages> {
  int? index;
  bool filter = false;

  List<ProductModel> listProductPrescription = [];

  Future<List<ProductModel>> getProductPrescription() async {
    List<ProductModel> productList = [];
    var urlProductPrescription = Uri.parse(BASEURL.getProductPrescription);
    final response = await http.get(urlProductPrescription);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (Map product in data) {
        productList.add(ProductModel.fromJson(product));
      }
    }
    return productList;
  }

  String? userID;

  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUSer);
    });
  }

  var QuantityCart = "0";

  totalCart() async {
    var urlGetTotalCart = Uri.parse(BASEURL.getTotalCart + userID!);
    final response = await http.get(urlGetTotalCart);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String Quantity = data['Quantity'];
      setState(() {
        QuantityCart = Quantity;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    getProductPrescription();
    totalCart();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<ProductModel>> filteredProductsFuture =
        getProductPrescription();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(24, 30, 24, 30),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/healthlogo.png',
                      width: 120,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Tìm kiếm thuốc hoặc\nvitamin với MedCare!",
                      style: regulerTextStyle.copyWith(
                        fontSize: 15,
                        color: greyBoldColor,
                      ),
                    )
                  ],
                ),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPages(totalCart),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.cyan,
                      ),
                    ),
                    QuantityCart == "0"
                        ? SizedBox()
                        : Positioned(
                            right: 10,
                            top: 10,
                            child: Container(
                              height: 13,
                              width: 13,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  QuantityCart,
                                  style: regulerTextStyle.copyWith(
                                    color: whiteColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchProduct(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 228, 255, 255),
                ),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.cyan,
                    ),
                    hintText: "Tìm kiếm ...",
                    hintStyle: regulerTextStyle.copyWith(
                      color: Colors.cyan,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              "Danh mục thuốc theo đơn",
              style: regulerTextStyle.copyWith(fontSize: 16),
            ),
            SizedBox(
              height: 32,
            ),
            FutureBuilder<List<ProductModel>>(
              future: filteredProductsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<ProductModel> filteredProducts = snapshot.data!;
                  return GridView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: filteredProducts.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, i) {
                      final product = filteredProducts[i];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailProduct(product),
                            ),
                          );
                        },
                        child: CardProduct(
                          nameProduct: product.nameProduct,
                          imageProduct: product.imageProduct,
                          price: product.price,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
