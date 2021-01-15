import 'package:flutter/material.dart';

class DefaultDialog {
  String message;
  String title;
  String okButtonText;
  BuildContext context;
  bool showCancel;

  DefaultDialog.show(context, {message, title, okCallback, okButtonText, showCancel = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            showCancel ? GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                child: const Text("Cancelar"),
              ),
              onTap: () => Navigator.of(context).pop(),
            ) : Container(),
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

  void defaultCallback(ctx) {
    Navigator.of(ctx).pop();
  }
}
