import 'package:flutter/material.dart';

class DefaultDialog {
  String message;
  String title;
  BuildContext context;

  DefaultDialog.show(context, {message, title, okCallback}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            GestureDetector(
              child: Text("OK"),
              onTap: okCallback != null ? okCallback : () => defaultCallback(context),
            ),
          ],
        );
      },
    );
  }

  void defaultCallback(context){
    Navigator.of(context).pop();
  }
}
