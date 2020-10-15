import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/ad/ad_list_tile.dart';
import 'package:trocado_flutter/feature/ad/ads_provider.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/response/ads_list.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class GroupScreen extends StatelessWidget {
  final Group group;
  final ObjectKey _scaffoldKey = ObjectKey("Scaffold-group");

  GroupScreen(this.group);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: trocadoAppBar(group.name),
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
                      Text(group.description,
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                          style: TextStyle(color: Style.clearWhite)),
                      Text("Ver mais detalhes",
                          style: TextStyle(
                              color: Style.clearWhite,
                              decoration: TextDecoration.underline,
                              fontSize: 13)),
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
          Consumer<AdsProvider>(
            builder: (context, provider, _) => FutureBuilder(
              future: provider.loadAdsForGroup(context, group.id),
              builder: (context, AsyncSnapshot<AdsListResponse> response) {
                if(response.hasData){
                  AdsListResponse adsListRequest = response.data;
                  this.group.adsRequest = adsListRequest;

                  if(adsListRequest.data.length == 0){
                    return Text("Nenhum anúncio disponível");
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: adsListRequest.data.length,
                      itemBuilder: (context, i) => AdListTile(adsListRequest.data[i]),
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
          ),
        ],
      ),
    );
  }
}
