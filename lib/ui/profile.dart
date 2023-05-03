import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:image_picker/image_picker.dart';
import 'package:farmerica/ui/CartPage.dart';
import 'package:farmerica/ui/deleteAccount.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/BasePage.dart';

import 'package:farmerica/ui/Welcome.dart';
import 'package:farmerica/ui/homepage.dart';
import 'package:farmerica/ui/myaccounts.dart';
import 'package:farmerica/ui/notificationPage.dart';
import 'package:farmerica/ui/orderPage.dart';
import 'package:farmerica/ui/savedaddress.dart';
import 'package:farmerica/ui/success.dart';
import 'package:farmerica/utils/notification.dart';
import 'package:farmerica/utils/sharedServices.dart';
import 'package:farmerica/utils/sharedpreferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextButton(
        // padding: EdgeInsets.all(20),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        // color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.redAccent,
              size: 22,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text, style: TextStyle(color: Colors.black),)),
            Icon(Icons.arrow_forward_ios, color: Colors.black,),
          ],
        ),
      ),
    );
  }
}

// class ProfilePic extends StatefulWidget {
//   ProfilePic({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   _ProfilePicState createState() => _ProfilePicState();
// }
//
// class _ProfilePicState extends State<ProfilePic> {
//   File _image;
//   int selected = 2;
//   String title = "";
//
//   final picker = ImagePicker();
//
//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         // print('No image selected.');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 115,
//       width: 115,
//       child: Stack(
//         fit: StackFit.expand,
//         // overflow: Overflow.visible,
//         children: [
//           CircleAvatar(
//             backgroundImage: _image == null
//                 ? AssetImage("assets/default.jpg")
//                 : FileImage(_image),
//           ),
//           Positioned(
//             right: -16,
//             bottom: 0,
//             child: SizedBox(
//               height: 46,
//               width: 50,
//               child: TextButton(
//                 // shape: RoundedRectangleBorder(
//                 //   borderRadius: BorderRadius.circular(50),
//                 //   side: BorderSide(color: Colors.white),
//                 // ),
//                 // color: Color(0xFFF5F6F9),
//                 onPressed: () {
//                   getImage();
//                 },
//                 // label: Container(),
//                 child: Icon(
//                   Icons.add_a_photo,
//                   size: 20,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class CompleteProfileScreen extends StatefulWidget {
  List<Product> product;
  Customers customer;
  CompleteProfileScreen({this.customer, this.product});

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  SharedServices sharedServices = SharedServices();
  Customers loginCheck;

  Future<Customers> loginCheckData() async {
    final loginData = await sharedServices.loginDetails();
    return loginData;
  }

  @override
  void initState() {
    super.initState();
    loginCheckData().then((value) => setState(() {
      loginCheck = value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    SharedServices sharedServices = SharedServices();
    Api_Services api_services = Api_Services();
    return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(children: [
              // ProfilePic(),
              // SizedBox(height: 20),
//My Account
              if(loginCheck != null)
              Column(
                children: [
                  ProfileMenu(
                    text: "My Account",
                    icon: Icons.person_outline,
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyAccount(
                                    customer: widget.customer,
                                  )));
                    },
                  ),
                  const Divider(color: Colors.grey, thickness: .5, endIndent: 30, indent: 30),
                ],
              ),
//Change Password
              if(loginCheck != null)
              Column(
                children: [
                  ProfileMenu(
                      text: "Change Password",
                      icon: Icons.lock_outline,
                      press: () {
                        Fluttertoast.showToast(
                            msg: "A link has been Sent to mail to change password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }),
                  const Divider(color: Colors.grey, thickness: .5, endIndent: 30, indent: 30),

                ],
              ),
//Address
              if(loginCheck != null)
              Column(
                children: [
                  ProfileMenu(
                    text: "Saved Addresses",
                    icon: Icons.home_outlined,
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SavedAddress(
                                customer: widget.customer,
                              )));
                    },
                  ),
                  const Divider(color: Colors.grey, thickness: .5, endIndent: 30, indent: 30),
                ],
              ),

//Order History
              if(loginCheck != null)
              Column(
                children: [
                  ProfileMenu(
                    text: "My Orders",
                    icon: Icons.shopping_bag_outlined,
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => OrderPage(
                                    product: widget.product,
                                    id: widget.customer.id,
                                    customers: widget.customer,
                                  )));
                    },
                  ),
                  const Divider(color: Colors.grey, thickness: .5, endIndent: 30, indent: 30),
                ],
              ),

//Delete Account
              if(loginCheck != null)
              Column(
                children: [
                  ProfileMenu(
                    text: "Settings",
                    icon: Icons.settings_outlined,
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => DeleteAccount(
                                    customers: widget.customer,
                                  )));
                    },
                  ),
                  const Divider(color: Colors.grey, thickness: .5, endIndent: 30, indent: 30),
                ],
              ),
// About Us
              ProfileMenu(
                text: "About Us",
                icon: Icons.add_business_outlined,
                press: () {
                  launchURL('https://www.farmerica.in/about/');
                },
              ),
              Divider(color: Colors.grey, thickness: .5, endIndent: 30, indent: 30),
//Privacy Policy
              ProfileMenu(
                text: "Privacy Policy",
                icon: Icons.privacy_tip_outlined,
                press: () {
                  launchURL('https://www.farmerica.in/privacy-policy/');
                },
              ),
              Divider(color: Colors.grey, thickness: .5, endIndent: 30, indent: 30),
//Refund Policy
              ProfileMenu(
                text: "Refund Policy",
                icon: Icons.receipt_outlined,
                press: () {
                  launchURL('https://www.farmerica.in/refund_returns-2/');
                },
              ),
              Divider(color: Colors.grey, thickness: .5, endIndent: 30, indent: 30),
//Login
              if(loginCheck == null)
              Column(
                children: [
                  ProfileMenu(
                    text: "Login",
                    icon: Icons.login,
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomePage()));
                    },
                  ),
                  const Divider(color: Colors.grey, thickness: .5, endIndent: 30, indent: 30),
                ],
              ),
//Logout
              if(loginCheck != null)
              ProfileMenu(
                text: "Log Out",
                icon: Icons.logout,
                press: () {
                  sharedServices.logOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => WelcomePage()));
                  // print(sharedServices.loginDetails());
                },
              ),
            ])));
  }

  launchURL(String urlLink) async {
    String url = urlLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
