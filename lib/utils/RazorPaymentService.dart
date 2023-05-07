import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:Farmerica/models/Order.dart';
import 'package:Farmerica/ui/success.dart';

class RazorPaymentService {
  Razorpay _razorpay;
  BuildContext _context;
  Orders orderModel;
  initPaymentGateway(BuildContext context) {
    this._context = context;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(
      PaymentSuccessResponse response, BuildContext context) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Success()));
  }

  void _handlePaymentError(
      PaymentFailureResponse response, BuildContext context) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
    Navigator.pop(context);
  }

  void _handleExternalWallet(
      ExternalWalletResponse response, BuildContext context) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  void clears() {
    _razorpay.clear();
  }

  getPayment(BuildContext context) {
    var options = {
      "key": 'rzp_test_aUGnM0t1kUy0At',
      'amount': 50000, //in the smallest currency sub-unit.
      'name': 'Acme Corp.',
      'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
      'description': 'Fine T-Shirt',
      'timeout': 60, // in seconds
      'prefill': {'contact': '7737366393', 'email': 'gaurav.kumar@example.com'}
    };
    try {
      _razorpay.open(options);
    } catch (v) {}
  }
}
