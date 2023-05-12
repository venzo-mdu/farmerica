import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:Farmerica/Providers/CartProviders.dart';
import 'package:Farmerica/models/Customers.dart';
import 'package:Farmerica/models/Products.dart';
import 'package:Farmerica/ui/CartPage.dart';
import 'package:Farmerica/ui/widgets/dialog_box.dart';
import 'package:Farmerica/utils/pincode.dart';
import 'package:Farmerica/utils/sharedServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:Farmerica/models/Products.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class BundledProductPage extends StatefulWidget {
  final int productId;

  BundledProductPage({this.productId});

  @override
  State<BundledProductPage> createState() => _BundledProductPageState();
}

class _BundledProductPageState extends State<BundledProductPage> {
  p.Product product;
  Map<String, dynamic> _product;
  Customers loginCheck;
  SharedServices sharedServices = SharedServices();

  List<dynamic> dummyId = [];
  Future _fetchProduct() async {
    final response = await http.get(Uri.parse(
        'https://www.farmerica.in/wp-json/wc/v3/products/${widget.productId}?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c'));

    if (response.statusCode == 200) {
      final product = jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        _product = product;

        _product['meta_data'][0]['value'].forEach((key, value) {
          setState(() {
            dummyId.add(value['id']);
          });
        });
      });
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Product> getProductsById(int id) async {
    final response = await http.get(Uri.parse(
        'https://www.farmerica.in/wp-json/wc/v3/products/$id?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c'));

    if (response.statusCode == 200) {
      final product = jsonDecode(response.body) as Map<String, dynamic>;
      return Product.fromJson(product);
    } else {
      throw Exception('Failed to load product');
    }
  }

  List<Product> response;

  int counter = 0;
  int minValue = 0;
  int maxValue = 10;
  ValueChanged<int> onChanged;
  Map<int, int> counts = {};
  bool flag = false;
  bool errorMsg = true;
  final textController = TextEditingController();
  final focusNode = FocusNode();
  SharedPreferences pinCodePrefs;

  // double get totalCount {
  //   double total = 0;
  //   counts.forEach((index, count) {
  //     if (count > 0) {
  //       total += count;
  //       print('totalCount: $count');
  //     }
  //   });
  //   return total;
  // }

  Future<Customers> loginCheckData() async {
    final loginData = await sharedServices.loginDetails();
    return loginData;
  }

  @override
  void initState() {
    _fetchProduct();
    // print(dummyId.toList());
    loginCheckData().then((value) => setState(() {
          loginCheck = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Future<Product>> products = dummyId.map((id) => getProductsById(int.parse(id))).toList();
    List<Product> cart = [];

    if (_product == null) {
      print('Meta Data is loading');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff00ab55),
          centerTitle: true,
          title: Image.asset(
            'assets/images/farmerica-logo.png',
            width: MediaQuery.of(context).size.width * 0.5,
            color: Colors.white,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xff00ab55),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00ab55),
        centerTitle: true,
        title: Image.asset(
          'assets/images/farmerica-logo.png',
          width: MediaQuery.of(context).size.width * 0.5,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_product['name'], style: const TextStyle(fontFamily: 'Outfit', fontSize: 25, fontWeight: FontWeight.w500)),
              FutureBuilder<List<Product>>(
                future: Future.wait(products),
                builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasData) {
                    double totalPrice = 0.0;

                    counts.forEach((index, count) {
                      if (count > 0) {
                        // print('total: ${snapshot.data[index].price}');
                        // print('total: ${snapshot.data[index].price.runtimeType}');
                        // print('total: ${count}');
                        // print('total: $totalPrice');
                        // print('total: ${totalPrice.runtimeType}');
                        totalPrice += double.parse(snapshot.data[index].price) * count;
                      }
                    });

                    final basketCount = counts.values.reduce((sum, count) => sum + count);
                    print('Total: $basketCount');

                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text("₹ $totalPrice", style: const TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w400)),
                        Text('Total Price: $totalPrice', style: const TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w400)),
                        GridView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 4 / 6, mainAxisSpacing: 5, crossAxisSpacing: 3),
                          itemBuilder: (BuildContext context, int index) {
                            Product product = snapshot.data[index];
                            int count = counts[index] ?? 0;
                            return Card(
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    height: MediaQuery.of(context).size.height * 0.206,
                                    imageUrl: product.images[0].src,
                                    placeholder: (context, url) =>const Center(child: CircularProgressIndicator(color: Color(0xff3a9046),)),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fadeOutDuration: const Duration(milliseconds: 300),
                                    fadeInDuration: const Duration(milliseconds: 300),
                                  ),
                                  Container(
                                    color: Colors.grey.shade300,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (count > 0) {
                                                  counts[index] = count - 1;
                                                  Fluttertoast.showToast(
                                                    msg: "${product.name} removed from cart",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Color(0xff00ab55),
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                }
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: const Icon(
                                                Icons.remove,
                                                color: Color(0xff00ab55),
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          Text('${counts[index] ?? 0}'),
                                          GestureDetector(
                                            onTap: () {
                                              if(basketCount < 5){
                                                setState(() {
                                                  counts[index] = count + 1;
                                                  print('count: $counts');
                                                  print('countIndex: ${counts[index]}');
                                                  // Provider.of<CartModel>(context, listen: false);
                                                  print('CountL : $count');
                                                  cart.add(product);
                                                  Provider.of<CartModel>(context, listen: false).addCartProduct(
                                                    product.id,
                                                    counts[index],
                                                    product.name,
                                                    product.price,
                                                    product.images[0].src,
                                                  );
                                                });
                                              }else{
                                                Fluttertoast.showToast(
                                                  msg: "Sorry, you can add maximum 5 products in the basket",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Color(0xff00ab55),
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              }

                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: Color(0xff00ab55),
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    decoration: BoxDecoration(color: const Color(0xff00ab55)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style:
                                              const TextStyle(color: Colors.white, fontFamily: 'Outfit', fontWeight: FontWeight.w300, fontSize: 15),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '₹ ${product.price}',
                                          style:
                                              const TextStyle(color: Colors.white, fontFamily: 'Outfit', fontWeight: FontWeight.w500, fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff00ab55),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
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
                                if (loginCheck == null) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const MyDialogBox(),
                                  );
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                                } else {
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
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => CartScreen(
                                              product: response,
                                              fromHomePage: false,
                                              // details: widget.customer,
                                            )));
                                  }
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(color: Color(0xff00ab55), borderRadius: BorderRadius.all(Radius.circular(10))),
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
                                  Text('Delivery not Available', style: TextStyle(color: Color(0xffb81c23), fontFamily: 'Outfit', fontSize: 15)),
                                ],
                              ))),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
