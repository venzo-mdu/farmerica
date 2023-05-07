import 'package:flutter/material.dart';
import 'package:Farmerica/models/Products.dart';
import 'package:Farmerica/ui/gridViewList.dart';

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
      for (int i = 0; i < dummyProduct.length - 1; i++) {
        for (int j = 0; j < dummyProduct.length - i - 1; j++) {
          if (double.parse((dummyProduct[j].price)) > double.parse(dummyProduct[j + 1].price)) {
            var temp = dummyProduct[j];
            dummyProduct[j] = dummyProduct[j + 1];
            dummyProduct[j + 1] = temp;
          }
        }
      }
      for (int i = 0; i < dummyProduct.length; i++) {}
      GridViewList(product: dummyProduct);
    }

    highToLow() {
      for (int i = 0; i < dummyProduct.length - 1; i++) {
        for (int j = 0; j < dummyProduct.length - i - 1; j++) {
          if (double.parse((dummyProduct[j].price)) < double.parse(dummyProduct[j + 1].price)) {
            var temp = dummyProduct[j];
            dummyProduct[j] = dummyProduct[j + 1];
            dummyProduct[j + 1] = temp;
          }
        }
      }
      GridViewList(product: dummyProduct);
    }

    latest() {
      for (int i = 0; i < dummyProduct.length - 1; i++) {
        for (int j = 0; j < dummyProduct.length - i - 1; j++) {
          if (dummyProduct[j].dateModified.compareTo(dummyProduct[j + 1].dateModified) < 0) {
            var temp = dummyProduct[j];
            dummyProduct[j] = dummyProduct[j + 1];
            dummyProduct[j + 1] = temp;
          }
        }
      }
      GridViewList(product: dummyProduct);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff00ab55),
        centerTitle: true,
        title: Image.asset(
          'assets/images/farmerica-logo.png',
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: product == []
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                            fontSize: 13,
                            fontFamily: 'OutFit',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        DropdownButton(
                          hint: const Text("Sort",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'OutFit',
                                fontWeight: FontWeight.w500,
                              )),
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
                                  fontSize: 13,
                                  fontFamily: 'OutFit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              isSelectedDropDown = value;
                              if (value == 'Sort by Low to High') {
                                setState(() {
                                  lowToHigh();
                                });
                              } else if (value == 'Sort by High to Low') {
                                setState(() {
                                  highToLow();
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
