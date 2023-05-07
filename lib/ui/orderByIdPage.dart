// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:Farmerica/models/Categories.dart';
// import 'package:Farmerica/models/Category.dart';
// import 'package:Farmerica/models/Order.dart';
// import 'package:Farmerica/models/Products.dart';
// import 'package:Farmerica/networks/ApiServices.dart';

// class OrderPageById extends StatefulWidget {
//   int id;
//   OrderPageById({@required this.id});

//   @override
//   _OrderPageByIdState createState() => _OrderPageByIdState();
// }

// class _OrderPageByIdState extends State<OrderPageById> {
//   Orders orders;
//   bool loading = true;

//   Api_Services api_services = Api_Services();
//   Future<Orders> getList() async {
//     order = await api_services.getOrdersById(widget.id);
//     setState(() {
//       loading = false;
//     });
//     return order;
//   }

//   @override
//   void initState() {
//     super.initState();
//     getList();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     setState(() {});
//     return Scaffold(
//         appBar: AppBar(),
//         body: Column(
//           children: [
//             Text(orderList[inx].billing.firstName +
//                 orderList[inx].billing.lastName),
//             Text(
//               orderList[inx].customerId.toString(),
//               style: TextStyle(fontSize: 18, color: Colors.black),
//             ),
//             Text(orderList[inx].id.toString()),
//             Text(
//               "Payment Method",
//               style: TextStyle(fontSize: 20, color: Colors.redAccent),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Text(orderList[inx].paymentMethod,
//                 style: TextStyle(fontSize: 20, color: Colors.black)),
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               "Status",
//               style: TextStyle(fontSize: 20, color: Colors.redAccent),
//             ),
//             Text(orderList[inx].status,
//                 style: TextStyle(fontSize: 20, color: Colors.black)),
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               "Email",
//               style: TextStyle(fontSize: 20, color: Colors.redAccent),
//             ),
//             Text(
//               orderList[inx].billing.email,
//               style: TextStyle(fontSize: 20, color: Colors.black),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               "Phone",
//               style: TextStyle(fontSize: 20, color: Colors.redAccent),
//             ),
//             Text(
//               orderList[inx].billing.phone,
//               style: TextStyle(fontSize: 20, color: Colors.black),
//             ),
//           ],
//         ));
//   }
// }
