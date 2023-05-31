import 'dart:async';

import 'package:Farmerica/Providers/CartProviders.dart';
import 'package:Farmerica/models/CartRequest.dart';
import 'package:Farmerica/ui/bundledProductPage.dart';
import 'package:flutter/material.dart';
import 'package:Farmerica/models/global.dart' as Globals;
import 'package:Farmerica/models/Categories.dart';
import 'package:Farmerica/models/Customers.dart';
import 'package:Farmerica/models/ParentCategory.dart';
import 'package:Farmerica/models/Products.dart';
import 'package:Farmerica/networks/ApiServices.dart';
import 'package:Farmerica/ui/BasePage.dart';
import 'package:Farmerica/ui/Products.dart';
import 'package:Farmerica/ui/Recommendedforyou.dart';
import 'package:Farmerica/ui/categories.dart';
import 'package:Farmerica/ui/categoriesDetails.dart';

import 'package:Farmerica/ui/gertProductfromapi.dart';
import 'package:Farmerica/ui/grocery.dart';
import 'package:Farmerica/ui/widgets/component.dart';
import 'package:Farmerica/ui/widgets/homeScreenBoxWidget.dart';

class Dashboard extends StatefulWidget {
  List<Product> product;
  List<ParentCategory> category;
  Dashboard({Key key, this.product, this.category}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Api_Services api_services = Api_Services();
  var response;
  int selected = 0;
  List<Product> product = [];
  List<CartProducts> cartProducts = [];
  List<String> homeScreen = [
    'assets/images/birthday-gift-basket.jpeg',
    'assets/images/anniversary-gift-basket-1.jpeg',
    'assets/images/exotic-vegetable-a-gift-basket.jpeg',
    'assets/images/customize-fruits-basket.jpeg',
    'assets/images/healthy-food-from-our-farm-1.jpeg'
  ];

  List<Widget> carousel = [
    Image.asset('assets/images/mathers-day-banner.jpeg'),
    Image.asset('assets/images/exotic-vagetable-1.jpeg'),
    Image.asset('assets/images/fruits-basket-1.jpeg'),
    Image.asset('assets/images/Dry-fruits-banner-3.jpeg'),
  ];

  final PageController _carouselController = PageController(initialPage: 0);
  int _carouselPage = 0;

  getList() {
    setState(() {
      product = widget.product;
    });
  }

  Timer timer;
  String title = "Dashboard";

  bool end = false;
  @override
  void initState() {
    print('CartModel: ${CartModel().cartProducts}');
    print('Respo: $response');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (_carouselController.hasClients) {
          _carouselController.animateToPage(
            _carouselPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
        _carouselPage++;
      });
    });

    product = widget.product;
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  var padding = const Padding(
    padding: EdgeInsets.all(5.0),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
//slide
            const Carousal(),
          ///
          //   Container(
          //     padding: const EdgeInsets.all(10),
          //     decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
          //     width: double.infinity,
          //     height: 200,
          //     child: PageView(
          //       controller: _carouselController,
          //       children: carousel,
          //       onPageChanged: (int index) {
          //         setState(() {
          //           _carouselPage = 2;
          //         });
          //       },
          //     ),
          //   ),
//banner 1
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        height: MediaQuery.of(context).size.height * 0.18,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xffD7F5D8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Color(0xff214E23),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Same Day',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff214E23),
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Delivery',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xff214E23),
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.width * .05,
                          left: MediaQuery.of(context).size.width * .25,
                          child: Opacity(
                              opacity: 0.15,
                              child: Image.asset(
                                'assets/images/farmerica-logo-icon.png',
                                width: 100,
                              ))),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        height: MediaQuery.of(context).size.height * 0.18,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xffF5D7D7)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/Exciting-offers.png',
                                width: 27,
                                height: 27,
                                color: const Color(0xff6A1414),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Exiciting',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff6A1414),
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Discounts & Offers',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xff6A1414),
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.width * .05,
                          left: MediaQuery.of(context).size.width * .25,
                          child: Opacity(
                              opacity: 0.15, child: Image.asset('assets/images/farmerica-logo-icon.png', width: 100, color: Color(0xff6A1414)))),
                    ],
                  ),
                ],
              ),
            ),
