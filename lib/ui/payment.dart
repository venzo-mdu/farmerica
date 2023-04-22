import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:farmerica/models/CartRequest.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/Order.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/UpiPay.dart';
import 'package:farmerica/ui/checkoutPage.dart';
import 'package:farmerica/ui/homepage.dart';
import 'package:farmerica/ui/success.dart';
import 'package:farmerica/ui/widgets/cashondelivery.dart';
import 'package:farmerica/utils/RazorPaymentService.dart';
import 'package:upi_india/upi_india.dart';
import 'package:farmerica/utils/RazorPaymentService.dart';

class PaymentGateway extends BasePage {
  final String first,
      last,
      city,
      state,
      postcode,
      apartmnt,
      flat,
      mobile,
      mail,
      address,
      country,
      giftFrom,
      giftMsg;
  var shippingMode;
  final String deliveryDate;
  final String deliveryTime;

  final int id;
  List product = [];
  List<CartProducts> cartProducts;
  PaymentGateway(
      {this.address,
      this.product,
      this.apartmnt,
      this.city,
      this.country,
      this.first,
      this.flat,
      this.id,
      this.last,
      this.mail,
      this.mobile,
      this.postcode,
      this.cartProducts,
      this.state,
      this.deliveryDate,
      this.deliveryTime,
      this.giftFrom,
      this.giftMsg,
      this.shippingMode});

