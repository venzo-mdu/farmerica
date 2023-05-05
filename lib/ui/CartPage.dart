import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/models/CartRequest.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/Products.dart' as p;
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/createOrder.dart';
import "package:provider/provider.dart";
import 'package:farmerica/Providers/CartProviders.dart';
import 'package:farmerica/ui/productDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmerica/models/global.dart' as Globals;
import '../networks/ApiServices.dart';

class AddToCart {
  int addtoCart;
  AddToCart({this.addtoCart});
}

class CartScreen extends BasePage {
  static String routeName = "/cart";
  List<p.Product> product;
  Customers details;
  bool fromHomePage;

  CartScreen({this.product, this.details, this.fromHomePage});
  @override
  _CartScreenState createState() => _CartScreenState();
}

enum shipping { Free_Shipping, Midnight_Delivery_11pm_to_12am, Early_morning_Delivery_6am_to_7am }

var totalprice = 0;

// int arraySize = 1;
// List<int> counterArray = new List.filled(arraySize, null, growable: false);

class _CartScreenState extends BasePageState<CartScreen> {
  int counter = 1;
  int arraySize = 1;
  List counterArray = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];

  double subTotals = 0.0;
var couponError;
  List<AddToCart> addtoCart = [];
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
  bool showCoupon = false;
  bool intFlag = false;

  final textEditingController = TextEditingController();
  final focusNode = FocusNode();

  String showPinCode;
  getPinCode() async {
    SharedPreferences pinCodePrefs = await SharedPreferences.getInstance();
    setState(() {
      showPinCode = pinCodePrefs.getString('pinCode') ?? '';
    });
  }

  Api_Services api_services = Api_Services();

  List couponList = [];
  Future getCouponCode() async {
    couponList = await api_services.getCoupon();
  }

  var couponSelection;
  var couponDiscount;
  var couponTotal;
  var clearCoupon;

  @override
  void initState() {
    getPinCode();
    getCouponCode();
    super.initState();
  }

  shipping _character = shipping.Free_Shipping;

  var shippingType = 'Free Shipping';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    List cartItem = [];

    return Consumer<CartModel>(builder: (context, cartModel, child) {
      if (cartModel.cartProducts.isEmpty) {
        return Scaffold(
          body: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Image.asset(
                'assets/images/farmerica-logo-icon.png',
                color: const Color(0xff00ab55),
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Your Cart is empty",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Outfit'),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BasePage(
                              title: "Farmerica App",
                              customer: customer,
                            )));
              },
              child: Container(
                decoration: const BoxDecoration(color: Color(0xff00ab55), borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Continue Shoping',
                    style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
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
            'quantity': it.quantity,
          });
          counterArray.add(it.quantity);

          counter = it.quantity;
          // setState(() {
          Globals.cartCount = counter;
          // });

          addtoCart.add(AddToCart(addtoCart: 1));
          if (intFlag == false) {
            subTotals += double.parse(it.price);
            finalTotal += double.parse(it.price);
          }
          arraySize++;
          intFlag = true;
        }

        subTotals = 0;
        for (int i = 0; i < cartItem.length; i++) {
          subTotals += int.parse(cartItem[i]['price']) * counter;
        }

        return Scaffold(
          appBar: !widget.fromHomePage
              ? AppBar(
                  backgroundColor: const Color(0xff00ab55),
                  centerTitle: true,
                  title: Image.asset(
                    'assets/images/farmerica-logo.png',
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                )
              : PreferredSize(
                  preferredSize: Size(0, 0),
                  child: Container(),
                ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartItem.length,
                    itemBuilder: (context, index) {
                      checkOutVariable = index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Card(
                          elevation: 0.5,
                          color: Colors.white,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 100,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child:CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: cartItem[index]['images'],
                                    placeholder: (context, url) =>const Center(child: CircularProgressIndicator(color: Color(0xff3a9046),)),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fadeOutDuration: const Duration(milliseconds: 300),
                                    fadeInDuration: const Duration(milliseconds: 300),
                                  )
                                  // child: Image.network(cartItem[index]['images']),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem[index]['name'],
                                        style:
                                            TextStyle(color: Colors.black, fontSize: width * 0.04, fontFamily: 'Outfit', fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 5),
                                      Text.rich(
                                        TextSpan(
                                          text: "₹${cartItem[index]['price']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400, fontSize: width * 0.035, fontFamily: 'Outfit', color: Color(0xff00ab55)),
                                          children: [
                                            TextSpan(text: " ", style: Theme.of(context).textTheme.bodyText1),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              if (counter > 0) {
                                                setState(() {
                                                  counter--;
                                                });
                                              } else {
                                                setState(() {
                                                  counter = 1;
                                                });
                                              }
                                              subTotals = 0;
                                              for (int i = 0; i < cartItem.length; i++) {
                                                subTotals += int.parse(cartItem[i]['price']) * counter;
                                              }
                                              setState(() {
                                                finalTotal = shippingFee + subTotals;
                                              });
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xff00ab55),
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                                child: Text('-',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: width * 0.035,
                                                      fontFamily: 'Outfit',
                                                      fontWeight: FontWeight.w500,
                                                    )),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            counter.toString(),
                                            style: TextStyle(
                                                fontSize: width * 0.035, fontFamily: 'Outfit', fontWeight: FontWeight.w500, color: Colors.black),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                counter++;
                                              });
                                              subTotals = 0;
                                              for (int i = 0; i < cartItem.length; i++) {
                                                subTotals += int.parse(cartItem[i]['price']) * counter;
                                              }
                                              setState(() {
                                                finalTotal = shippingFee + subTotals;
                                              });
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xff00ab55),
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                                child: Text('+',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: width * 0.035,
                                                      fontFamily: 'Outfit',
                                                      fontWeight: FontWeight.w500,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  key: Key(cartItem[index]['id'].toString()),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Farmerica'),
                                          content: const Text('Are you sure you want to delete this item?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Ok'),
                                              onPressed: () {
                                                setState(() {
                                                  cartItem.removeAt(index);
                                                  cartModel.cartProducts.removeAt(index);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
//Cart Details
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    // height: 174,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey.withOpacity(0.25)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, -15),
                          blurRadius: 20,
                          color: const Color(0xFFDADADA).withOpacity(0.15),
                        )
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text(
                                'CART TOTAL',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '₹$subTotals',
                                style: const TextStyle(fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Shipping',
                                style: const TextStyle(fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                shipping.Free_Shipping == _character
                                    ? '₹0.00'
                                    : shipping.Early_morning_Delivery_6am_to_7am == _character
                                        ? '₹75.00'
                                        : '₹200.00',
                                style: const TextStyle(fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            shippingType,
                            style: const TextStyle(fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              RadioListTile<shipping>(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity:
                                      const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                  title: const Text("Free shipping",
                                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400)),
                                  subtitle:
                                      const Text('₹0.00', style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w300)),
                                  value: shipping.Free_Shipping,
                                  groupValue: _character,
                                  onChanged: (shipping value) {
                                    setState(() {
                                      finalTotal = 0;
                                      for (int i = 0; i < cartItem.length; i++) {
                                        finalTotal += int.parse(cartItem[i]['price']) * counterArray[i];
                                      }
                                      finalTotal = 0 + finalTotal;

                                      shippingFee = 0;
                                      _character = value;
                                      String text = _character.toString();
                                      shippingType = text.replaceAll('_', ' ');
                                      shippingType = shippingType.substring(shippingType.indexOf('.') + 1);
                                      print('shippingType $shippingType');
                                    });
                                  }),
                              RadioListTile<shipping>(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity:
                                      const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                  title: const Text("Midnight Delivery 11pm to 12am",
                                      style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400)),
                                  subtitle: const Text('₹200.00', style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w300)),
                                  value: shipping.Midnight_Delivery_11pm_to_12am,
                                  groupValue: _character,
                                  onChanged: (shipping value) {
                                    setState(() {
                                      finalTotal = 0;
                                      for (int i = 0; i < cartItem.length; i++) {
                                        finalTotal += int.parse(cartItem[i]['price']) * counterArray[i];
                                      }
                                      finalTotal = 200 + finalTotal;

                                      _character = value;
                                      shippingFee = 200;
                                      String text = _character.toString();
                                      shippingType = text.replaceAll('_', ' ');
                                      shippingType = shippingType.substring(shippingType.indexOf('.') + 1);
                                      print('shippingType $shippingType');
                                    });
                                  }),
                              RadioListTile<shipping>(
                                  visualDensity:
                                      const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Early morning Delivery 6.30am to 7am",
                                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400)),
                                  subtitle:
                                      const Text('₹75.00', style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w300)),
                                  value: shipping.Early_morning_Delivery_6am_to_7am,
                                  groupValue: _character,
                                  onChanged: (shipping value) {
                                    setState(() {
                                      finalTotal = 0;
                                      for (int i = 0; i < cartItem.length; i++) {
                                        finalTotal += int.parse(cartItem[i]['price']) * counterArray[i];
                                      }
                                      finalTotal = 75 + finalTotal;

                                      shippingFee = 75;
                                      _character = value;
                                      String text = _character.toString();
                                      shippingType = text.replaceAll('_', ' ');
                                      shippingType = shippingType.substring(shippingType.indexOf('.') + 1);
                                      print('shippingType $shippingType');
                                    });
                                  }),
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Add a Coupon',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'OutFit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 20),
                              RawAutocomplete<dynamic>(
                                textEditingController: textEditingController,
                                focusNode: focusNode,
                                optionsBuilder: (textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    setState(() {
                                      couponError= '';
                                    });
                                    return const Iterable<String>.empty();
                                  }
                                  else {
                                    final matches = couponList.where((coupon) =>
                                        coupon.code.toLowerCase().contains(textEditingValue.text.toLowerCase())
                                    ).toList();
                                    if (matches.isEmpty) {
                                      // Entered coupon code is not valid
                                      setState(() {
                                        couponError = 'Invalid coupon code';
                                      });
                                    } else {
                                      setState(() {
                                        couponError = '';
                                      });
                                    }
                                    return matches.map((coupon) => coupon.code);
                                  }
                                },
                                onSelected: (selection) async {
                                  var trimValue = selection.toString().substring(selection.toString().length - 2);
                                  couponSelection = selection;
                                  couponDiscount = (double.parse(trimValue) / 100) * finalTotal;
                                  setState(() {
                                    couponTotal = finalTotal - couponDiscount;
                                    couponError = '';
                                  });
                                  print('couponTotal: $couponTotal');
                                },
                                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.3,
                                    child: TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      onEditingComplete: onEditingComplete,
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                                        hintText: 'Enter Pin Code',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff00ab55),
                                          ),
                                        ),
                                        // focusedBorder:
                                      ),
                                    ),
                                  );
                                },
                                optionsViewBuilder: (context, onSelected, options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                                        width: MediaQuery.of(context).size.width / 2,
                                        height: MediaQuery.of(context).size.height / 3.5,
                                        child: ListView.builder(
                                          shrinkWrap: false,
                                          itemCount: options.length,
                                          itemBuilder: (context, index) {
                                            final option = options.elementAt(index);
                                            return ListTile(
                                              title: Text(option),
                                              onTap: () {
                                                onSelected(option);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                displayStringForOption: (option) => option,
                              ),

                              const SizedBox(width: 10),

                              GestureDetector(
                                onTap: () {
                                  textEditingController.clear();
                                  setState(() {
                                    couponError = '';
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.clear,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (couponError != null) Text(couponError, style: TextStyle(color: Colors.red)),

                          const Divider(color: Colors.grey),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total', style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w500)),
                              couponTotal == null
                                  ? Text('₹${finalTotal.toString()}',
                                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w500))
                                  : Text('₹${couponTotal.toString()}',
                                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          couponTotal != null
                              ? const Text('Coupon Applied Successfully',
                                  style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xff00ab55)))
                              : const Text(''),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff00ab55),
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              child: const Text("Proceed to Checkout", style: TextStyle(fontSize: 18)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateOrder(
                                              couponSelection: couponSelection,
                                              shippingFee: shippingFee,
                                              id: cartItem[0]['id'], // widget.details.id,
                                              cartProducts: cartModel.cartProducts,
                                              product: cartItem, //cart[checkOutVariable],
                                              details: widget.details,
                                            )));
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                Icon(
                  Icons.hourglass_empty,
                  size: 30,
                ),
                Text(
                  "Your Cart is empty",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                child: CachedNetworkImage(
                    imageUrl: widget.cart.images[0].src,
                    placeholder: (context, url) =>const Center(child: CircularProgressIndicator(color: Color(0xff3a9046),)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fadeOutDuration: const Duration(milliseconds: 300),
                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
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
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFFF7643)),
                  children: [
                    TextSpan(text: " x2", style: Theme.of(context).textTheme.bodyText1),
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
                icon: Icon(Icons.add, size: width * 0.05, color: Colors.blueAccent),
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
                icon: Icon(Icons.remove, size: width * 0.05, color: Colors.blueAccent),
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
