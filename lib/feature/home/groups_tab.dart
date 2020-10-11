import 'package:flutter/material.dart';
import 'package:trocado_flutter/model/group.dart';

import 'group_list_tile.dart';

class GroupsTab extends StatelessWidget {
  final List<Group> groups;

  GroupsTab(this.groups);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        groups != null
            ? Expanded(
                child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, i) {
                    return GroupListTile(groups[i]);
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
