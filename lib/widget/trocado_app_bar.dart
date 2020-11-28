import 'package:flutter/material.dart';

AppBar trocadoAppBar(String title, {List<Widget> actions}) {
  return AppBar(
    title: Text(title),
    actions: actions,
  );
}
