import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:farmerica/models/CartRequest.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/Products.dart' as p;
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/categories.dart';
import 'package:farmerica/ui/createOrder.dart';
import "package:provider/provider.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:farmerica/Providers/CartProviders.dart';
import 'package:farmerica/ui/productDetails.dart';
import 'package:farmerica/models/global.dart' as Globals;
import 'package:shared_preferences/shared_preferences.dart';

class AddtoCart {
  int addtoCart;
  AddtoCart({this.addtoCart});
}

class CartScreen extends BasePage {
  static String routeName = "/cart";
  List<p.Product> product;
  Customers details;

  CartScreen({this.product, this.details});
  @override
  _CartScreenState createState() => _CartScreenState();
}

enum shipping {
  Free_Shipping,
  Midnight_Delivery_11pm_to_12am,
  Early_morning_Delivery_6am_to_7am
}

var totalprice = 0;

// int arraySize = 1;
// List<int> counterArray = new List.filled(arraySize, null, growable: false);

class _CartScreenState extends BasePageState<CartScreen> {
  int counter = 1;
  int arraySize = 1;
  List counterArray = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];

  double subTotals = 0.0;

  List<AddtoCart> addtoCart = [];
  List<Product> product;
  Product cart;
  int quantity = 1;
  int selected = 2;
  String title = "My Cart";
  var totalIndexPrice;
  double totalIndexPrices = 0.0;
  double totalSubtotal = 0.0;
  int dummyCount = 0;
  double finalTotal = 0.0;

  Timer timer;
  var shippingFee = 0;
  int checkOutVariable;

  bool intFlag = false;
  final TextEditingController _couponCodeController = TextEditingController();

  String showPinCode;
  getPinCode() async {
    SharedPreferences pinCodePrefs = await SharedPreferences.getInstance();
    setState(() {
      showPinCode = pinCodePrefs.getString('pinCode') ?? '';
    });
  }

  @override
  void initState() {
    getPinCode();
    super.initState();
  }

  void increment(int index) {
    setState(() {
      counter++;
      counterArray[index]++;
    });
  }

  void decrement(int index) {
    setState(() {
      counter--;
      counterArray[index]--;
    });
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apply the Coupon'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextFormField(
                  controller: _couponCodeController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Coupon Code',
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Apply'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  shipping _character = shipping.Free_Shipping;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    List cartItem = [];

    return Consumer<CartModel>(builder: (context, cartModel, child) {
      if (cartModel.cartProducts.length == 0) {
        return Scaffold(
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                Icon(
                  Icons.hourglass_empty,
                  size: 30,
                ),
                Text(
                  "Your Cart is empty",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ])),
        );
      } else {
        totalSubtotal = 0;
        for (dynamic it in cartModel.cartProducts) {
          cartItem.add({
            'name': it.name,
            'price': it.price,
            'images': it.image,
            'id': it.product_id,
          });
          print('productID: ${it.name}');

          addtoCart.add(AddtoCart(addtoCart: 1));
          if (intFlag == false) {
            subTotals += double.parse(it.price);
            finalTotal += double.parse(it.price);
          }
          arraySize++;
          intFlag = true;
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 450,
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: cartItem.length,
                    itemBuilder: (context, index) {
                      checkOutVariable = index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          child: Dismissible(
                            key: Key(cartItem[index]['id'].toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                cartItem.removeAt(index);
                                cartModel.removeCartProduct(cartItem[index].id);
                              });
                            },
                            background: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SvgPicture.asset(
                                    "assets/Trash.svg",
                                  ),
                                ],
                              ),
                            ),
                            child: GestureDetector(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 84,
                                        child: AspectRatio(
                                          aspectRatio: 0.88,
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF5F6F9),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Image.network(
                                                cartItem[index]['images']),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                        height: 100,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItem[index]['name'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: width * 0.04),
                                            maxLines: 2,
                                          ),
                                          const SizedBox(height: 10),
                                          Text.rich(
                                            TextSpan(
                                              text:
                                                  "₹${cartItem[index]['price']}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFFFF7643)),
                                              children: [
                                                TextSpan(
                                                    text: " ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    decrement(index);
                                                    subTotals = 0;
                                                    for (int i = 0;
                                                        i < cartItem.length;
                                                        i++) {
                                                      subTotals += int.parse(
                                                              cartItem[i]
                                                                  ['price']) *
                                                          counterArray[i];
                                                    }
                                                    finalTotal =
                                                        shippingFee + subTotals;
                                                  },
                                                  child: const Text('-')),
                                              Text(counterArray[index]
                                                  .toString()),
                                              TextButton(
                                                  onPressed: () {
                                                    increment(index);
                                                    subTotals = 0;
                                                    for (int i = 0;
                                                        i < cartItem.length;
                                                        i++) {
                                                      subTotals += int.parse(
                                                              cartItem[i]
                                                                  ['price']) *
                                                          counterArray[i];
                                                    }
                                                    finalTotal =
                                                        shippingFee + subTotals;
                                                  },
                                                  child: const Text('+')),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetail(
                                              product: cartItem[index],
                                            )));
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  // height: 174,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, -15),
                        blurRadius: 20,
                        color: const Color(0xFFDADADA).withOpacity(0.15),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'CART TOTALS',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Subtotal'),
                              ),
                              Text('₹$subTotals'),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping'),
                              Text(shipping.Free_Shipping == _character
                                  ? '₹0.00'
                                  : shipping.Early_morning_Delivery_6am_to_7am ==
                                          _character
                                      ? '₹75.00'
                                      : '₹200.00'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('$_character'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Shipping to $showPinCode, India'),
                            ],
                          ),
                          Column(
                            children: [
                              RadioListTile<shipping>(
                                  title: const Text("Free shipping"),
                                  subtitle: const Text('₹0.00'),
                                  value: shipping.Free_Shipping,
                                  groupValue: _character,
                                  onChanged: (shipping value) {
                                    setState(() {
                                      finalTotal = 0;
                                      for (int i = 0;
                                          i < cartItem.length;
                                          i++) {
                                        finalTotal +=
                                            int.parse(cartItem[i]['price']) *
                                                counterArray[i];
                                      }
                                      finalTotal = 0 + finalTotal;

                                      shippingFee = 0;
                                      _character = value;
                                    });
                                  }),
                              RadioListTile<shipping>(
                                  title: const Text(
                                      "Midnight Delivery 11pm to 12am"),
                                  subtitle: const Text('₹200.00'),
                                  value:
                                      shipping.Midnight_Delivery_11pm_to_12am,
                                  groupValue: _character,
                                  onChanged: (shipping value) {
                                    setState(() {
                                      finalTotal = 0;
                                      for (int i = 0;
                                          i < cartItem.length;
                                          i++) {
                                        finalTotal +=
                                            int.parse(cartItem[i]['price']) *
                                                counterArray[i];
                                      }
                                      finalTotal = 200 + finalTotal;

                                      _character = value;
                                      shippingFee = 200;
                                    });
                                  }),
                              RadioListTile<shipping>(
                                  title: const Text(
                                      "Early morning Delivery 6.30am to 7am"),
                                  subtitle: const Text('₹75.00'),
                                  value: shipping
                                      .Early_morning_Delivery_6am_to_7am,
                                  groupValue: _character,
                                  onChanged: (shipping value) {
                                    setState(() {
                                      finalTotal = 0;
                                      for (int i = 0;
                                          i < cartItem.length;
                                          i++) {
                                        finalTotal +=
                                            int.parse(cartItem[i]['price']) *
                                                counterArray[i];
                                      }
                                      finalTotal = 75 + finalTotal;

                                      shippingFee = 75;
                                      _character = value;
                                    });
                                  }),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Total: '),
                              ),
                              Text('₹${finalTotal.toString()}'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SvgPicture.asset("assets/receipt.svg"),
                          ),
                          const Spacer(),
                          GestureDetector(
                              onTap: () {
                                _showAlertDialog();
                              },
                              child: const Text("Add voucher code")),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            // color: ,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ))),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Proceed to Checkout",
                                    style: TextStyle(fontSize: 18)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateOrder(
                                              shippingFee: shippingFee,
                                              id: cartItem[0]
                                                  ['id'], // widget.details.id,
                                              cartProducts:
                                                  cartModel.cartProducts,
                                              product:
                                                  cartItem, //cart[checkOutVariable],
                                              details: widget.details,
                                            )));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    });
  }
}

