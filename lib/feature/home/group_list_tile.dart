import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/model/group.dart';

class GroupListTile extends StatelessWidget {
  final Group group;

  GroupListTile(this.group);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.group, color: group.isModerator ? Style.accentColor : Style.primaryColorDark,),
      title: Text(group.name),
      subtitle: Text(group.adCount.toString() + " anúncios disponíveis."),
    );
  }
}
