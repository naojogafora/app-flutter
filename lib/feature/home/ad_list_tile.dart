import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/model/ad.dart';

class AdListTile extends StatelessWidget {
  final Ad ad;

  AdListTile(this.ad);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.group, color: Style.primaryColorDark,),
    );
  }
}
