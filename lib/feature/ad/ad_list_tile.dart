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
        height: 50,
        color: Style.primaryColor,
        child: ad.photos != null && ad.photos.isNotEmpty
            ? Hero(
                tag: "ad-image-" + ad.id.toString(),
                child: Image.network(
                  ad.photos[0].url,
                  fit: BoxFit.cover,
                ))
            : const Icon(Icons.no_photography_outlined, color: Style.darkText),
      ),
      title: Text(ad.title),
      trailing: Text(
        ad.distance.toStringAsFixed(0) + "m",
        style: const TextStyle(color: Colors.black45, fontSize: 12),
      ),
      subtitle: Text(
        ad.description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      visualDensity: VisualDensity.compact,
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AdDetailsScreen(ad))),
    );
  }
}
