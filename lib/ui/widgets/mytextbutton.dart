import 'package:flutter/material.dart';
import 'package:Farmerica/constant.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    Key key,
    @required this.buttonName,
    @required this.onTap,
    @required this.bgColor,
    @required this.textColor,
  }) : super(key: key);
  final String buttonName;
  final Function onTap;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: const Color(0xff00ab55)),
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith(
            (states) => Colors.black12,
          ),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            buttonName,
            style: TextStyle(color: textColor, fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w500),
            // style: kButtonText.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
