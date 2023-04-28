import 'package:flutter/material.dart';
import 'package:farmerica/models/ParentCategory.dart' as pc;
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/ui/widgets/component.dart';

class Item extends StatefulWidget {
  final id;

  Item(this.id);

  @override
  State<StatefulWidget> createState() {
    return ItemState(id);
  }
}

class ItemState extends State<Item> {
  final id;
  List<Product> product;

  ItemState(this.id);
  int addtocart = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var price = (product[id].price) as int;
    var sale = (product[id].salePrice) as int;
    var off = ((price - sale) / price) * 100;
    return GestureDetector(
        child: Container(
          width: width * 0.5,
          child: Card(
            child: Container(
              padding: EdgeInsets.all(width * 0.025),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.network(
                        product[id].images[0].src,
                        width: width * 0.3,
                      ),
                      (price == sale)
                          ? Text("")
                          : Container(
                              padding: const EdgeInsets.all(3.0),
                              decoration:
                                  BoxDecoration(border: Border.all(color: Colors.lightGreen, width: width * 0.00625), color: Colors.lightGreen[100]),
                              child: Text(
                                off.round().toString() + "% OFF",
                                style: TextStyle(fontSize: width * 0.03),
                              ),
                            ),
                    ],
                  ),
                  Container(
                    height: width * 0.11,
                    child: Column(
                      children: <Widget>[
                        Text(
                          product[id].name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: width * 0.045),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    (product[id] as Map)[1]["quantity"],
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: width * 0.022),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "₹" + product[id].salePrice.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.05),
                        ),
                        (price == sale)
                            ? Text("")
                            : Padding(
                                padding: EdgeInsets.all(width * 0.022),
                              ),
                        (price == sale)
                            ? Text("")
                            : Container(
                                foregroundDecoration: StrikeThroughDecoration(),
                                child: Text(
                                  "₹" + (product[id] as Map)[1]["price"].toString(),
                                  style: TextStyle(fontSize: width * 0.05, color: Colors.grey),
                                ))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: width * 0.022),
                    child: 1 == 1
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                addtocart = 1;
                              });
                            },
                            child: Text("View"),
                            // color: Colors.blueAccent,
                            // textColor: Colors.white,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: width * 0.16,
                                child: ElevatedButton(
                                  onPressed: () => setState(() {
                                    addtocart = addtocart + 1;
                                  }),
                                  child: Text(
                                    "+",
                                    style: TextStyle(fontSize: width * 0.07),
                                  ),
                                  // color: Colors.blueAccent,
                                  // textColor: Colors.white,
                                ),
                              ),
                              Container(
                                width: width * 0.1,
                                child: Text(
                                  (addtocart.toString()),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: width * 0.16,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      addtocart = addtocart - 1;
                                    });
                                  },
                                  child: Text(
                                    "-",
                                    style: TextStyle(fontSize: width * 0.07),
                                  ),
                                  // color: Colors.blueAccent,
                                  // textColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          // Navigator.push(
          //     context,
          //      MaterialPageRoute(
          //         builder: (context) => ProductDetailsPage(id: id)));
        });
  }
}

class ProductsCategory extends StatefulWidget {
  ProductsCategory({this.heading, this.ids, this.product});
  final heading;
  final ids;
  List<pc.ParentCategory> product;
  int addtoCart = 0;

  @override
  _ProductsCategoryState createState() => _ProductsCategoryState();
}

class _ProductsCategoryState extends State<ProductsCategory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<pc.ParentCategory> product = widget.product;
    var width = MediaQuery.of(context).size.width;
    // var price = () as int;
    // var sale = (widget.product[id].salePrice) as int;
    // var off = ((price - sale) / price) * 100;
    var items = <Widget>[];
    items.add(Padding(
      padding: EdgeInsets.all(3.0),
    ));
    widget.product.forEach((id) => items.add(Item(id)));
    items.add(Padding(
      padding: EdgeInsets.all(3.0),
    ));
    return Scaffold(
        appBar: AppBar(
          title: Text(
            " All Product Category",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                      itemCount: widget.product.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int id) {
                        var width = MediaQuery.of(context).size.width;
                        // var price = (product[id].price);
                        // var sale = (product[id].salePrice);
                        //  var off = ((price + sale) / price) * 100;
                        return GestureDetector(
                            child: Container(
                              width: width * 0.5,
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(width * 0.025),
                                  child: Column(
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.lightGreen, width: width * 0.00625), color: Colors.lightGreen[100]),
                                            child: Text(
                                              "50" + "% OFF",
                                              style: TextStyle(fontSize: width * 0.03),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        height: width * 0.11,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              product[id].name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(fontSize: width * 0.060),
                                            ),
                                            Text(
                                              "count : ${product[id].count.toString()}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(fontSize: width * 0.040),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: width * 0.019),
                                        child: 1 == 1
                                            ? Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        // (globals.items[id]["variants"] as Map)[1]
                                                        //     ["amount"] = 1;
                                                      });
                                                      // globals.cart.add(id);
                                                      // globals.server.simulateMessage(
                                                      //     globals.cart.length.toString());
                                                    },
                                                    child: Text("View"),
                                                    // color: Colors.blueAccent,
                                                    // textColor: Colors.white,
                                                  ))
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    width: width * 0.16,
                                                    child: ElevatedButton(
                                                      onPressed: () => setState(() {}),
                                                      child: Text(
                                                        "+",
                                                        style: TextStyle(fontSize: width * 0.07),
                                                      ),
                                                      // color: Colors.blueAccent,
                                                      // textColor: Colors.white,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: width * 0.1,
                                                    child: Text(
                                                      "no. of",
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: width * 0.16,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // if ((globals.items[id]["variants"]
                                                        //         as Map)[1]["amount"] ==
                                                        //     0) {
                                                        //   globals.cart.remove(id);
                                                        //   globals.server.simulateMessage(
                                                        //       globals.cart.length.toString());
                                                        //  .
                                                      },
                                                      child: Text(
                                                        "-",
                                                        style: TextStyle(fontSize: width * 0.07),
                                                      ),
                                                      // color: Colors.blueAccent,
                                                      // textColor: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //      MaterialPageRoute(
                              //         builder: (context) => ProductDetailsPage(id: id)));
                            });
                      }))
            ],
          ),
        ));
  }
}
