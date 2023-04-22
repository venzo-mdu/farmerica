import 'package:flutter/material.dart';
import 'package:farmerica/constant.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {Key key,
      @required this.hintText,
      @required this.inputType,
      @required this.validate,
      this.error,
      @required this.textController})
      : super(key: key);
  final String hintText;
  final TextInputType inputType;
  final Function validate;
  final String error;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: textController,
        style: kBodyText.copyWith(color: Colors.black),
        keyboardType: inputType,
        validator: (text) {
          return error;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          hintText: hintText,
          hintStyle: kBodyText,
          errorText: error,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
