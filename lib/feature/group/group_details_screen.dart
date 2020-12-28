import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/group/groups_provider.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';
import 'package:share/share.dart';

import 'group_configuration_form_screen.dart';
import 'group_join_list_screen.dart';
import 'group_member_list_screen.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Group group;
  GroupDetailsScreen(this.group);

  @override
  Widget build(BuildContext context) {
    GroupsProvider provider =
        Provider.of<GroupsProvider>(context, listen: false);

    return Scaffold(
      appBar: trocadoAppBar("Detalhes sobre " + group.name, actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => shareGroup(context),
        )
      ]),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Descrição:",
                        style: TextStyle(color: Style.primaryColor),
                      ),
                      Text(group.description,
                          style: const TextStyle(color: Style.clearWhite)),
                    ],
                  ),
                  color: Style.primaryColorDark,
                ),
              ),
            ],
          ),
          group.isModerator
              ? _GroupConfigurationDetails(group.id)
              : Container(),
          Expanded(
            child: _GroupDetailsBody(group),
          ),
          group.isMember
              ? RaisedButton(
                  child: const Text("Sair do Grupo"),
                  color: Colors.red,
                  textColor: Style.clearWhite,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 26),
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

  void shareGroup(BuildContext context) {
    String message = "Entre no meu grupo do \"Não Joga Fora\" para receber e repassar itens usados!\n";
    message += "Digite na busca esse número do grupo: " + group.id.toString() + ". Ou encontre pelo nome: " + group.name + ".";
    if(group.isModerator && group.private){
      message += "\nDepois, use o código de convite: " + group.inviteCode;
    }
    message += "\n\nNão tem o app? Baixe agora em https://play.google.com/store";

    Share.share(message);
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
      future: Provider.of<GroupsProvider>(context)
          .readGroupDetails(context, widget.group.id),
      builder: (context, AsyncSnapshot<Group> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        Group group = snapshot.data;
        return ListView(
          padding: const EdgeInsets.all(8),
          children: [
            group.isModerator &&
                    group.groupJoinRequests != null &&
                    group.groupJoinRequests.isNotEmpty
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
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GroupJoinListScreen(group))),
                  )
                : Container(),
            group.isModerator &&
                    group.members != null &&
                    group.members.isNotEmpty
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
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GroupMemberListScreen(group))),
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
                        leading: const Icon(Icons.person),
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text("Não foi possível carregar mais detalhes do grupo"),
          );
        }

        Group group = snapshot.data;

        return Container(
          color: Style.accentColor,
          padding: const EdgeInsets.all(8),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Somente os moderadores vêem o código de convite e os membros. Caso queira convidar "
              "mais usuários, compartilhe o código e o nome do grupo com eles!",
              textAlign: TextAlign.center,
            ),
            const Divider(height: 6, color: Colors.transparent),
            const Text("Código de Convite:",
                style: TextStyle(color: Style.primaryColor)),
            Text(group.inviteCode ?? "Não definido",
                style: const TextStyle(color: Style.clearWhite)),
            const Divider(height: 6, color: Colors.transparent),
            const Text("Moderadores:",
                style: TextStyle(color: Style.primaryColor)),
            Text(
                group.moderators != null
                    ? group.moderators.length.toString() +
                        " moderadores definidos"
                    : "Nenhum definido",
                style: const TextStyle(color: Style.clearWhite)),
            const Divider(height: 6, color: Colors.transparent),
            const Text("Dono do Grupo:",
                style: TextStyle(color: Style.primaryColor)),
            Text(
                group.owner != null
                    ? group.owner.fullName + " | " + group.owner.email
                    : "Não definido",
                style: const TextStyle(color: Style.clearWhite)),
            const Divider(height: 6, color: Colors.transparent),
            Center(
              child: MaterialButton(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.edit, color: Style.clearWhite),
                    const VerticalDivider(color: Colors.transparent),
                    const Text("Editar Grupo",
                        style: TextStyle(color: Style.clearWhite)),
                  ],
                ),
                color: Style.primaryColorDark,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupConfigurationFormScreen(group))),
              ),
            )
          ]),
        );
      },
    );
  }
}