  @override
  _PaymentGatewayState createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends BasePageState<PaymentGateway> {
  // UpiIndia _upiIndia = UpiIndia();
  // List<UpiApp> apps;
  // bool setPaid;
  // String title, method;
  // Api_Services api_services = Api_Services();
  // RazorPaymentService razorPaymentService = RazorPaymentService();
  // UpiApp _selectedApp;

  @override
  void dispose() {
    // razorPaymentService.clears();
    super.dispose();
  }
  Future<Orders> createOrder() async {
    final orders = await api_services.createOrder(

      firstName: widget.first,
      lastName: widget.last,
      addressOne: widget.address,
      addressTwo: widget.apartmnt,
      city: widget.city,
      country: widget.country,
      email: widget.mail,
      phone: widget.mobile,
      postcode: widget.postcode,
      state: widget.state,
      // total: '1000',
      payment_method_title: 'Cash on Delivery',
      payment_method: 'Pay after recieving',
      // quantity: widget.cartProducts[0].quantity,    //orderData.orders[0].products[0].quantity,
      // product_id: widget.cartProducts[0].product_id,    //orderData.orders[0].products[0].id,
      delivery_type: widget.deliveryDate,
      delivery_time: widget.deliveryTime,
      gift_from: widget.giftFrom,
      gift_message: widget.giftMsg,
      cartProducts: widget.cartProducts,


      // delivery_type: widget.deliveryDate,
      // delivery_time: widget.deliveryTime,
      // gift_from: widget.giftFrom,
      // gift_message: widget.giftMsg,
    );


    print('cartDataQty: ${widget.cartProducts[0].quantity}');
    print('cartDate: ${widget.cartProducts[0].product_id}');
  }

  @override
  void initState() {
    // razorPaymentService.initPaymentGateway(context);
    // _upiIndia = UpiIndia();
    // // _initiatePayment();
    // _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
    //   setState(() {
    //     apps = value;
    //   });
    // }).catchError((e) {
    //   apps = [];
    // });
    super.initState();
  }

  // Future<void> _initiatePayment() async {
  //   print('CartProducts: ${widget.cartProducts}');
  //
  //   apps = await _upiIndia.getAllUpiApps();
  //   _selectedApp = await showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text('Select an UPI app'),
  //       content: SingleChildScrollView(
  //         child: ListBody(
  //           children: apps.map((app) => RadioListTile<UpiApp>(
  //             title: Text(app.name),
  //             value: app,
  //             groupValue: _selectedApp,
  //             onChanged: (value) {
  //               setState(() {
  //                 _selectedApp = value;
  //               });
  //             },
  //           )).toList(),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //             onPressed: (){
  //               Navigator.of(context).pop(_selectedApp);
  //             },
  //             child: Text('Okay'),
  //         )
  //       ],
  //     )
  //   );
  //
  //
  //
  //   // final upiPayment = Upipayment(
  //   //     app: _selectedApp!,
  //   //     receiverUpiId: widget.receiverUpiId,
  //   //     transactionRef: widget.orderId.toString(),
  //   //     transactionNote: 'Payment for Order #${widget.id}',
  //   //     amount: widget.cartProducts[0].price,
  //   // );
  //
  //
  //
  //
  //   await _upiIndia.startTransaction(
  //       app: _selectedApp,
  //       receiverUpiId: 'KARTHEEC2011@OKHDFCBANK',
  //       receiverName: 'KARTHEEC2011',
  //       transactionRefId: 'Payment for order #${widget.id}',
  //     amount: 1500.00,
  //   );
  // }

  ///
  // Future<UpiResponse> initiateTransaction(UpiApp app) async {
  //   return _upiIndia.startTransaction(
  //     app: app,
  //     receiverUpiId: "KARTHEEC2011@OKHDFCBANK",
  //     receiverName: 'KARTHEEC2011',
  //     transactionRefId: 'TestingUpiIndiaPlugin',
  //     transactionNote: 'Not actual. Just an example.',
  //     amount: 1.00,
  //   );
  // }

  // int selected = 2;
  // String title = "";
  @override
  Widget body(BuildContext context) {
    List<PayCard> _getPaymentCards() {
      List<PayCard> cards = [];

      // cards.add(PayCard(
      //     title: "QR Scan",
      //     description: "Pay bill using card",
      //     image: "assets/paycard.png",
      //     setPaid: true,
      //     onPressed: () async {
      //       razorPaymentService.getPayment(context);
      //
      //       Orders orders = await api_services.createOrder(
      //           first: widget.first,
      //           setPaid: true,
      //           paymentMethod: "QR Scan",
      //           paymentMethodTitle: "Pay bill using card",
      //           last: widget.last,
      //           address: widget.address,
      //           apartmnt: widget.apartmnt,
      //           city: widget.city,
      //           country: widget.country,
      //           id: widget.id,
      //           postcode: widget.postcode,
      //           cartProducts: widget.cartProducts,
      //           state: widget.state,
      //           flat: widget.flat,
      //           mail: widget.mail,
      //           mobile: widget.mobile,
      //           delivery_type: widget.deliveryDate,
      //           delivery_time: widget.deliveryTime,
      //           gift_from: widget.giftFrom,
      //           gift_message: widget.giftMsg,
      //       )
      //       .then((value) => Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) =>
      //                   CheckoutWrapper(
      //                     state: value,
      //                     product: widget.product,
      //                   ))));
      //     }));
      ///
      // cards.add(new PayCard(
      //     title: "QR Scan",
      //     description: "Pay bill using QR Scan",
      //     image: "assets/paycard.png",
      //     setPaid: true,
      //     onPressed: () async {
      //       print("QR Scan");
      //       Navigator.push(
      //           context, MaterialPageRoute(builder: (context) => UpiPay()));
      //       Orders orders = await api_services.createOrder(
      //           first: widget.first,
      //           setPaid: true,
      //           paymentMethod: "QR Scan",
      //           paymentMethodTitle: "Pay after recieving",
      //           last: widget.last,
      //           address: widget.address,
      //           apartmnt: widget.apartmnt,
      //           city: widget.city,
      //           country: widget.country,
      //           id: widget.id,
      //           postcode: widget.postcode,
      //           cartProducts: widget.cartProducts,
      //           state: widget.state,
      //           flat: widget.flat,
      //           mail: widget.mail,
      //           mobile: widget.mobile);
      //
      //       setState(() {});
      //     }));
      ///
      cards.add(new PayCard(
          title: "Cash on Delivery",
          description: "via Cash on delivery",
          image: "assets/paycard.png",
          setPaid: true,
          // Create order - POST
          onPressed: () {

            print('object: ${widget.giftMsg}');
            print('object: ${widget.giftFrom}');

            createOrder();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CashOnDelivery(
                      id: widget.id,
                      shippingMode: widget.shippingMode,
                      delivery_type: widget.deliveryDate,
                      delivery_time: widget.deliveryTime,
                      gift_from: widget.giftFrom,
                      gift_message: widget.giftMsg,
                      cartProducts: widget.cartProducts,
                    )));

            // Orders orders = await api_services
            //     .createOrder(
            //         first: widget.first,
            //         setPaid: false,
            //         paymentMethod: "Cash on Delivery",
            //         paymentMethodTitle: "Pay after recieving",
            //         last: widget.last,
            //         address: widget.address,
            //         apartmnt: widget.apartmnt,
            //         city: widget.city,
            //         country: widget.country,
            //         id: widget.id,
            //         postcode: widget.postcode,
            //         cartProducts: widget.cartProducts,
            //         state: widget.state,
            //         flat: widget.flat,
            //         mail: widget.mail,
            //         mobile: widget.mobile,
            //         delivery_type: widget.deliveryDate,
            //         delivery_time: widget.deliveryTime,
            //         gift_from: widget.giftFrom,
            //         gift_message: widget.giftMsg)
            //     .then((value) {
            //   print('ValurCheckout: ${value.metaData}');
            //   return Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => CheckoutWrapper(
            //                 state: value,
            //                 product: widget.product,
            //               )));
            // });
          }));
      return cards;
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 0, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: _getPaymentCards().length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white70,
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                      _getPaymentCards()[index].image),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getPaymentCards()[index].title,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Pay bill using ${_getPaymentCards()[index].title}",
                                      //style: smallText,
                                    ),
                                  ],
                                ),
                                IconButton(
                                    icon: Icon(Icons.forward),
                                    onPressed:
                                        _getPaymentCards()[index].onPressed)
                              ],
                            )),
                      );
                    }))
          ],
        ),
      ),

      ///
      // body: Center(
      //   child: CircularProgressIndicator(),
      // ),
    );
  }

  // AppBar buildAppBar(BuildContext context) {
  //   return AppBar(
  //     elevation: 0,
  //     backgroundColor: Colors.grey.shade200,
  //     title: Text(
  //       "PAYMENT",
  //       style: TextStyle(
  //         fontSize: 20,
  //         color: Colors.black87,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     centerTitle: true,
  //     leading: GestureDetector(
  //         onTap: () => {Navigator.pop(context)},
  //         child: Icon(
  //           CupertinoIcons.back,
  //           color: Colors.black38,
  //         )),
  //   );
  // }
}

class PayCard {
  String title;
  String description;
  String image;
  Function onPressed;
  bool setPaid;

  PayCard(
      {this.title, this.description, this.image, this.onPressed, this.setPaid});
}
