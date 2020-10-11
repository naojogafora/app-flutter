import 'package:flutter/material.dart';
import 'package:trocado_flutter/model/group.dart';

class GroupListTile extends StatelessWidget {
  Group group;

  GroupListTile(this.group);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.group),
      title: Text(group.name),
    );
  }
}
