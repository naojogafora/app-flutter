import 'package:flutter/material.dart';
import 'package:trocado_flutter/feature/group/groups_tab.dart';
import 'package:trocado_flutter/model/ad.dart';

import 'ad_list_tile.dart';

class AdsTab extends StatelessWidget {
  final List<Ad> ads;
  final Future<void> Function() pullToRefresh;

  AdsTab(this.ads, this.pullToRefresh);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ads != null
            ? Expanded(
          child: RefreshIndicator(
            onRefresh: pullToRefresh ?? emptyFuture,
            child: ListView.builder(
              itemCount: ads.length,
              itemBuilder: (context, i) {
                return AdListTile(ads[i]);
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
