import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Farmerica/models/CartRequest.dart';
import 'package:Farmerica/models/Customers.dart';
import 'package:Farmerica/models/Order.dart';
import 'package:Farmerica/models/Products.dart';
import 'package:Farmerica/networks/ApiServices.dart';
import 'package:Farmerica/ui/BasePage.dart';
import 'package:Farmerica/ui/UpiPay.dart';
import 'package:Farmerica/ui/checkoutPage.dart';
import 'package:Farmerica/ui/homepage.dart';
import 'package:Farmerica/ui/success.dart';
import 'package:Farmerica/ui/widgets/cashondelivery.dart';
import 'package:Farmerica/utils/RazorPaymentService.dart';
import 'package:upi_india/upi_india.dart';
import 'package:Farmerica/utils/RazorPaymentService.dart';

class PaymentGateway extends BasePage {
  String shippingMethodTitle;
  final String first, last, city, state, postcode, apartmnt, flat, mobile, mail, address, country, giftFrom, giftMsg;
  var shippingFee;
  final String deliveryDate;
  final String deliveryTime;
  var couponDiscount;
  final int id;
  List product = [];
  List<CartProducts> cartProducts;
  int customerId;

  PaymentGateway({
    this.shippingMethodTitle,
    this.customerId,
    this.address,
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
    this.shippingFee,
    this.couponDiscount,
  });

  @override
  _PaymentGatewayState createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends BasePageState<PaymentGateway> {
  @override
  void dispose() {
    // razorPaymentService.clears();
    super.dispose();
  }

  Future<Orders> createOrder() async {
    final orders = await api_services.createOrder(
      customerId: widget.customerId,
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
      coupon: widget.couponDiscount,
      shippingMethodTitle: widget.shippingMethodTitle,
      shippingCartName: widget.cartProducts[0].name,
      shippingCartProdQty: widget.cartProducts[0].quantity,
      shippingFee: widget.shippingFee.toString(),
      // discount: widget.couponDiscount,
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
    super.initState();
  }

  @override
  Widget body(BuildContext context) {
    List<PayCard> _getPaymentCards() {
      List<PayCard> cards = [];
      cards.add(PayCard(
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
                          shippingFee: widget.shippingFee,
                          delivery_type: widget.deliveryDate,
                          delivery_time: widget.deliveryTime,
                          gift_from: widget.giftFrom,
                          gift_message: widget.giftMsg,
                          cartProducts: widget.cartProducts,
                        )));
          }));
      return cards;
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
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
                                  child: Image.asset(_getPaymentCards()[index].image),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getPaymentCards()[index].title,
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Pay bill using ${_getPaymentCards()[index].title}",
                                      //style: smallText,
                                    ),
                                  ],
                                ),
                                IconButton(icon: Icon(Icons.forward), onPressed: _getPaymentCards()[index].onPressed)
                              ],
                            )),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}

class PayCard {
  String title;
  String description;
  String image;
  Function onPressed;
  bool setPaid;

  PayCard({this.title, this.description, this.image, this.onPressed, this.setPaid});
}
