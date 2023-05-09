import 'package:flutter/material.dart';
import 'package:Farmerica/models/Customers.dart';
import 'package:Farmerica/models/ParentCategory.dart';
import 'package:Farmerica/models/Products.dart';
import 'package:Farmerica/models/global.dart' as Globals;
import 'package:Farmerica/networks/ApiServices.dart';
import 'package:Farmerica/ui/CartPage.dart';
import 'package:Farmerica/ui/categories.dart';
import 'package:Farmerica/ui/dashboard.dart';
import 'package:Farmerica/ui/profile.dart';

class BasePage extends StatefulWidget {
  Customers customer;
  int selectedPage;
  String title;
  BasePage({this.customer, this.title, this.selectedPage = 0});

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  List<Product> response;
  Api_Services api_services = Api_Services();

  List<ParentCategory> categories = [];
  List<Widget> list;
  int selected;

  Future getList() async {
    categories = await api_services.getCategoryById(Globals.globalInt);
    response = await api_services.getProducts(Globals.globalInt);
  }

  @override
  void initState() {
    selected = widget.selectedPage;
    getList().then((value) {
      list = [
        Dashboard(),
        CategoryPage(
          catergories: categories,
          product: response,
        ),
        CartScreen(
          product: response,
          details: widget.customer,
        ),
        CompleteProfileScreen(
          customer: widget.customer,
          product: response,
        )
      ];
    });

    super.initState();
  }

  Customers customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00ab55),
        centerTitle: true,
        title: Image.asset(
          'assets/images/farmerica-logo.png',
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
      body: body(context),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: selected,
        iconSize: 30,
        selectedItemColor: const Color(0xff00AA55),
        unselectedItemColor: Colors.grey,
        onTap: (inx) {
          setState(() {
            selected = inx;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.category_rounded,
              ),
              label: "Category"),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            label: "My Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "My Account",
          )
        ],
        type: BottomNavigationBarType.shifting,
      ),
    );
  }

  Widget body(BuildContext context) {
    List<Widget> list = [
      Dashboard(
        product: response,
        category: categories,
      ),
      CategoryPage(
        catergories: categories,
        product: response,
      ),
      CartScreen(
        product: response,
        details: widget.customer,
        fromHomePage: true,
      ),
      CompleteProfileScreen(
        customer: widget.customer,
        product: response,
      )
    ];
    return list[selected];
  }
}
