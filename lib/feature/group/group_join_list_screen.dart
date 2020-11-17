import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/exception/BadRequestException.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/model/group_join_request.dart';
import 'package:trocado_flutter/response/basic_message_response.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

import 'groups_provider.dart';

class GroupJoinListScreen extends StatefulWidget {
  final Group group;
  GroupJoinListScreen(this.group);

  @override
  _GroupJoinListScreenState createState() => _GroupJoinListScreenState();
}

class _GroupJoinListScreenState extends State<GroupJoinListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Solicitaçoes de Entrada"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: widget.group.groupJoinRequests.length,
              itemBuilder: (context, i) {
                GroupJoinRequest request = widget.group.groupJoinRequests[i];

                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(request.user.name),
                  subtitle: Text("Mensagem: " + request.message),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          Provider.of<GroupsProvider>(context, listen: false)
                              .updateJoinRequest(context, request, accept: true)
                              .then((response) => handleSuccess(context, response, request))
                              .catchError((e) => handleError(context, e));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          Provider.of<GroupsProvider>(context, listen: false)
                              .updateJoinRequest(context, request, accept: false)
                              .then((response) => handleSuccess(context, response, request))
                              .catchError((e) => handleError(context, e));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void handleSuccess(BuildContext context, BasicMessageResponse response, GroupJoinRequest request) {
    if(response.success){
      widget.group.groupJoinRequests.remove(request);
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
