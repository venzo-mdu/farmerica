import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/Config.dart';
import 'package:farmerica/models/Category.dart';
import 'package:farmerica/models/ParentCategory.dart' as p;
import 'package:farmerica/models/ParentCategory.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/networks/Authorization.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/Recommendedforyou.dart';

import 'package:farmerica/ui/gertProductfromapi.dart';
import 'package:farmerica/ui/grocery.dart';
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
                                builder: (context) =>
                                    Grocery(
                                      product: response, // widget.product,
                                    )));
                      }
                      if (i == 3) {
                        var response = await api_services.getProducts(86);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Grocery(
                                      product: response, // widget.product,
                                    )));
                      }
                    },
                    child: Container(
                      height: width * 0.18,
                      child: ListTile(
                        leading:CachedNetworkImage(
                          height: width * 0.18,
                          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png',
                          placeholder: (context, url) =>const Center(child: CircularProgressIndicator(color: Color(0xff3a9046),)),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fadeOutDuration: const Duration(milliseconds: 300),
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                        // leading: Image.network(
                        //   // category.image.src.toString() ??
                        //   'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png',
                        //   height: width * 0.18,
                        // ),
                        title: Text(
                          categoryView[i],
                          style: TextStyle(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ),
                  );
                },
              ),
            ),
          );
  }
}
