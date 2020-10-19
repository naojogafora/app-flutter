import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/ad/ad_list_tile.dart';
import 'package:trocado_flutter/feature/ad/ads_provider.dart';
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Descrição:",
                        style: TextStyle(color: Style.primaryColor),
                      ),
                      Text(widget.group.description,
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                          style: TextStyle(color: Style.clearWhite)),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    GroupDetailsScreen(widget.group))),
                        child: Text("Ver mais detalhes",
                            style: TextStyle(
                                color: Style.clearWhite,
                                decoration: TextDecoration.underline,
                                fontSize: 13)),
                      ),
                      widget.group.isMember
                          ? Container()
                          : Center(
                              child: RaisedButton(
                              child: Text(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Anúncios"),
          ),
          widget.group.private ? Text("Grupo Fechado. Solicite a entrada para ter acesso aos anúncios disponíveis") : _adsList(),
        ],
      ),
    );
  }

  Widget _adsList(){
    return Consumer<AdsProvider>(
      builder: (context, provider, _) => FutureBuilder(
        future: provider.loadAdsForGroup(context, widget.group.id),
        builder: (context, AsyncSnapshot<AdsListResponse> response) {
          if (response.hasData) {
            AdsListResponse adsListRequest = response.data;
            this.widget.group.adsRequest = adsListRequest;

            if (adsListRequest.data.length == 0) {
              return Text("Nenhum anúncio disponível");
            }

            return Expanded(
              child: ListView.builder(
                itemCount: adsListRequest.data.length,
                itemBuilder: (context, i) =>
                    AdListTile(adsListRequest.data[i]),
              ),
            );
          } else if (response.hasError) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(response.error.toString()),
                backgroundColor: Colors.red,
              ));
            });
            return Container();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void joinGroup(GroupsProvider provider){
    if(widget.group.private){
      //TODO
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("TODO - A SER IMPLEMENTADO"),
        backgroundColor: Colors.yellow,));
    } else {
      provider.joinGroup(context, widget.group).then(
              (JoinGroupResponse joinResponse) {
            if (joinResponse.joined) {
              this.widget.group.isMember = true;
              setState(() {});
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(joinResponse.message),
                backgroundColor: Colors.green,));
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(joinResponse.message),
                backgroundColor: Colors.yellow[900],));
            }
          }
      );
    }
  }
}