//banner 2
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        height: MediaQuery.of(context).size.height * 0.18,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xffD7DFF5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/free-delivery-icon.png',
                                width: 35,
                                height: 35,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Free',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff2E4990),
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Delivery',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xff2E4990),
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.width * .05,
                          left: MediaQuery.of(context).size.width * .25,
                          child: Opacity(
                              opacity: 0.10, child: Image.asset('assets/images/farmerica-logo-icon.png', width: 100, color: Color(0xff2E4990)))),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        height: MediaQuery.of(context).size.height * 0.18,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xffEFF5D7)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.workspace_premium_outlined,
                                color: Color(0xff758D15),
                                size: 35,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    '100%',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff758D15),
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Premium Products',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xff758D15),
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.width * .05,
                          left: MediaQuery.of(context).size.width * .25,
                          child: Opacity(
                              opacity: 0.10, child: Image.asset('assets/images/farmerica-logo-icon.png', width: 100, color: Color(0xff758D15)))),
                    ],
                  ),
                ],
              ),
            ),
//Product banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemCount: homeScreen.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () async {
                            if (homeScreen[index].toString() == 'assets/images/exotic-vegetable-a-gift-basket.jpeg') {

                              response = await api_services.getProducts(68);
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                  builder: (context) => Grocery(
                                        product: response,
                                      )));
                            } else if (homeScreen[index].toString() == 'assets/images/healthy-food-from-our-farm-1.jpeg') {
                              response = await api_services.getProducts(86);
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                  builder: (context) => Grocery(
                                        product: response,
                                      )));
                            }
                            else {
                              print('came here: ${homeScreen[index].toString()}');
                              response = await api_services.getProducts(45);
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                  builder: (context) => Grocery(
                                        product: response,
                                      )));
                            }
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                homeScreen[index],
                              )));
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
//best seller
                  Column(
                    children: [
                      const Text(
                        'Best Sellers Products',
                        style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Hand-crafted with care and attention to packaging detail makes our gift packs best seller and perfect for any occasion. Send them as a thanks or congratulations gift, our gifts are sure to please.',
                        textAlign: TextAlign.center,
                        style: TextStyle(height: 1.5, fontFamily: 'Outfit', fontWeight: FontWeight.w300, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          response = await api_services.getProducts(86);
                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                              builder: (context) => Grocery(
                                    product: response,
                                  )));
                        },
                        child: Container(
                          decoration: const BoxDecoration(color: Color(0xff00ab55), borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Text(
                              'View More',
                              style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
//bundled product
                  Column(
                    children: [
                      const Text(
                        'wrapping goodness',
                        style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w300, fontSize: 20, color: Color(0xff00ab55)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Customise Fruits Basket',
                        style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.verified,
                            size: 20,
                            color: Color(0xff00ab55),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'Best quality fruits to create a unique combination for your gift basket',
                              maxLines: 2,
                              style: TextStyle(height: 1.5, fontFamily: 'Outfit', fontWeight: FontWeight.w300, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.verified,
                            size: 20,
                            color: Color(0xff00ab55),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'Baskets decorated with fresh flowers for extra liveliness',
                              maxLines: 2,
                              style: TextStyle(height: 1.5, fontFamily: 'Outfit', fontWeight: FontWeight.w300, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.verified,
                            size: 20,
                            color: Color(0xff00ab55),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'Personalize the basket with a card, ribbon like decorations to make it more special',
                              maxLines: 2,
                              style: TextStyle(height: 1.5, fontFamily: 'Outfit', fontWeight: FontWeight.w300, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BundledProductPage(productId: 3925)));
                        },
                        child: Container(
                          decoration: const BoxDecoration(color: Color(0xff00ab55), borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Text(
                              'Choose Now',
                              style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
