import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Farmerica/Config.dart';
import 'package:Farmerica/models/Category.dart';
import 'package:Farmerica/models/ParentCategory.dart' as p;
import 'package:Farmerica/models/ParentCategory.dart';
import 'package:Farmerica/models/Products.dart';
import 'package:Farmerica/networks/ApiServices.dart';
import 'package:Farmerica/networks/Authorization.dart';
import 'package:Farmerica/ui/BasePage.dart';
import 'package:Farmerica/ui/Recommendedforyou.dart';

import 'package:Farmerica/ui/gertProductfromapi.dart';
import 'package:Farmerica/ui/grocery.dart';
import 'package:http/http.dart' as http;

class CategoryPage extends BasePage {
  final catergories;
  final product;
  var imageURL;
  CategoryPage({
    this.catergories,
    this.product,
    this.imageURL,
  });

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends BasePageState<CategoryPage> {
  /** */
  Api_Services api_services = Api_Services();
  BasePage basePage = BasePage();
  List<String> categoryView = [
    'Fruits',
    'Vegetable',
    'Salad',
    'Our Farm Product',
  ];

  List<String> categoryImageView = ['assets/images/fruits.png', 'assets/images/vegetable.png', 'assets/images/salad.png', 'assets/images/farm.png'];

  @override
  void initState() {
    super.initState();
  }

  int selected = 2;
  String title = "Categories";
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    List<p.ParentCategory> catergories = widget.catergories;
    return catergories.length == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.all(3),
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: categoryView.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () async {
                      if (i == 0) {
                        var response = await api_services.getProducts(45);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Grocery(
                                      product: response, //widget.product,
                                    )));
                      }
                      if (i == 1) {
                        var response = await api_services.getProducts(68);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Grocery(
                                      product: response, //widget.product,
                                    )));
                      }
                      if (i == 2) {
                        var response = await api_services.getProducts(85);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Grocery(
                                      product: response, // widget.product,
                                    )));
                      }
                      if (i == 3) {
                        var response = await api_services.getProducts(86);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Grocery(
                                      product: response, // widget.product,
                                    )));
                      }
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                              // color: Colors.grey,
                              // height: width * 0.18,
                              child: ListTile(
                            leading: Image.asset(
                              categoryImageView[i],
                            ),
                            title: Text(
                              categoryView[i],
                              style: TextStyle(fontSize: width * 0.04, fontFamily: 'Outfit', fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                          )),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }
}
