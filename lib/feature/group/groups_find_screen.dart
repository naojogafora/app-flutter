import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/response/group_list.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

import 'groups_provider.dart';
import 'groups_tab.dart';

class GroupsFindScreen extends StatefulWidget {
  @override
  _GroupsFindScreenState createState() => _GroupsFindScreenState();
}

class _GroupsFindScreenState extends State<GroupsFindScreen> {
  TextEditingController searchController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context, listen: false);

    return Scaffold(
      appBar: trocadoAppBar("Encontrar Grupos"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Pesquisar                   "
              ),
              onEditingComplete: () => setState((){}),
              onSubmitted: (val) => setState((){}),
              textInputAction: TextInputAction.search,
            ),
          ),
          FutureBuilder<GroupListResponse>(
            future: provider.searchGroups(context, searchController.text),
            builder: (BuildContext context, AsyncSnapshot<GroupListResponse> snapshot) {

              if(snapshot.connectionState == ConnectionState.waiting){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );
              } else if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }

              return Expanded(child: GroupsTab(snapshot.data.data, null));
            },
          ),
        ],
      ),
    );
  }
}
