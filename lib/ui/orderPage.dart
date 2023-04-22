import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/models/Customers.dart';

import 'package:farmerica/models/Order.dart';
import 'package:farmerica/models/Products.dart';

import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/checkoutPage.dart';

class OrderPage extends BasePage {
  OrderPage({Key key, this.product, this.id, this.customers});
  final List<Product> product;
  final int id;
  final Customers customers;
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends BasePageState<OrderPage> {
  List<Orders> orderList = [];
  bool loading = true;
  int selected = 3;
  ScrollController controller;
  // BasePage basePage = BasePage();
  Api_Services api_services = Api_Services();
  Future<List<Orders>> getList() async {
    // print('objectWidgetID');
    // print(widget.id);
    orderList = await api_services.getOrdersByUserId(widget.id);
    // print('orderList33');
    // print(orderList);
    setState(() {
      loading = false;
    });
    // print(orderList);
    return orderList;
  }

  @override
  void initState() {
    super.initState();
    // getList();
    // basePage.title = "My Cart";
    // basePage.selected = 2;
    controller = ScrollController();
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          controller.position.outOfRange) {
        setState(() {});
        if (controller.offset >= controller.position.minScrollExtent &&
            controller.position.outOfRange) {
          setState(() {});
        }
      }

      setState(() {
        getList();
      });
    });
  }

  @override
  Widget body(BuildContext context) {
    setState(() {});
    return Scaffold(
        body: orderList.isEmpty
            ? Center(child: Text("You have not order anything yet"))
            : ListView.separated(
                itemCount: orderList.length,
                controller: controller,
                // gridDelegate:
                //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, inxt) {
                  return GestureDetector(
                      onTap: () {
                        // print(orderList[inxt]);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => CheckoutWrapper(
                              state: orderList[inxt],
                              product: widget.product,
                            ),
                          ),
                        );
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Order Id",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                              orderList[inxt].id.toString(),
                              textAlign: TextAlign.left,
                            ),
                            Text("Payment Method",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(orderList[inxt].paymentMethod),
                            Text("Billing Name",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(orderList[inxt].billing.firstName +
                                " " +
                                orderList[inxt].billing.lastName +
                                " "),
                            Text("Billing Address",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(orderList[inxt].billing.city +
                                " " +
                                orderList[inxt].billing.state +
                                " " +
                                orderList[inxt].billing.country +
                                " "),
                          ]));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.red,
                    height: 30,
                  );
                },
              ));
  }
}
