import 'package:flutter/material.dart';
import 'package:Farmerica/Providers/CartProviders.dart';
import 'package:Farmerica/models/Products.dart';
import 'package:Farmerica/ui/BasePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Farmerica/ui/CartPage.dart';
import 'package:Farmerica/ui/productDetails.dart';
import 'package:Farmerica/ui/widgets/component.dart';
import 'package:provider/provider.dart';

class Products extends BasePage {
  Products({this.product});

  List<Product> product;

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends BasePageState<Products> {
  int selected = 1;
  String title = "aa";
  int addtoCart = 0;
  // BasePage basePage = BasePage();
  @override
  void initState() {
    super.initState();
    // BasePage(
    //   selected: 2,
    //   title: "Checkout Page",
    // );
  }

  @override
  Widget body(BuildContext context) {
    List<Product> product = widget.product;
    List<Product> cart = [];

    return product.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: ListView.builder(
                          itemCount: widget.product.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int id) {
                            var width = MediaQuery.of(context).size.width;
                            var price = (product[id].price);
                            var sale = (product[id].salePrice);

                            return GestureDetector(
                                child: Container(
                                  width: width * 0.5,
                                  color: Colors.white,
                                  child: Card(
                                    child: new Container(
                                      padding:
                                          new EdgeInsets.all(width * 0.025),
                                      child: new Column(children: <Widget>[
                                        new Stack(
                                          children: <Widget>[
                                            Container(
                                              width: width * 0.30,
                                              height: width * 0.26,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                      product[id].images[0].src,

                                                      // width: width * 0.3,
                                                    )),
                                              ),
                                            ),
                                            new Container(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              decoration: new BoxDecoration(
                                                  border: new Border.all(
                                                      color: Colors.lightGreen,
                                                      width: width * 0.003),
                                                  color:
                                                      Colors.lightGreen[100]),
                                              child: new Text(
                                                "50" + "% OFF",
                                                style: new TextStyle(
                                                    fontSize: width * 0.02),
                                              ),
                                            ),
                                          ],
                                        ),
                                        new Text(
                                          product[id].name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: new TextStyle(
                                              fontSize: width * 0.045),
                                        ),
                                        new Container(
                                          padding: new EdgeInsets.only(
                                              top: width * 0.022),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Text(
                                                "₹" +
                                                    product[id]
                                                        .salePrice
                                                        .toString(),
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: width * 0.05),
                                              ),
                                              (price == sale)
                                                  ? new Text("")
                                                  : Padding(
                                                      padding:
                                                          new EdgeInsets.all(
                                                              width * 0.022),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        new Container(
                                            padding: new EdgeInsets.only(
                                                top: width * 0.022),
                                            child: new Row(
                                              children: <Widget>[
                                                new Expanded(
                                                    child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addtoCart = 1;
                                                    });

                                                    // Provider.of<CartModel>(
                                                    //         context,
                                                    //         listen: false)
                                                    //     .addCartProduct(
                                                    //         product[id].id, 1);
                                                    // Fluttertoast.showToast(
                                                    //     msg:
                                                    //         "${product[id].name} successfully added to cart",
                                                    //     toastLength:
                                                    //         Toast.LENGTH_SHORT,
                                                    //     gravity:
                                                    //         ToastGravity.BOTTOM,
                                                    //     timeInSecForIosWeb: 1,
                                                    //     backgroundColor:
                                                    //         Colors.black,
                                                    //     textColor: Colors.white,
                                                    //     fontSize: 16.0);
                                                  },
                                                  child:
                                                      new Text("View"),
                                                  // color: Colors.blueAccent,
                                                  // textColor: Colors.white,
                                                ))
                                              ],
                                            )),
                                      ]),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetail(
                                                product: product[id],
                                              )));
                                });
                          }))
                ]));
  }
}
//
