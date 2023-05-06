import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:med_app/network/model/product_model.dart';
import 'package:med_app/theme.dart';
import 'package:med_app/widget/widget_illustration.dart';

import '../network/api/url_api.dart';
import 'package:http/http.dart' as http;

import '../widget/card_product.dart';
import 'detail_product.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  TextEditingController searchController = TextEditingController();
  List<ProductModel> listProduct = [];
  List<ProductModel> listSearchProduct = [];

  getProduct() async {
    listProduct.clear();
    var urlProduct = Uri.parse(BASEURL.getProduct);
    final response = await http.get(urlProduct);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map product in data) {
          listProduct.add(ProductModel.fromJson(product));
        }
      });
    }
  }

  searchProduct(String text) {
    listSearchProduct.clear();
    if (text.isEmpty) {
      setState(() {});
    } else {
      listProduct.forEach((element) {
        if (element.nameProduct!.toLowerCase().contains(text)) {
          listSearchProduct.add(element);
        }
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 32,
                    color: Colors.cyan,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  width: MediaQuery.of(context).size.width - 100,
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 228, 255, 255)),
                  child: TextField(
                    onChanged: searchProduct,
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.cyan,
                        ),
                        hintText: "Tìm kiếm ...",
                        hintStyle:
                            regulerTextStyle.copyWith(color: Colors.cyan)),
                  ),
                ),
              ],
            ),
          ),
          searchController.text.isEmpty || listSearchProduct.length == 0
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
                  child: WidgetIllustration(
                    title: "Không có thuốc bạn đang tìm kiếm",
                    image: "assets/no_data_ilustration.png",
                    subtitle1: "Hãy tìm kiếm lại",
                    subtitle2: "\n",
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(24),
                  child: GridView.builder(
                      physics: ClampingScrollPhysics(),
                      itemCount: listSearchProduct.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16),
                      itemBuilder: (context, i) {
                        final y = listSearchProduct[i];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailProduct(y)));
                          },
                          child: CardProduct(
                            nameProduct: y.nameProduct,
                            imageProduct: y.imageProduct,
                            price: y.price,
                          ),
                        );
                      }),
                ),
        ],
      )),
    );
  }
}
