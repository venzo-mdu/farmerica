import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:Farmerica/models/Products.dart';
import 'package:Farmerica/networks/ApiServices.dart';
import 'package:Farmerica/ui/productCategory.dart';
import 'package:Farmerica/models/global.dart' as Globals;

import 'package:Farmerica/ui/gertProductfromapi.dart';

class Carousal extends StatelessWidget {
  final height;

  Carousal(this.height);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    CarouselController buttonCarouselController = CarouselController();
    Api_Services api_services = Api_Services();

    List child = [
      'https://www.farmerica.in/wp-content/uploads/2023/03/mathers-day-banner.jpg',
      "https://www.farmerica.in/wp-content/uploads/2023/03/exotic-vagetable-1.jpg",
      "https://www.farmerica.in/wp-content/uploads/2023/03/fruits-basket-1.jpg",
      "https://www.farmerica.in/wp-content/uploads/2023/03/Dry-fruits-banner-3.jpg",
    ];

    final slides = [];

    return CarouselSlider(
      items: child.map((item) {
        return Container(
          // width: 500,
          // width: double.infinity,
          child: GestureDetector(
            onTap: () {
              print('CarouselSlider: $item');
            },
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: item,
              placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                color: Color(0xff3a9046),
              )),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fadeOutDuration: const Duration(milliseconds: 300),
              fadeInDuration: const Duration(milliseconds: 300),
            ),
            //
            // Image.network(
            //   item,
            //   fit: BoxFit.fill,
            // ),
          ),
        );
      }).toList(),
      carouselController: buttonCarouselController,
      options: CarouselOptions(
        autoPlay: true,
        initialPage: 2,
      ),
    );
  }
}

class Catergories extends StatelessWidget {
  final catergories;

  Catergories(this.catergories);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: 500,
      // height: width * 0.50,
      color: Colors.white,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 3),
        scrollDirection: Axis.vertical,
        itemCount: catergories.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          final category = catergories[i];
          final padding = (i == 0) ? 10.0 : 0.0;
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(left: padding),
              height: width * 0.1,
              child: Column(
                children: <Widget>[
                  CachedNetworkImage(
                    height: width * 0.21,
                    imageUrl: category["image"] ?? 'https://as2.ftcdn.net/v2/jpg/03/15/18/09/1000_F_315180932_rhiXFrJN27zXCCdrgx8V5GWbLd9zTHHA.jpg',
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                      color: Color(0xff3a9046),
                    )),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fadeOutDuration: const Duration(milliseconds: 300),
                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
                  // Image.network(
                  //   category["image"] ?? 'https://as2.ftcdn.net/v2/jpg/03/15/18/09/1000_F_315180932_rhiXFrJN27zXCCdrgx8V5GWbLd9zTHHA.jpg',
                  //   height: width * 0.21,
                  // ),
                  Text(
                    category["name"],
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Item extends StatefulWidget {
  final id;

  Item(this.id);

  @override
  State<StatefulWidget> createState() {
    return ItemState(id);
  }
}

class StrikeThroughDecoration extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _StrikeThroughPainter();
  }
}

class _StrikeThroughPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..strokeWidth = 1.0
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final rect = offset & configuration.size;
    canvas.drawLine(Offset(rect.left, rect.top + rect.height / 2), Offset(rect.right, rect.top + rect.height / 2), paint);
    canvas.restore();
  }
}

class HorizontalList extends StatefulWidget {
  final heading;
  final ids;

