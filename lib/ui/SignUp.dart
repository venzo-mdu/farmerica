import 'package:Farmerica/ui/Welcome.dart';
import 'package:Farmerica/ui/widgets/input_outline_button.dart';
import 'package:Farmerica/ui/widgets/input_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Farmerica/utils/sharedServices.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Farmerica/models/Customers.dart';
import 'package:Farmerica/networks/ApiServices.dart';
import 'package:Farmerica/ui/BasePage.dart';
import 'package:Farmerica/ui/LoginPage.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Api_Services apiServices = Api_Services();
  var response = "hh";
  bool done = false;
  String firstName, username, lastName;
  String mail;
  TextEditingController t1, t2, t3, t4;
  final _formKey = GlobalKey<FormState>();
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedServices sharedServices = SharedServices();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text("Create Account,", style: TextStyle(fontFamily: 'Outfit', color: Colors.black, fontSize: 32, fontWeight: FontWeight.w600)),
                const Text(
                  "Sign up to started!",
                  style: TextStyle(color: Colors.grey, fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.w400, letterSpacing: 1.2),
                ),
                const Spacer(
                  flex: 3,
                ),
                TextFormField(
                  style: const TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w400),
                  controller: t1,
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    bool valid = EmailValidator.validate(text);
                    if (valid) {
                      return null;
                    } else {
                      return "Please Enter Valid Mail ";
                    }
                  },
                  onChanged: (text) {
                    mail = text;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff00ab55))),
                    hintText: "Email Address",
                    labelText: "Email",
                    labelStyle: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w400, color: Color(0xff00ab55)),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: const TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w400),
                  controller: t2,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your First name';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    firstName = text;
                    setState(() {});
                    // print(firstName);
                  },
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff00ab55))),
                    hintText: "First Name",
                    labelText: "First Name",
                    labelStyle: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w400, color: Color(0xff00ab55)),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: const TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w400),
                  onChanged: (text) {
                    lastName = text;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Last name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff00ab55))),
                    hintText: "Last Name",
                    labelText: "Last Name",
                    labelStyle: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w400, color: Color(0xff00ab55)),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: const TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w400),
                  controller: t4,
                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    username = text;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Username';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff00ab55))),
                    hintText: "Username",
                    labelText: "Username",
                    labelStyle: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w400, color: Color(0xff00ab55)),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                const SizedBox(height: 10),
                const Spacer(),
                InputTextButton(
                  title: "Sign Up",
                  onClick: () async {
                    if (_formKey.currentState.validate()) {
                      var msg = await apiServices.createCustomers(email: mail, firstName: firstName, lastName: lastName, username: username);

                      Fluttertoast.showToast(
                          msg: msg,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      if (msg == "Signup successful") {
                        Customers customer = await apiServices.getCustomersByMail(mail);
                        sharedServices.setLoginDetails(customer);
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => BasePage(
                                      title: "Farmerica",
                                      customer: customer,
                                    )));
                        // print(customer);
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                InputOutlineButton(
                  title: "Back",
                  onClick: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomePage()));
                  },
                ),
                const Spacer(
                  flex: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("I'm already a member, ",style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, fontFamily: 'Outfit'),),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'Outfit', color: const Color(0xff00ab55 )),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
    //
    // This trailing comma makes auto-formatting nicer fos.
  }
}
