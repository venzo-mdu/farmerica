import 'dart:ui';
import 'package:Farmerica/ui/LoginPage.dart';
import 'package:flutter/material.dart';

class MyDialogBox extends StatelessWidget {
  const MyDialogBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background with blur effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.grey.withOpacity(0),
            constraints: const BoxConstraints.expand(),
          ),
        ),
        // Dialog box
        Dialog(
          backgroundColor: Colors.transparent,
          insetAnimationDuration: const Duration(milliseconds: 100),
          insetAnimationCurve: Curves.decelerate,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/images/farmerica-logo.png',
                    color: const Color(0xff00ab55),
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'You must Login to Buy this product !.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                const Divider(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00ab55), // Background color
                  ),
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
                  child: const Text('Ok'),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
