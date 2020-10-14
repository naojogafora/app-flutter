import 'package:flutter/material.dart';
import 'package:trocado_flutter/model/ad.dart';

import 'ad_list_tile.dart';

class AdsTab extends StatelessWidget {
  final List<Ad> ads;

  AdsTab(this.ads);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ads != null
            ? Expanded(
          child: ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, i) {
              return AdListTile(ads[i]);
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
