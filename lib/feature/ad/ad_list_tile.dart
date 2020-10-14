import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/model/ad.dart';

class AdListTile extends StatelessWidget {
  final Ad ad;

  AdListTile(this.ad);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ad.photos != null && ad.photos.length > 0 ?
        CircleAvatar(
          child: Image.network(ad.photos[0].url),
        )
       : Icon(Icons.group, color: Style.primaryColorDark,),
      title: Text(ad.title),
      subtitle: Text(ad.description, maxLines: 3, overflow: TextOverflow.ellipsis,),
      isThreeLine: true,

    );
  }
}
