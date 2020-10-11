import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/home/groups_service.dart';

import 'group_list_tile.dart';

class GroupsTab extends StatelessWidget {
  GroupsTab() {
    print("Groups tab created");
  }

  @override
  Widget build(BuildContext context) {
    final GroupsService groupsService = Provider.of<GroupsService>(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        groupsService.groups.length > 0
            ? Expanded(
                child: ListView.builder(
                  itemCount: groupsService.groups.length,
                  itemBuilder: (context, i) {
                    return GroupListTile(groupsService.groups[i]);
                  },
                ),
              )
            : Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
      ],
    );
  }
}
