import 'package:flutter/material.dart';
import 'package:farmerica/Providers/CartProviders.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:farmerica/ui/CartPage.dart';
import 'package:farmerica/ui/gridViewList.dart';
import 'package:farmerica/ui/productDetails.dart';
import 'package:farmerica/ui/widgets/component.dart';
import 'package:provider/provider.dart';

class Grocery extends StatefulWidget {
  Grocery({this.product});

  List<Product> product;

  @override
  State<Grocery> createState() => _GroceryState();
}

class _GroceryState extends State<Grocery> {
  int selected = 1;
  String title = "aa";
  int addtoCart = 0;
  var isSelectedDropDown;
  bool isDropDown = false;
  // BasePage basePage = BasePage();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> product = widget.product;

    List dummyProduct = product;
    lowToHigh() {
      for (int i = 0; i < dummyProduct.length - 1; i++){
        for (int j = 0; j < dummyProduct.length - i -1; j++){
          // print('dummyProductPrice: ${double.parse((dummyProduct[j].price))}');
          // print('dummyProductPriceType: ${double.parse((dummyProduct[j].price)).runtimeType}');
          if (double.parse((dummyProduct[j].price)) > double.parse(dummyProduct[j+1].price)) {
            // print('insideSwap:');

            var temp = dummyProduct[j];
            dummyProduct[j] = dummyProduct[j+1];
            dummyProduct[j+1] = temp;
            // print('temp: $temp');
          }
        }
      }
      // print('calling GridList53:${dummyProduct.length}');
      // print('objectDummyProduct: ${dummyProduct.length}');
      for(int i =0; i<dummyProduct.length; i++) {
        // print('objectDummyProduct: ${dummyProduct[i].price.toString()}');
      }
      GridViewList(product: dummyProduct);
    }

    highToLow() {
      // List dummyProduct = product;
      // print('dummyProduct: $dummyProduct');

      for (int i = 0; i < dummyProduct.length - 1; i++){
        for (int j = 0; j < dummyProduct.length - i -1; j++){
          // print('dummyProductPrice: ${double.parse((dummyProduct[j].price))}');
          // print('dummyProductPriceType: ${double.parse((dummyProduct[j].price)).runtimeType}');
          if (double.parse((dummyProduct[j].price)) < double.parse(dummyProduct[j+1].price)) {
            var temp = dummyProduct[j];

            dummyProduct[j] = dummyProduct[j+1];
            dummyProduct[j+1] = temp;
            // print('temp: $temp');
          }
        }
      }
      // print('calling GridList75:${dummyProduct.length}');

      // print('objectDummyProduct: ${dummyProduct.length}');
      // print('objectDummyProduct: ${dummyProduct[0].price.toString()}');
      GridViewList(product: dummyProduct);
    }

    latest() {
      // List dummyProduct = product;
      // print('CallingLatest: $dummyProduct');
      for (int i = 0; i < dummyProduct.length - 1; i++){
        for (int j = 0; j < dummyProduct.length - i -1; j++){
          // print('dummyProductPrice: ${double.parse((dummyProduct[j].price))}');
          // print('dummyProductPriceType: ${double.parse((dummyProduct[j].dateModified)).runtimeType}');
          // if (dummyProduct[j].dateModified < dummyProduct[j+1].dateModified) {
          if(dummyProduct[j].dateModified.compareTo(dummyProduct[j+1].dateModified) < 0) {
            // print('callingLastestInsideIf');
            var temp = dummyProduct[j];

            dummyProduct[j] = dummyProduct[j+1];
            dummyProduct[j+1] = temp;
            // print('temp: $temp');
          }
        }
      }
      // print('calling GridList75:${dummyProduct.length}');

      // print('objectDummyProduct: ${dummyProduct.length}');
      // print('objectDummyProduct: ${dummyProduct[0].price.toString()}');
      GridViewList(product: dummyProduct);
    }

    return product == []
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xff00ab55),
              centerTitle: true,
              title: Image.network(
                'https://www.farmerica.in/wp-content/uploads/2023/01/farmerica-logo.png',
                color: Colors.white,
              ),
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Showing all ${widget.product.length} products',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'OutFit',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        DropdownButton(
                          hint: const Text("Please select value",
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'OutFit',
                                fontWeight: FontWeight.w500,
                              )
                          ),
                          value: isSelectedDropDown,
                          items: <String>[
                            'Sort by Latest',
                            'Sort by Low to High',
                            'Sort by High to Low',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'OutFit',
                                    fontWeight: FontWeight.w400,
                                  ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              // print('isSelectedDropDown: $isSelectedDropDown');
                              // print('isSelectedDropDown: ${isSelectedDropDown.runtimeType}');
                              // print('isSelectedDropDown: $value');
                              isSelectedDropDown = value;
                              if(value == 'Sort by Low to High') {
                                setState(() {
                                  lowToHigh();
                                  // isDropDown=true;
                                  // print('isDropDown: $isDropDown');
                                });
                              } else if(value == 'Sort by High to Low') {
                                setState(() {
                                  highToLow();
                                  // isDropDown=false;
                                  // print('isDropDown: $isDropDown');
                                });
                              } else {
                                setState(() {
                                  latest();
                                });

                              }
                            });
                          },
                        )
                      ],
                    ),
                    GridViewList(product: product)
                  ],
                ),
              ),
            ),

          );
  }
}

