import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/model/ad.dart';

import 'ad_details_screen.dart';

class AdListTile extends StatelessWidget {
  final Ad ad;

  AdListTile(this.ad);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        color: Style.primaryColor,
        child: ad.photos != null && ad.photos.length > 0 ?
          Hero(tag: "ad-image-" + ad.id.toString(), child: Image.network(ad.photos[0].url, fit: BoxFit.cover,))
         : Icon(Icons.group, color: Style.primaryColorDark,),
      ),
      title: Text(ad.title),
      subtitle: Text(ad.description, maxLines: 3, overflow: TextOverflow.ellipsis,),
      isThreeLine: true,
      visualDensity: VisualDensity.compact,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AdDetailsScreen(ad))
      ),
    );
  }
}
