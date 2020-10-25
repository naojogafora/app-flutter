import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/ad/ads_provider.dart';
import 'package:trocado_flutter/feature/ad/create_ad_screen.dart';
import 'package:trocado_flutter/feature/ad/my_ad_list_tile.dart';
import 'package:trocado_flutter/response/ads_list.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class MyAdsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AdsProvider provider = Provider.of<AdsProvider>(context);

    return Scaffold(
        appBar: trocadoAppBar("Meus Anúncios"),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAdScreen())),
          child: Icon(Icons.add, color: Style.clearWhite),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => provider.loadUserAds(context, forceLoad: true),
                child: FutureBuilder<AdsListResponse>(
                    initialData: provider.userAds,
                    future: provider.loadUserAds(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      AdsListResponse response = snapshot.data;

                      if(response.data.length == 0) {
                        return Center(child: Text("Voce ainda não tem anúncios!"));
                      }

                      return ListView.builder(
                        itemCount: response.data.length,
                        itemBuilder: (context, i) => MyAdListTile(response.data[i]),
                      );
                    },
                  ),
              )
            ),
          ],
        ));
  }
}
