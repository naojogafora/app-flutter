import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/group/groups_tab.dart';

import 'groups_provider.dart';

class GroupSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => "Buscar Grupos";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Digite pelo menos três caracteres",
            ),
          )
        ],
      );
    }

    return Column(
      children: [
        FutureBuilder(
          future: Provider.of<GroupsProvider>(context, listen: false).searchGroups(context, query),
          builder: (context, snapshot) {
            if(snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return Expanded(
                child: GroupsTab(snapshot.data.data, null),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}