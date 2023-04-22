import 'package:flutter/material.dart';
import 'package:farmerica/ui/CartPage.dart';

class SuccessScreen extends StatelessWidget {
  final String text;
  final Function press;
  SuccessScreen({this.press, this.text});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.asset("assets/success.png", height: 300 //40%
              ),
          SizedBox(height: 20),
          Text(
            "Login Success",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Spacer(),
          SizedBox(
              width: 200,
              child: SizedBox(
                // width: double.infinity,
                height: 56,
                child: TextButton(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20)),
                  // color: Colors.redAccent,
                  onPressed: press,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
          Spacer(),
        ],
      ),
    );
  }
}
