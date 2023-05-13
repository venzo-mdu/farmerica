import 'package:flutter/material.dart';
import 'package:Farmerica/form_helper.dart';
import 'package:Farmerica/models/CartRequest.dart';
import 'package:Farmerica/models/Products.dart';
import 'package:Farmerica/ui/BasePage.dart';
import 'package:Farmerica/ui/payment.dart';

// ignore: must_be_immutable
class VerifyAddress extends StatefulWidget {
  String shippingMethodTitle;
  var customerId;
  var couponDiscount;
  List product = [];
  final int id;
  final String first, last, city, state, postcode, apartmnt, flat, address, country, mobile, mail, giftFrom, giftMsg;
  var shippingFee;
  final String deliveryDate;
  final String deliveryTime;
  List<CartProducts> cartProducts;

  VerifyAddress(
      {this.shippingMethodTitle,
      this.customerId,
      this.id,
      this.mobile,
      this.mail,
      this.address,
      this.product,
      this.apartmnt,
      this.city,
      this.country,
      this.first,
      this.flat,
      this.last,
      this.postcode,
      this.state,
      this.cartProducts,
      this.deliveryDate,
      this.deliveryTime,
      this.giftMsg,
      this.giftFrom,
      this.shippingFee,
      this.couponDiscount});
  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends State<VerifyAddress> {
  int selected = 2;
  String title = "";
  // BasePage basePage = BasePage();
  @override
  void initState() {
    print('verifyId: ${widget.customerId}');
    super.initState();
    // basePage.title = "Checkout Page";
    // basePage.selected = 2;
  }

  bool showDropDownValue = true;

  @override
  Widget build(BuildContext context) {
    if (widget.deliveryTime == null) {
      showDropDownValue = false;
    }

    // print(widget.product);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Delivery Date"),
                  ),
                  Visibility(
                    visible: showDropDownValue,
                    child: Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Delivery Time"),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      child: FormHelper.fieldLabelValu(context, widget.deliveryDate),
                    ),
                  ),
                  Visibility(
                    visible: showDropDownValue,
                    child: Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                        child: FormHelper.fieldLabelValu(context, widget.deliveryTime),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("First Name"),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Last Name"),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      child: FormHelper.fieldLabelValu(context, widget.first),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                      child: FormHelper.fieldLabelValu(context, widget.last),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FormHelper.fieldLabel("Apartment/Flat"),
              ),
              FormHelper.fieldLabelValu(context, widget.address),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FormHelper.fieldLabel("Street"),
              ),
              FormHelper.fieldLabelValu(context, widget.apartmnt),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("City"),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("State"),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      child: FormHelper.fieldLabelValu(context, widget.city),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      child: FormHelper.fieldLabelValu(context, widget.state),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("PostCode"),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Phone Number"),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      child: FormHelper.fieldLabelValu(context, widget.postcode),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      child: FormHelper.fieldLabelValu(context, widget.mobile),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Gift From"),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Gift Msg"),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      child: FormHelper.fieldLabelValu(context, widget.giftFrom),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      child: FormHelper.fieldLabelValu(context, widget.giftMsg),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: FormHelper.saveButton("Confirm", () {
                  final route = MaterialPageRoute(
                      builder: (context) => PaymentGateway(
                            shippingMethodTitle: widget.shippingMethodTitle,
                            customerId: widget.customerId,
                            shippingFee: widget.shippingFee,
                            first: widget.first,
                            last: widget.last,
                            cartProducts: widget.cartProducts,
                            id: widget.id,
                            city: widget.city,
                            country: widget.country,
                            postcode: widget.postcode,
                            address: widget.address,
                            apartmnt: widget.apartmnt,
                            state: widget.state,
                            flat: widget.flat,
                            mail: widget.mail,
                            deliveryDate: widget.deliveryDate,
                            deliveryTime: widget.deliveryTime,
                            giftFrom: widget.giftFrom,
                            giftMsg: widget.giftMsg,
                            mobile: widget.mobile,
                            product: widget.product,
                            couponDiscount: widget.couponDiscount,
                          ));
                  Navigator.push(context, route);
                }),
              ),
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
