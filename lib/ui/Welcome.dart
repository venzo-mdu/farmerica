import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/ui/LoginPage.dart';
import 'package:farmerica/ui/SignUp.dart';
import 'package:farmerica/ui/widgets/mytextbutton.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Image.asset('assets/images/farmerica-logo.png'),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Column(
                    children: [
                      const Text(
                        "Farmerica",
                        style: TextStyle(color: Color(0xff00ab55), fontWeight: FontWeight.w600, fontFamily: 'Outfit', fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: const Text(
                          'Hand-crafted with care and attention to packaging detail makes our gift packs best seller and perfect for any occasion. Send them as a thanks or congratulations gift, our gifts are sure to please.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Outfit',
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyTextButton(
                        bgColor: Colors.white,
                        buttonName: 'Register',
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                        },
                        textColor: const Color(0xff00ab55),
                      ),
                      MyTextButton(
                        bgColor: const Color(0xff00ab55),
                        buttonName: 'Sign In',
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        },
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
