import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/group/group_screen.dart';
import 'package:trocado_flutter/model/group.dart';

class GroupListTile extends StatelessWidget {
  final Group group;

  GroupListTile(this.group);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.group_work, color: Style.primaryColorDark),
      title: Text(group.name),
      subtitle: group.isModerator
          ? Text("Você é moderador(a)")
          : (!group.isMember && group.private ? Text("Grupo Privado") : Text(group.adCount.toString() + " anúncios disponíveis.")),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => GroupScreen(group))),
    );
  }
}
