import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/model/group.dart';

import 'group_form_screen.dart';
import 'group_list_tile.dart';

class GroupsTab extends StatelessWidget {
  final List<Group> groups;
  final Future<void> Function() pullToRefresh;

  GroupsTab(this.groups, this.pullToRefresh);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        groups != null
            ? Expanded(
                child: RefreshIndicator(
                  onRefresh: pullToRefresh ?? emptyFuture,
                  child: ListView.builder(
                    itemCount: groups.length + 1,
                    itemBuilder: (context, i) {
                      if (i >= groups.length) {
                        return Column(
                          children: [
                            const Divider(
                              color: Colors.black54,
                              indent: 12,
                              endIndent: 12,
                              height: 24,
                            ),
                            ListTile(
                              leading:
                                  const Icon(Icons.add, color: Style.primaryColorDark, size: 28),
                              title: const Text(
                                "Criar Novo Grupo",
                                style: TextStyle(color: Style.primaryColorDark),
                              ),
                              subtitle: const Text(
                                  "Não encontrou o que queria? Crie o seu grupo! Vocẽ pode convidar amigos, colegas de trabalho ou conhecidos do bairro!"),
                              onTap: () => Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => GroupFormScreen())),
                            ),
                          ],
                        );
                      }

                      return GroupListTile(groups[i]);
                    },
                  ),
                ),
              )
            : const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
      ],
    );
  }
}

Future<void> emptyFuture() async {
  return;
}
