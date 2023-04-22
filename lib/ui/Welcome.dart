import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:farmerica/constant.dart';

import 'package:farmerica/ui/LoginPage.dart';

import 'package:farmerica/ui/SignUp.dart';

import 'package:farmerica/ui/widgets/mytextbutton.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: const Image(
                              image: NetworkImage(
                                  'https://www.farmerica.in/wp-content/uploads/2023/01/farmerica-logo.png'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Farmerica",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 26),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: const Text(
                            "We are Farmerica: value added and natural grown agriculture and horticulture Solutions Provider.",
                            style: kBodyText,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: MyTextButton(
                            bgColor: Colors.white,
                            buttonName: 'Register',
                            onTap: () {
                              // Customers customer = Customers();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()));
                            },
                            textColor: Colors.black87,
                          ),
                        ),
                        Expanded(
                          child: MyTextButton(
                            bgColor: Colors.transparent,
                            buttonName: 'Sign In',
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => LoginPage(),
                                  ));
                            },
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