  HorizontalList(this.heading, this.ids);

  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  var response;
  @override
  Widget build(BuildContext context) {
    Api_Services api_services = Api_Services();
    var items = <Widget>[];
    items.add(const Padding(
      padding: EdgeInsets.all(3.0),
    ));
    widget.ids.forEach((id) => items.add(Item(id)));
    items.add(const Padding(
      padding: EdgeInsets.all(3.0),
    ));

    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: Column(
        children: <Widget>[
          Container(
            // color: Colors.black,
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.heading,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  child: const Text("See all"),
                  // color: Colors.blueAccent,
                  // textColor: Colors.white,
                  onPressed: () async {
                    var response = await api_services.getProducts(68);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Products(
                                  product: response,
                                )));
                  },
                )
              ],
            ),
          ),
          const Divider(
            height: 5.0,
          ),
          const Divider(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items,
            ),
          ),

          // container11(widget.product)
        ],
      ),
    );
  }

  Widget container11(List<Product> product) {
    int addtoCart = 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                  itemCount: 0,
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
                            child: Container(
                              padding: EdgeInsets.all(width * 0.025),
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        imageUrl: product[id].images[0].src,
                                        width: width * 0.3,
                                        placeholder: (context, url) => const Center(
                                            child: CircularProgressIndicator(
                                          color: Color(0xff3a9046),
                                        )),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        fadeOutDuration: const Duration(milliseconds: 300),
                                        fadeInDuration: const Duration(milliseconds: 300),
                                      ),
                                      // Image.network(
                                      //   product[id].images[0].src,
                                      //   width: width * 0.3,
                                      // ),
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
                                            ? const Text("")
                                            : Padding(
                                                padding: EdgeInsets.all(width * 0.022),
                                              ),
                                        (price == sale)
                                            ? const Text("")
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
                                    child: addtoCart == 0
                                        ? Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    addtoCart = 1;
                                                  });
                                                  // globals.cart.add(id);
                                                  // globals.server.simulateMessage(
                                                  //     globals.cart.length.toString());
                                                },
                                                child: const Text("View"),
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
                                                  onPressed: () => setState(() {
                                                    addtoCart = addtoCart + 1;
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
                                                  addtoCart.toString(),
                                                  style: const TextStyle(fontSize: 20),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.16,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addtoCart = addtoCart - 1;
                                                    });
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
                          //     new MaterialPageRoute(
                          //         builder: (context) => ProductDetailsPage(id: id)));
                        });
                  }))
        ],
      ),
    );
  }
}

class HorizontalListView extends StatelessWidget {
  final heading;
  final ids;

  HorizontalListView(this.heading, this.ids);

  @override
  Widget build(BuildContext context) {
    Api_Services api_services = Api_Services();
    var items = <Widget>[];
    items.add(const Padding(
      padding: EdgeInsets.all(3.0),
    ));
    ids.forEach((id) => items.add(Item(id)));
    items.add(const Padding(
      padding: EdgeInsets.all(3.0),
    ));

    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: Column(
        children: <Widget>[
          Container(
            // color: Colors.black,
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    heading,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  child: const Text("See all"),
                  // color: Colors.blueAccent,
                  // textColor: Colors.white,
                  onPressed: () async {
                    var response = await api_services.getCategory(Globals.globalInt);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductsCategory(
                                  product: response,
                                )));
                  },
                )
              ],
            ),
          ),
          const Divider(
            height: 5.0,
          ),
          // new Divider(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items,
            ),
          ),
        ],
      ),
    );
  }
}

class UpperHeading extends StatelessWidget {
  final heading;

  UpperHeading(this.heading);
  // Api_Services api_services = Api_Services();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 2.5, 0.0, 2.5),
      child: Column(
        children: <Widget>[
          Container(
            // color: Colors.black,
            padding: const EdgeInsets.fromLTRB(15.0, 2.5, 15.0, 5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    heading,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                // new RaisedButton(
                //   child: new Text("See all"),
                //   color: Colors.blueAccent,
                //   textColor: Colors.white,
                //   onPressed: () async {
                //
                //     var response = await api_services.getCategoryById(133);
                //
                //     Navigator.push(
                //         context,
                //         new MaterialPageRoute(
                //             builder: (context) => CategoryPage(
                //                 // catergories: response,
                //                 )));
                //   },
                // )
              ],
            ),
          ),

          // new Divider(),
        ],
      ),
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Center(
          child: Text('Log In '),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                children: <Widget>[
                  // new Icon(Icons.),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      print("login with google");
                    },
                    child: const Text(
                      "Sign in with Google",
                      style: TextStyle(color: Colors.black),
                    ),
                    // color: Color.fromRGBO(255, 255, 255, 1.0),
                    // textColor: Colors.white,
                  ))
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                children: <Widget>[
                  // new Icon(Icons.),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      print("login with google");
                    },
                    child: const Text("Sign in with Facebook"),
                    // color: Color.fromRGBO(48, 60, 136, 1.0),
                    // textColor: Colors.white,
                  ))
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                children: <Widget>[
                  // new Icon(Icons.),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      print("login with google");
                    },
                    child: const Text("Sign in with Twitter"),
                    // color: Color.fromRGBO(47, 125, 231, 1.0),
                    // textColor: Colors.white,
                  ))
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                children: <Widget>[
                  // new Icon(Icons.),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      print("login with google");
                    },
                    child: const Text("Sign in with phone"),
                    // color: Color.fromRGBO(0, 194, 152, 1.0),
                    // textColor: Colors.white,
                  ))
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                children: <Widget>[
                  // new Icon(Icons.),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      print("login with google");
                    },
                    child: const Text("Sign in with email"),
                    // color: Color.fromRGBO(215, 0, 0, 1.0),
                    // textColor: Colors.white,
                  ))
                ],
              )
            ],
          ),
        ));
  }
}