class Body extends StatefulWidget {
  final List<p.Product> demoCarts;
  Customers details;
  Body({this.demoCarts});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<p.Product> demoCarts = [p.Product()];
  int addTocart = 0;
  @override
  Widget build(BuildContext context) {
    demoCarts = widget.demoCarts;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: 0 == 1
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                    Icon(
                      Icons.hourglass_empty,
                      size: 30,
                    ),
                    Text(
                      "Your Cart is empty",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ]))
            : ListView.builder(
                itemCount: demoCarts.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                      child: Dismissible(
                        key: Key(demoCarts[index].id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            demoCarts.removeAt(index);
                          });
                        },
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: const [
                              Spacer(),
                              // SvgPicture.asset("assets/icons/Trash.svg"),
                            ],
                          ),
                        ),
                        child: CartCard(
                          cart: demoCarts[index],
                          product: demoCarts,
                        ),
                      ),
                      onTap: () {}),
                ),
              ));
  }
}

class CartCard extends StatefulWidget {
  const CartCard({
    Key key,
    @required this.product,
    @required this.cart,
  }) : super(key: key);
  final List<p.Product> product;
  final p.Product cart;

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int addtoCart = 1;
  Widget addtoCartWi() {
    var width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
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
        SizedBox(
          width: width * 0.1,
          child: const Text(
            "0",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: width * 0.16,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (addtoCart == 1) {
                } else {
                  addtoCart = addtoCart - 1;
                }
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      child: Row(
        children: [
          SizedBox(
            width: 25,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(widget.cart.images[0].src),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cart.name,
                style: TextStyle(color: Colors.black, fontSize: width * 0.05),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "₹${widget.cart.price}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFFFF7643)),
                  children: [
                    TextSpan(
                        text: " x2",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () => setState(() {
                  addtoCart = addtoCart + 1;
                }),
                icon: Icon(Icons.add,
                    size: width * 0.05, color: Colors.blueAccent),
              ),
              Text(
                addtoCart == 0 ? "0" : addtoCart.toString(),
                style: const TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    addtoCart == 0 ? 0 : addtoCart = addtoCart - 1;
                  });
                },
                icon: Icon(Icons.remove,
                    size: width * 0.05, color: Colors.blueAccent),
              ),
            ],
          )
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                      product: widget.cart,
                    )));
      },
    );
  }
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  //812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

// Demo data for our cart

class CheckoutCard extends StatelessWidget {
  List<CartProducts> cartProducts = [];
  final int addTocart;
  CheckoutCard({
    this.cartProducts,
    this.addTocart,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 30,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  //  child: SvgPicture.asset("assets/icons/receipt.svg"),
                ),
                const Spacer(),
                const Text("Add voucher code"),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "₹337.15",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: ElevatedButton(
                    child: const Text("Check Out"),
                    onPressed: () {
                      // print('cartProducts: $cartProducts');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateOrder(
                                    cartProducts: cartProducts,
                                  )));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
