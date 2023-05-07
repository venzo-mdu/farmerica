import 'package:flutter/material.dart';
import 'package:Farmerica/ui/BasePage.dart';

class Success extends BasePage {
  String text;
  Function onPressed;
  Success({this.text, this.onPressed});
  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends BasePageState<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      margin: EdgeInsets.only(top: 100),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              widget.text,
              //textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 15,
            ),
            Stack(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [Colors.green, Colors.white])),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 90,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextButton(
              child: Text(
                "Done",
                style: TextStyle(color: Colors.white),
              ),
              // color: Colors.green,
              // padding: EdgeInsets.all(15),
              onPressed: widget.onPressed,
            )
          ]),
    )));
  }
}
