import 'package:flutter/material.dart';

class FormHelper {
  static Widget textInput(
      BuildContext context,
      Object initialValue,
  String hintText,
      String helperText,
      Function onChanged, {
        bool isTextArea = false,
        bool isNumberInput = false,
        obscureText: false,
        Function onValidate,
        Widget prefixIcon,
        Widget suffixIcon,
        bool readOnly=false,
 }) {
    return TextFormField(
      initialValue: initialValue != null ? initialValue.toString() : "",
      decoration: fieldDecoration(
        context,
        hintText,
        helperText,
        suffixIcon: suffixIcon,
      ),
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: !isTextArea ? 1 : 3,
      keyboardType: isNumberInput ? TextInputType.number : TextInputType.text,
      onChanged: (String value) {
        return onChanged(value);
      },
      validator: (value) {
        return onValidate(value);
      },
    );
  }

  static InputDecoration fieldDecoration(
      BuildContext context,
      String hintText,
      String helperText, {
        Widget prefixIcon,
        Widget suffixIcon,
      }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xff00ab55),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  static Widget fieldLabel(String labelName) {
    return Text(
      labelName,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15.0,
        fontFamily: 'Outfit'
      ),
    );
  }


  static Widget saveButton(String buttonText, Function onTap,
      {String color, String textColor, bool fullWidth}) {
    return Container(
      height: 50.0,
      width: 150,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xff00ab55),
              style: BorderStyle.solid,
            ),
            color: Color(0xff00ab55),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showMessage(
      BuildContext context,
      String title,
      String message,
      String buttonText,
      Function onPressed,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: [
            TextButton(
              onPressed: () {
                return onPressed();
              },
              child: new Text(buttonText),
            )
          ],
        );
      },
    );
  }
  static Widget fieldLabelValu( BuildContext context, String labelName) {
    return FormHelper.textInput(context, labelName, "","",(){},onValidate: (valu){
      return null;
    },readOnly: true,);
  }
}
