import 'dart:ui';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/utils/pincode.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/Providers/CartProviders.dart';
import 'package:farmerica/models/Products.dart' as p;
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/ui/CartPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({this.product});

  final p.Product product;
  Customers customer;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int selected = 1;
  bool loa = true;
  String parsHtml(String as) {
    final htmls = parse(as);
    final String pars = parse(htmls.body.text).documentElement.text;
    // print(pars);
    setState(() {
      loa = false;
    });
    return pars;
  }

  final textController = TextEditingController();
  final focusNode = FocusNode();

  List<Product> response;

  String shortDes;

  var pincodeController = TextEditingController();
  bool flag = false;
  bool errorMsg = true;
  SharedPreferences pinCodePrefs;

  getCustomerData() async {}

  @override
  void initState() {
    super.initState();
    shortDes = parsHtml(widget.product.shortDescription);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = (screenSize.height) / 2;

    List<Product> cart = [];
    String title = widget.product.name;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xff00ab55),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            expandedHeight: screenHeight - 100,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.product.images[0].src,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(widget.product.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'OutFit',
                              fontWeight: FontWeight.w500,
                            )),
                        const SizedBox(height: 10),
                        Text("Price: ₹${widget.product.price}",
                            style: const TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff00ab55))),
                        const SizedBox(height: 20),
                        Visibility(
                            visible: shortDes.isNotEmpty,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Product Description:',
                                    style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
                                const SizedBox(height: 10),
                                Text(shortDes,
                                    style: const TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black)),
                                const SizedBox(height: 10),
                              ],
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Delivery Check',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'OutFit',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 20),
                            RawAutocomplete<String>(
                              textEditingController: textController,
                              focusNode: focusNode,
                              optionsBuilder: (textEditingValue) {
                                if (textEditingValue.text != pinCodes) {
                                  setState(() {
                                    errorMsg = false;
                                    // flag = true;
                                  });
                                }
                                return pinCodes.where((element) {
                                  return element.contains(textEditingValue.text);
                                });
                              },
                              onSelected: (value) async {
                                pinCodePrefs = await SharedPreferences.getInstance();
                                pinCodePrefs.setString('pinCode', value);
                                setState(() {
                                  flag = true;
                                  errorMsg = false;
                                });
                              },
                              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width / 2.3,
                                  child: TextFormField(
                                    controller: textController,
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
                                textController.clear();
                                setState(() {
                                  errorMsg = true;
                                  flag = false;
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
                        const SizedBox(height: 10),
                        flag
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        'Shipping methods available for your location:',
                                        style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        '${String.fromCharCode(8226)} Free shipping',
                                        style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        '${String.fromCharCode(8226)} Midnight Delivery 11pm to 12am: 200.00',
                                        style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        '${String.fromCharCode(8226)} Early morning Delivery 6:30am to 7am : 75.00',
                                        style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (textController.text.isEmpty || textController.text == null) {
                                            Fluttertoast.showToast(
                                              msg: "Please enter the Pincode",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 2,
                                              backgroundColor: Color(0xff00ab55),
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          } else {
                                            Provider.of<CartModel>(context, listen: false);
                                            cart.add(widget.product);
                                            Provider.of<CartModel>(context, listen: false).addCartProduct(
                                                widget.product.id, 1, widget.product.name, widget.product.price, widget.product.images[0].src);
                                            Fluttertoast.showToast(
                                              msg: "${widget.product.name} successfully added to cart",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 2,
                                              backgroundColor: Color(0xff00ab55),
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => CartScreen(
                                                      product: response,
                                                      fromHomePage: false,
                                                      // details: widget.customer,
                                                    )));
                                          }
                                        },
                                        child: Container(
                                          decoration:
                                              const BoxDecoration(color: Color(0xff00ab55), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                            child: Text(
                                              'Buy Now',
                                              style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: errorMsg
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                        decoration: const BoxDecoration(color: Color(0xfff7f6f7)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.info, color: Color(0xffb81c23)),
                                            SizedBox(width: 10),
                                            Text('Please enter a postcode / ZIP.',
                                                style: TextStyle(color: Color(0xffb81c23), fontFamily: 'Outfit', fontSize: 15)),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                        decoration: const BoxDecoration(color: Color(0xfff7f6f7)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.swap_horizontal_circle_outlined, color: Color(0xffb81c23)),
                                            SizedBox(width: 10),
                                            Text('Delivery not Available',
                                                style: TextStyle(color: Color(0xffb81c23), fontFamily: 'Outfit', fontSize: 15)),
                                          ],
                                        ))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add other Sliver widgets as needed for your content
        ],
      ),
    );
  }
}
