import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/group/groups_provider.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

import 'group_join_list_screen.dart';
import 'group_member_list_screen.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  GroupDetailsScreen(this.group);

  @override
  Widget build(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context, listen: false);

    return Scaffold(
      appBar: trocadoAppBar("Detalhes sobre " + group.name),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Descrição:",
                        style: TextStyle(color: Style.primaryColor),
                      ),
                      Text(group.description, style: TextStyle(color: Style.clearWhite)),
                    ],
                  ),
                  color: Style.primaryColorDark,
                ),
              ),
            ],
          ),
          Expanded(
            child: _GroupDetailsBody(group),
          ),
          group.isMember
              ? RaisedButton(
                  child: Text("Sair do Grupo"),
                  color: Colors.red,
                  textColor: Style.clearWhite,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 26),
                  onPressed: () {
                    provider.leaveGroup(context, group).then((bool success) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}

class _GroupDetailsBody extends StatefulWidget {
  final Group group;
  _GroupDetailsBody(this.group);

  @override
  _GroupDetailsBodyState createState() => _GroupDetailsBodyState();
}

class _GroupDetailsBodyState extends State<_GroupDetailsBody> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<GroupsProvider>(context).readGroupDetails(context, widget.group.id),
      builder: (context, AsyncSnapshot<Group> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        Group group = snapshot.data;
        return ListView(
          padding: EdgeInsets.all(8),
          children: [
            group.isModerator &&
                    group.groupJoinRequests != null &&
                    group.groupJoinRequests.length > 0
                ? ListTile(
                    trailing: CircleAvatar(
                      backgroundColor: Style.accentColor,
                      foregroundColor: Style.clearWhite,
                      child: Center(
                        child: Text(
                          group.groupJoinRequests.length.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    title: const Text("Solicitações de entrada:"),
                    visualDensity: VisualDensity.compact,
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => GroupJoinListScreen(group))),
                  )
                : Container(),
            group.isModerator &&
                    group.members != null &&
                    group.members.length > 0
                ? ListTile(
                    trailing: CircleAvatar(
                      backgroundColor: Style.accentColor,
                      foregroundColor: Style.clearWhite,
                      child: Center(
                        child: Text(
                          group.members.length.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    title: const Text("Ver Membros"),
                    visualDensity: VisualDensity.compact,
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => GroupMemberListScreen(group))),
                  )
                : Container(),
            const Text(
              "Moderadores",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              children: List.generate(
                  group.moderators?.length,
                  (index) => ListTile(
                        leading: Icon(Icons.person),
                        title: Text(group.moderators[index].fullName),
                        visualDensity: VisualDensity.compact,
                      )),
            ),
          ],
        );
      },
    );
  }
}
