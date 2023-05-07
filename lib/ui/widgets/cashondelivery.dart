import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Farmerica/Config.dart';
import 'package:Farmerica/models/Customers.dart';
import 'package:Farmerica/models/Order.dart' as o;
import 'package:Farmerica/models/Order.dart';
import 'package:http/http.dart' as http;
import 'package:Farmerica/networks/ApiServices.dart';
import 'package:Farmerica/ui/BasePage.dart';
import 'package:Farmerica/ui/dashboard.dart';
import 'package:Farmerica/utils/sharedServices.dart';

class CashOnDelivery extends StatefulWidget {
  int id;
  var shippingMode;
  String delivery_type;
  String delivery_time;
  String gift_from;
  String gift_message;
  List cartProducts;

  CashOnDelivery({
    this.id,
    this.shippingMode,
    this.delivery_type,
    this.delivery_time,
    this.gift_from,
    this.gift_message,
    this.cartProducts,
  });

  @override
  State<CashOnDelivery> createState() => _CashOnDeliveryState();
}

class _CashOnDeliveryState extends State<CashOnDelivery> {
  Customers loginDetails;
  SharedServices sharedServices = SharedServices();

  Future<Customers> getValidation() async {
    final login1 = await sharedServices.loginDetails();
    return login1;
  }

  List<Orders> orderList = [];

  Api_Services api_services = Api_Services();

  Future<List<Orders>> orderId;
  Future<List<Orders>> getList() async {
    orderList = await api_services.getOrderByUserId(widget.id);
    // orderId = '${orderList[0].id}';
    print('OrderData: ${orderList}');
    return orderList;
  }

  @override
  void initState() {
    getValidation().then((value) => setState(() {
      loginDetails = value;
    }));
    orderId = getList();
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // orderList.forEach((element) {
    //   print('elements: ${element.id}');
    // });

    if (orderList == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff00ab55),
          title: Image.asset(
            'assets/images/farmerica-logo.png',
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.5,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 140, vertical: 25),
                    child: Text(
                      'Thank You!!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
                    )),
                Text(
                  'Your order is Placed!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
                ),
                Container(
                  width: double.infinity,
                  height: 180,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0XFFF0F0F1),
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FutureBuilder<List<Orders>>(
                              future: orderId,
                              builder: (context, snapshot) {
                                var orderIds;
                                if (snapshot.hasData) {
                                  orderIds = snapshot.data[0].id;
                                  print(snapshot.data[0].id);
                                }
                                return Text('Order number: ${orderIds.toString()}',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500));
                              }),
                          SizedBox(width: 25),
                          Text('Date : ${widget.delivery_type}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          SizedBox(width: 25),
                          Text('Total: ${widget.cartProducts[0].price}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          SizedBox(width: 25),
                          Text('Gift From: ${widget.gift_from.toString()}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          SizedBox(width: 25),
                          Text('Gift Msg: ${widget.gift_message.toString()}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff00ab55),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => BasePage(
                            customer: loginDetails,
                            title: "Farmerica App",
                          )), (route) => false);
                    },
                    child: Text('Continue Shopping')),
              ],
            ),
          ),
        ),
      );
    }
  }
}
