import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Farmerica/models/Customers.dart';
import 'package:Farmerica/models/Order.dart';
import 'package:Farmerica/models/Products.dart';
import 'package:Farmerica/networks/ApiServices.dart';

class OrderHistoryPage extends StatefulWidget {
  OrderHistoryPage({Key key, this.product, this.id, this.customers});
  final List<Product> product;
  final int id;
  final Customers customers;
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Orders> orderList = [];
  bool loading = true;
  int selected = 3;
  ScrollController controller;
  Api_Services api_services = Api_Services();

  Future<List<Orders>> getList() async {
    // print('objectWidgetID');
    // print('widget.id: ${widget.id}');
    orderList = await api_services.getOrdersByUserId(widget.id);
    // print('OrderLIst: ${orderList[0].deliveryDate}');
    // print('OrderLIst: ${orderList[0].deliveryTime}');
    setState(() {
      loading = false;
    });
    return orderList;
  }

  @override
  void initState() {
    super.initState();
    getList();
    // basePage.title = "My Cart";
    // basePage.selected = 2;
    // controller = ScrollController();
    // controller.addListener(() {
    //   if (controller.offset >= controller.position.maxScrollExtent &&
    //       controller.position.outOfRange) {
    //     setState(() {});
    //     if (controller.offset >= controller.position.minScrollExtent &&
    //         controller.position.outOfRange) {
    //       setState(() {});
    //     }
    //   }
    //   setState(() {
    //     getList();
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
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
        body: orderList.isEmpty
            ? const Center(child: Text("You have not order anything yet"))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderList.length,
                  controller: controller,
                  itemBuilder: (BuildContext context, inxt) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(
                            children: [
                              const Text("Order Id : ",
                                  textAlign: TextAlign.left, style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600)),
                              Text(orderList[inxt].id.toString(),
                                  style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Delivery By : ", style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600)),
                              Text(orderList[inxt].shippingLines[0].methodTitle,
                                  style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text("Payment Method : ", style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600)),
                              Text(orderList[inxt].paymentMethodTitle,
                                  style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text("Billing Name : ", style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600)),
                              Text("${orderList[inxt].billing.firstName} ${orderList[inxt].billing.lastName}",
                                  style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Billing Address : ", style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(orderList[inxt].billing.address1,
                                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400)),
                                  Text(orderList[inxt].billing.address2,
                                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400)),
                                  Text("${orderList[inxt].billing.city}, ${orderList[inxt].billing.state}",
                                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ],
                          ),
                        ]),
                      ),
                    );
                  },
                ),
              ));
  }
}
