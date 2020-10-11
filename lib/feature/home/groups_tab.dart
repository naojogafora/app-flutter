import 'package:flutter/material.dart';
import 'package:trocado_flutter/feature/home/groups_service.dart';
import 'package:trocado_flutter/model/group.dart';

import 'group_list_tile.dart';

class GroupsTab extends StatefulWidget {
  final GroupsService groupsService = GroupsService();

  @override
  _GroupsTabState createState() {
    return _GroupsTabState();
  }
}

class _GroupsTabState extends State<GroupsTab> {
  @override
  void initState(){
    super.initState();
    print("_GruposTabState init");

    if(widget.groupsService.groups.isEmpty) {
      widget.groupsService.publicGroups().then((value) {
        print("recebido");
        List<dynamic> jsonGroups = value['data'];
        for (dynamic obj in jsonGroups) {
          widget.groupsService.groups.add(Group.fromJson(obj));
        }
        setState(() {});
      }).catchError((error) {
        print("Erro ");
        print(error);
        Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Erro. " + error), backgroundColor: Colors.red,)
        );
      });
    } else {
      print("List already exists");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        widget.groupsService.groups.length > 0 ?
        Expanded(
          child: ListView.builder(
            itemCount: widget.groupsService.groups.length,
            itemBuilder: (context, i){
              return GroupListTile(widget.groupsService.groups[i]);
            },
          ),
        ) :
        Center(child: Text("Não há grupos visiveis")),
      ],
    );
  }
}
