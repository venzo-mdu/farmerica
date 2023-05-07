import 'package:flutter/material.dart';
import 'package:Farmerica/Providers/CartProviders.dart';
import 'package:Farmerica/models/Products.dart';
import 'package:Farmerica/ui/BasePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Farmerica/ui/CartPage.dart';
import 'package:Farmerica/ui/productDetails.dart';
import 'package:Farmerica/ui/widgets/component.dart';
import 'package:provider/provider.dart';

class Recommendations extends StatefulWidget {
  final List<Product> product;
  Recommendations({this.product});

  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  int selected = 1;
  String title = "";
  int addtoCart = 0;
  List<Product> product = [];
  getList() {
    product = widget.product;
  }

  @override
  void initState() {
    getList();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("am+${product.toString()}");
    if (product == null) {
      // print('products: $product');
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // print(product);
      return ListView.builder(
          itemCount: product.length - 13,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int id) {
            var width = MediaQuery.of(context).size.width;
            return GestureDetector(
                child: Container(
                  width: width * 0.4,
                  // height: 500,
                  color: Colors.white,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          //width: width * 0.30,
                          height: width * 0.22,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                  product[id].images[0].src,

                                  // width: width * 0.3,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          product[id].name,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: new TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        new Text(
                          "₹" + '1500',//product[id].salePrice.toString(),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: new TextStyle(fontSize: 12),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              addtoCart = 1;
                            });

                            Provider.of<CartModel>(context, listen: false)
                                .addCartProduct(
                              product[id].id, 1,
                                widget.product[id].name,
                                widget.product[id].price,
                                widget.product[id].images[0].src,
                            );
                            Fluttertoast.showToast(
                                msg:
                                    "${product[id].name} successfully added to cart",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                          // padding: EdgeInsets.all(10),
                          child: new Text(
                            "View",
                            style: TextStyle(fontSize: 15),
                          ),
                          // color: Colors.blueAccent,
                          // textColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  // print('productRate: ${product[id].salePrice}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetail(
                                product: product[id],
                              )));
                });
          });
    }
  }
}
//
