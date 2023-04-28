import 'package:flutter/material.dart';

class InputTextButton extends StatelessWidget {
  final String title;
  final Function onClick;
  const InputTextButton({Key key, this.title, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff00ab55),
        minimumSize: const Size(double.maxFinite, 50),
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
      ),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        onClick();
      },
      child: Text(
        title,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600, fontFamily: 'Outfit'),
      ),
    );
  }
}
