import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/BasePage.dart';

import 'package:farmerica/ui/profile.dart';
import 'package:farmerica/ui/widgets/checkout_widget.dart';
import 'package:farmerica/utils/sharedServices.dart';
import 'package:string_validator/string_validator.dart';

class MyAccount extends BasePage {
  MyAccount({this.customer, this.image});
  Customers customer;
  File image;
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends BasePageState<MyAccount> {
  TextEditingController t1, t2, t3, t4;
  String first, last, mail;
  bool b1, b2, b3, b4 = false;
  SharedServices services = SharedServices();
  @override
  void initState() {
    t4 = TextEditingController();
    t1 = TextEditingController();
    t2 = TextEditingController();
    t3 = TextEditingController();

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget body(BuildContext context) {
    Customers customer = widget.customer;
    Api_Services api_services = Api_Services();

    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "My Profile",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  padding: EdgeInsets.all(20),
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Color(0xFFF5F6F9),
                  // onPressed: press,
                  child: Row(
                    children: [
                      Icon(
                        Icons.mail,
                        color: Colors.redAccent,
                        size: 22,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: TextFormField(
                        autofocus: true,
                        enabled: b3,
                        onChanged: (valu) {
                          mail = valu;
                        },
                        validator: (value) {
                          bool valid = isEmail(value);
                          if (valid) {
                            return null;
                          } else if (value == null || value.isEmpty) {
                            setState(() {
                              mail = widget.customer.email;
                            });
                          } else {
                            return "Enter valid Mail Id";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "${customer.email}",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              // fontWeight: FontWeight.bold
                            )),
                        controller: t3,
                      )),
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              b3 = true;
                            });
                            //  t1.value = TextEditingValue(text: "00");
                          }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  padding: EdgeInsets.all(20),
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Color(0xFFF5F6F9),
                  // onPressed: press,
                  child: Row(
                    children: [
                      Icon(
                        Icons.contacts,
                        color: Colors.redAccent,
                        size: 22,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: TextField(
                        autofocus: true,
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: "Username: "
                                "${customer.username}",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              // fontWeight: FontWeight.bold
                            )),
                        controller: t4,
                      )),
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Fluttertoast.showToast(
                                msg: "Username cannot be changed",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }),
                    ],
                  ),
                ),
              ),
              OpenFlutterButton(
                title: "Update",
                // onPressed: () async {
                //   if (_formKey.currentState.validate()) {
                //     Customers customers = await api_services
                //         .updateCustomers(
                //             firstName: first,
                //             lastName: last,
                //             email: mail,
                //             id: widget.customer.id)
                //         .then((value) {
                //       Fluttertoast.showToast(
                //           msg: "Update Successfully",
                //           toastLength: Toast.LENGTH_SHORT,
                //           gravity: ToastGravity.BOTTOM,
                //           timeInSecForIosWeb: 1,
                //           backgroundColor: Colors.black,
                //           textColor: Colors.white,
                //           fontSize: 16.0);
                //       services.setLoginDetails(customer);
                //     });
                //     setState(() {
                //       b1 = false;
                //       b2 = false;
                //       b3 = false;
                //       b4 = false;
                //     });
                //   }
                // }
              )
            ],
          ),
        ));
  }
}

class ProfileMenu extends StatelessWidget {
  ProfileMenu({Key key, @required this.text, @required this.icon, this.press, this.textEditingController}) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback press;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(20),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        // onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.redAccent,
              size: 22,
            ),
            SizedBox(width: 20),
            Expanded(
                child: TextField(
              // enabled: false,
              controller: textEditingController,
            )),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  textEditingController.clear();
                  textEditingController.value = TextEditingValue(text: "00");
                }),
          ],
        ),
      ),
    );
  }
}
