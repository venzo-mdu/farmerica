import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/Welcome.dart';
import 'package:farmerica/utils/sharedServices.dart';

class AnimatedSplash extends StatefulWidget {
  @override
  _AnimatedSplashState createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplash> {
  Customers loginDetails;
  SharedServices sharedServices = SharedServices();

  @override
  void initState() {
    getValidation().then((value) => setState(() {
          loginDetails = value;
        }));

    super.initState();
  }

  Future<Customers> getValidation() async {
    final login1 = await sharedServices.loginDetails();
    return login1;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            // centered: true,
            duration: 4000,
            splash: Image.asset('assets/images/farmerica-logo-icon.png', color: Colors.white),
            nextScreen: BasePage(
              customer: loginDetails,
              title: "Farmerica App",
            ),

            // loginDetails == null
            //     ? BasePage(
            //         customer: loginDetails,
            //         title: "Farmerica App",
            //       ): WelcomePage(),
            splashTransition: SplashTransition.fadeTransition,
            // pageTransitionType: PageTransitionType.scale,
            backgroundColor: Color(0xff00ab55)));
  }
}
