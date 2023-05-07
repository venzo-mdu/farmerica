import 'package:email_validator/email_validator.dart';
import 'package:Farmerica/ui/Welcome.dart';
import 'package:Farmerica/ui/widgets/input_outline_button.dart';
import 'package:Farmerica/ui/widgets/input_text_button.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:Farmerica/models/Customers.dart';
import 'package:Farmerica/networks/ApiServices.dart';
import 'package:Farmerica/ui/BasePage.dart';
import 'package:Farmerica/ui/ForgotPassword.dart';
import 'package:Farmerica/ui/SignUp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Farmerica/utils/sharedServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String username, password, mail;
  String error1, error2;
  bool showPassword = true;
  Customers customer;
  final _formKey = GlobalKey<FormState>();
  Api_Services api_services = Api_Services();
  SharedServices sharedServices = SharedServices();
  void toggle() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {  },
      child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Spacer(),
                    const Text("Welcome,", style: TextStyle(fontFamily: 'Outfit', color: Colors.black, fontSize: 32, fontWeight: FontWeight.w600)),
                    const Text(
                      "Sign in to continue!",
                      style: TextStyle(color: Colors.grey, fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.w400, letterSpacing: 1.2),
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                    TextFormField(
                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w400),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      onChanged: (text) {
                        mail = text;
                      },
                      validator: (text) {
                        bool valid = EmailValidator.validate(text);
                        if (valid) {
                          return null;
                        } else {
                          return "Please Enter Valid Mail ";
                        }
                      },
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff00ab55))),
                        suffix: Icon(
                          Icons.person,
                          color: Color(0xff00ab55),
                        ),
                        hintText: "Email Address",
                        labelText: "Email",
                        labelStyle: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w400, color: Color(0xff00ab55)),
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: showPassword,
                      onChanged: (text) {
                        password = text;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the password';
                        }
                        if (value.length <= 6) {
                          return "Password must be more than 10 letters";
                        }
                        return null;
                      },
                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff00ab55))),
                          hintText: "Password",
                          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          labelText: "Password",
                          labelStyle: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w400, color: Color(0xff00ab55)),
                          suffix: GestureDetector(
                            child: showPassword
                                ? const Icon(Icons.visibility_off_outlined, color: Color(0xff00ab55))
                                : const Icon(Icons.visibility_outlined, color: Color(0xff00ab55)),
                            onTap: () {
                              toggle();
                            },
                          )),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    InputTextButton(
                      title: "Sign In",
                      onClick: () async {
                        if (_formKey.currentState.validate()) {
                          username = await api_services.getUsernameByMail(mail);
                          if (username == null) {
                            Fluttertoast.showToast(
                                msg: "E-Mail is not registered",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            var token = await api_services.getToken(username, password);
                            print('TokenFull: $token');
                            // print('TokenCode: ${token['code']}');
                            if (token == null) {
                              Fluttertoast.showToast(
                                  msg: "Wrong Credential",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: const Color(0xff00ab55),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (token['code'] == 'incorrect_password') {
                              Fluttertoast.showToast(
                                  msg: "Please enter the correct password",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: const Color(0xff00ab55),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            else if(token['message'] == 'Credential is valid'){
                              SharedPreferences userPref = await SharedPreferences.getInstance();
                              userPref.setString('email', mail);
                              Customers customer = await api_services.getCustomersByMail(mail);
                              Fluttertoast.showToast(
                                  msg: "Login Successful",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: const Color(0xff00ab55),
                                  textColor: Colors.white,
                                  fontSize: 16.0);

                              sharedServices.setLoginDetails(customer);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BasePage(
                                            title: "Farmerica App",
                                            customer: customer,
                                          )));
                            }
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
                        const Text(
                          "I'm new user, ",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, fontFamily: 'Outfit'),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'Outfit', color: const Color(0xff00ab55)),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30,)
                  ])),
            ),
          )),
    );
  }
}
