import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/helpers.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/model/user.dart';
import 'package:trocado_flutter/response/basic_message_response.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

import 'groups_provider.dart';

class GroupMemberListScreen extends StatefulWidget {
  final Group group;
  GroupMemberListScreen(this.group);

  @override
  _GroupMemberListScreenState createState() => _GroupMemberListScreenState();
}

class _GroupMemberListScreenState extends State<GroupMemberListScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: trocadoAppBar("Membros"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: widget.group.members.length,
              itemBuilder: (context, i) {
                User member = widget.group.members[i];

                return ListTile(
                  leading: Icon(getIconForMember(member)),
                  title: Text(member.fullName),
                  subtitle: Text(member.email),
                  trailing: widget.group.moderators.contains(member)
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Provider.of<GroupsProvider>(context, listen: false)
                                .banGroupMember(context, widget.group.id, member.id)
                                .then((response) => handleSuccess(context, response, member))
                                .catchError((e) => handleError(context, e));
                          },
                        ),
                  onLongPress: widget.group.owner.id == authProvider.user.id ? () {
                    showModeratorDialog(member, member.isModerator);
                  } : null,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void handleSuccess(BuildContext context, BasicMessageResponse response, User member) {
    if (response.success) {
      widget.group.members.remove(member);
      setState(() {});
    } else {
      handleError(context, response.message);
    }
  }

  void handleError(BuildContext context, e) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(e.toString()),
      backgroundColor: Colors.red,
    ));
  }

  IconData getIconForMember(User member) {
    if (member.id == widget.group.owner?.id) {
      return Icons.star;
    } else if (member.isModerator) {
      return Icons.supervisor_account;
    }

    return Icons.person;
  }

  /// If isModerator, dialog will confirm the removal.
  /// If !isModerator, dialog will confirm the adition of the user as moderator.
  void showModeratorDialog(User user, bool isModerator) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text(isModerator ? "Remover Moderador" : "Adicionar Moderador"),
      actions: [
        MaterialButton(child: const Text("Cancelar"), onPressed: () => Navigator.of(context).pop(),),
        MaterialButton(child: const Text("Sim"), onPressed: (){
          GroupsProvider provider = Provider.of<GroupsProvider>(context, listen: false);
          if(isModerator){
            provider.removeModerator(context, widget.group, user.id).then((value) => showSuccessSnack(_scaffoldKey, value.message)).catchError((e) => showErrorSnack(_scaffoldKey, e.toString()));
          } else {
            provider.addModerator(context, widget.group, user.id).then((value) => showSuccessSnack(_scaffoldKey, value.message)).catchError((e) => showErrorSnack(_scaffoldKey, e.toString()));
          }
          Navigator.of(context).pop();
        },),
      ],
    ));
  }
}
