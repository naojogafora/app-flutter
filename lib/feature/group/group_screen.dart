import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/ad/ad_list_tile.dart';
import 'package:trocado_flutter/feature/ad/ads_provider.dart';
import 'package:trocado_flutter/feature/ad/create_ad_screen.dart';
import 'package:trocado_flutter/feature/group/group_details_screen.dart';
import 'package:trocado_flutter/feature/group/groups_provider.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/response/ads_list.dart';
import 'package:trocado_flutter/response/group_join.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class GroupScreen extends StatefulWidget {
  final Group group;

  GroupScreen(this.group);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    GroupsProvider provider = Provider.of<GroupsProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: trocadoAppBar(widget.group.name),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Descrição:",
                        style: TextStyle(color: Style.primaryColor),
                      ),
                      Text(widget.group.description,
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(color: Style.clearWhite)),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GroupDetailsScreen(widget.group))),
                        child: const Text("Ver mais detalhes",
                            style: TextStyle(
                                color: Style.clearWhite,
                                decoration: TextDecoration.underline,
                                fontSize: 13)),
                      ),
                      widget.group.isMember
                          ? Container()
                          : Center(
                              child: RaisedButton(
                              child: const Text(
                                "Entrar no Grupo",
                                style: TextStyle(color: Style.clearWhite),
                              ),
                              onPressed: () => joinGroup(provider),
                              color: Style.accentColor,
                            )),
                    ],
                  ),
                  color: Style.primaryColorDark,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Anúncios", style: TextStyle(color: Colors.black54)),
          ),
          widget.group.private && !widget.group.isMember
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Grupo Privado - Solicite a entrada no botão acima, caso tenha sido convidado ou deseje participar.",
                    textAlign: TextAlign.center,
                  ),
                )
              : _adsList(),
        ],
      ),
      floatingActionButton: widget.group.isMember
          ? FloatingActionButton(
              child: const Icon(Icons.add, color: Style.clearWhite),
              tooltip: "Novo Anúncio",
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CreateAdScreen())),
            )
          : null,
    );
  }

  Widget _adsList() {
    return Consumer<AdsProvider>(
      builder: (context, provider, _) => FutureBuilder(
        future: provider.loadAdsForGroup(context, widget.group.id),
        builder: (context, AsyncSnapshot<AdsListResponse> response) {
          if (response.hasData) {
            AdsListResponse adsListRequest = response.data;
            this.widget.group.adsRequest = adsListRequest;

            if (adsListRequest.data.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Não há anúncios aqui ainda, que tal publicar um?!",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: adsListRequest.data.length,
                itemBuilder: (context, i) => AdListTile(adsListRequest.data[i]),
              ),
            );
          } else if (response.hasError) {
            return Center(child: Text(response.error.toString()));
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void joinGroup(GroupsProvider provider) {
    if (widget.group.private) {
      showJoinDialog(context, provider);
    } else {
      provider.joinGroup(context, widget.group).then(joinGroupResult);
    }
  }

  void joinGroupResult(JoinGroupResponse joinResponse) {
    if (joinResponse.joined) {
      this.widget.group.isMember = true;
      setState(() {});
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(joinResponse.message),
        backgroundColor: Colors.green,
      ));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(joinResponse.message),
        backgroundColor: Colors.yellow[900],
      ));
    }
  }

  Future<String> showJoinDialog(BuildContext context, GroupsProvider provider) async {
    TextEditingController inputController = TextEditingController();
    TextEditingController joinCodeController = TextEditingController();
    bool enabled = true;

    return await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        titlePadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Solicitar Entrada"),
            IconButton(
              icon: const Icon(Icons.close),
              padding: const EdgeInsets.all(0),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: "(Opcional) Escreva uma mensagem para os moderadores do grupo.",
              icon: Icon(Icons.description),
            ),
            minLines: 2,
            maxLines: 5,
            maxLength: 1000,
            controller: inputController,
          ),
          const Divider(
            color: Colors.transparent,
            height: 4,
          ),
          MaterialButton(
            color: Style.primaryColorDark,
            textColor: Style.clearWhite,
            onPressed: () async {
              if (!enabled) return;

              enabled = false;
              await provider
                  .joinGroup(context, widget.group, message: inputController.text)
                  .then(joinGroupResult);
              Navigator.of(context).pop();
            },
            child: const Text("Enviar Solicitação"),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: const Text("OU"),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: "Código de Entrada",
              icon: Icon(Icons.confirmation_number),
            ),
            maxLines: 1,
            controller: joinCodeController,
          ),
          MaterialButton(
            color: Style.primaryColorDark,
            textColor: Style.clearWhite,
            onPressed: () async {
              if (!enabled) return;

              enabled = false;
              await provider
                  .joinGroupByInviteCode(context, widget.group, joinCodeController.text)
                  .then(joinGroupResult);
              Navigator.of(context).pop();
            },
            child: const Text("Entrar"),
          ),
        ],
      ),
    );
  }
}
