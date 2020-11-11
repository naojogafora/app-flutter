import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/model/ad.dart';

import 'ad_details_screen.dart';

class MyAdListTile extends StatelessWidget {
  final Ad ad;

  MyAdListTile(this.ad);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Container(
        width: 50,
        color: Style.primaryColor,
        child: ad.photos != null && ad.photos.length > 0
            ? Hero(
                tag: "ad-image-" + ad.id.toString(),
                child: Image.network(
                  ad.photos[0].url,
                  fit: BoxFit.cover,
                ))
            : Icon(
                Icons.group,
                color: Style.primaryColorDark,
              ),
      ),
      title: Text(ad.title),
      subtitle: Text(
        "Anunciado em " + ad.groups.length.toString() + " grupos",
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AdDetailsScreen(ad))),
            ),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => null))), //TODO Edit ad
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => null))), //TODO Delete ad
          ],
        ),
      ],
    );
  }
}
