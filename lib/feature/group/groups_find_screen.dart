import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

import 'groups_provider.dart';
import 'groups_tab.dart';

class GroupsFindScreen extends StatefulWidget {
  @override
  _GroupsFindScreenState createState() => _GroupsFindScreenState();
}

class _GroupsFindScreenState extends State<GroupsFindScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Todos os Grupos"),
      body: Consumer<GroupsProvider>(
        builder: (BuildContext context, groupsService, child) => GroupsTab(
          groupsService.publicGroups,
          () => groupsService.loadPublicGroups(forceLoad: true),
        ),
      ),
    );
  }
}
