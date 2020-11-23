import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/group/groups_provider.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

import 'group_configuration_form_screen.dart';
import 'group_join_list_screen.dart';
import 'group_member_list_screen.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Group group;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                      const Text(
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
          group.isModerator ? _GroupConfigurationDetails(group.id) : Container(),
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
                      backgroundColor: Style.primaryColorDark,
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
            group.isModerator && group.members != null && group.members.length > 0
                ? ListTile(
                    trailing: CircleAvatar(
                      backgroundColor: Style.primaryColorDark,
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
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => GroupMemberListScreen(group))),
                  )
                : Container(),
            const Divider(height: 6, color: Colors.transparent),
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

class _GroupConfigurationDetails extends StatelessWidget {
  final int groupId;
  _GroupConfigurationDetails(this.groupId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<GroupsProvider>(context, listen: false)
          .readGroupConfiguration(context, groupId),
      builder: (context, AsyncSnapshot<Group> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const CircularProgressIndicator();

        if (snapshot.hasError)
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text("Não foi possível carregar mais detalhes do grupo"),
          );

        Group group = snapshot.data;

        return Container(
          color: Style.accentColor,
          padding: EdgeInsets.all(8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Somente os moderadores vêem o código de convite e os membros. Caso queira convidar "
                  "mais usuários, compartilhe o código e o nome do grupo com eles!",
              textAlign: TextAlign.center,
            ),
            const Divider(height: 6, color: Colors.transparent),
            const Text("Código de Convite:", style: TextStyle(color: Style.primaryColor)),
            Text(group.inviteCode ?? "Não definido",
                style: const TextStyle(color: Style.clearWhite)),
            const Divider(height: 6, color: Colors.transparent),
            const Text("Moderadores:", style: TextStyle(color: Style.primaryColor)),
            Text(
                group.moderators != null
                    ? group.moderators.length.toString() + " moderadores definidos"
                    : "Nenhum definido",
                style: const TextStyle(color: Style.clearWhite)),
            const Divider(height: 6, color: Colors.transparent),
            const Text("Dono do Grupo:", style: TextStyle(color: Style.primaryColor)),
            Text(
                group.owner != null
                    ? group.owner.fullName + " | " + group.owner.email
                    : "Não definido",
                style: const TextStyle(color: Style.clearWhite)),
            const Divider(height: 6, color: Colors.transparent),
            MaterialButton(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, color: Style.clearWhite),
                  const VerticalDivider(color: Colors.transparent),
                  Text("Editar Grupo", style: const TextStyle(color: Style.clearWhite)),
                ],
              ),
              color: Style.primaryColorDark,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupConfigurationFormScreen(group))),
            )
          ]),
        );
      },
    );
  }
}
