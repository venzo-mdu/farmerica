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
        // title: 'Clean Code',
        home: AnimatedSplashScreen(
            duration: 4000,
            splash: const Center(
              child: Image(
                image: NetworkImage(
                  'https://www.farmerica.in/wp-content/uploads/2023/01/farmerica-logo.png',
                ),
              ),
            ),
            nextScreen: loginDetails == null
                ? WelcomePage()
                : BasePage(
                    customer: loginDetails,
                    title: "Farmerica App",
                  ),
            splashTransition: SplashTransition.fadeTransition,
            // pageTransitionType: PageTransitionType.scale,
            backgroundColor: Colors.white));
  }
}
