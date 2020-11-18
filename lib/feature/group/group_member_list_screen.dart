import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/exception/BadRequestException.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/model/group_join_request.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Membros do Grupo"),
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
                  leading: const Icon(Icons.person),
                  title: Text(member.fullName),
                  subtitle: Text(member.email),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Provider.of<GroupsProvider>(context, listen: false)
                          .banGroupMember(context, widget.group.id, member.id)
                          .then((response) => handleSuccess(context, response, member))
                          .catchError((e) => handleError(context, e));
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void handleSuccess(BuildContext context, BasicMessageResponse response, User member) {
    if(response.success){
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
}
