import 'package:flutter/material.dart';
import 'package:farmerica/Providers/CartProviders.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:farmerica/ui/CartPage.dart';
import 'package:farmerica/ui/productDetails.dart';
import 'package:farmerica/ui/widgets/component.dart';
import 'package:provider/provider.dart';
import 'package:farmerica/models/global.dart' as Globals;


class ProductsHorizontal extends StatefulWidget {
  final List<Product> product;
  ProductsHorizontal({this.product});

  @override
  _ProductsHorizontalState createState() => _ProductsHorizontalState();
}

class _ProductsHorizontalState extends State<ProductsHorizontal> {
  // int selected = 1;
  // String title = "";
  int addtoCart = 0;
  bool loa = false;
  List<Product> cart = [];
  List<Product> product = [];
  Api_Services api_services = Api_Services();
  List<Product> response;

  getList() async {
    response = await api_services.getProducts(45);
    product = response;
    setState(()  {
      // print('objectCard: $cart');
      // print('objectCard: ${product.sublist(20)}');
      // cart = response; //.sublist(20);
    });
  }

  @override
  void initState() {
    setState(() {
      getList();
      cart = response;  //.sublist(9);
    });
    // print('objectCard: $cart');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('productHorizontal: ${cart.length}');
    // print('productHorizontal: ${response.toList().toString()}');
    if (product == []) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // loa ? cart = product.sublist(9) : null;
      return ListView.builder(
          itemCount: cart.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int id) {
            // print('cart.length: ${cart.length}');
            var width = MediaQuery.of(context).size.width;
            cart = product;  //.sublist(9);
            // print('subList: ${product.sublist(9).toList()}');

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
                          // width: width * 0.30,
                          height: width * 0.22,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  cart[id].images[0].src ?? 'https://www.farmerica.in/wp-content/uploads/2023/01/ae-1-2048x2048.jpg'

                                  // width: width * 0.3,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          cart[id].name,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: new TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "₹" + cart[id].price.toString(),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(fontSize: 12),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       addtoCart = 1;
                        //     });
                        //
                        //     Provider.of<CartModel>(context, listen: false)
                        //         .addCartProduct(cart[id].id, 1);
                        //     Fluttertoast.showToast(
                        //         msg:
                        //             "${cart[id].name} successfully added to cart",
                        //         toastLength: Toast.LENGTH_SHORT,
                        //         gravity: ToastGravity.BOTTOM,
                        //         timeInSecForIosWeb: 1,
                        //         backgroundColor: Colors.black,
                        //         textColor: Colors.white,
                        //         fontSize: 16.0);
                        //   },
                        //   // padding: EdgeInsets.all(10),
                        //   child: new Text(
                        //     "View",
                        //     style: TextStyle(fontSize: 15),
                        //   ),
                        //   // color: Colors.blueAccent,
                        //   // textColor: Colors.white,
                        // )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetail(
                                product: cart[id],
                              )));
                });
          });
    }
  }
}
//
