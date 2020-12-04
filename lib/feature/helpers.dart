import 'package:flutter/material.dart';

void showErrorSnack(GlobalKey<ScaffoldState> _scaffoldKey, String message) {
  print(message);
  _scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  ));
}

void showSuccessSnack(GlobalKey<ScaffoldState> _scaffoldKey, String message) {
  _scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.green,
  ));
}