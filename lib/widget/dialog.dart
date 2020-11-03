import 'package:flutter/material.dart';

class DefaultDialog {
  String message;
  String title;
  String okButtonText;
  BuildContext context;

  DefaultDialog.show(context, {message, title, okCallback, okButtonText}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                child: Text("Cancelar"),
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(okButtonText != null && okButtonText.isNotEmpty ? okButtonText : "OK"),
              ),
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
