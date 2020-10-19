import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/group/groups_provider.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Group group;
  final ObjectKey _scaffoldKey = ObjectKey("Scaffold-group");

  GroupDetailsScreen(this.group);

  @override
  Widget build(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
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
                      Text(group.description,
                          style: TextStyle(color: Style.clearWhite)),
                    ],
                  ),
                  color: Style.primaryColorDark,
                ),
              ),
            ],
          ),
          Spacer(),
          group.isMember ? RaisedButton(
            child: Text("Sair do Grupo"),
            color: Colors.red,
            textColor: Style.clearWhite,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal:26),
            onPressed: (){
              provider.leaveGroup(context, group).then((bool success){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
            },
          ) : Container(),
        ],
      ),
    );
  }
}
