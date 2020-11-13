import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/model/ad.dart';

import 'ad_details_screen.dart';
import 'ads_provider.dart';

class MyAdListTile extends StatelessWidget {
  final Ad ad;

  MyAdListTile(this.ad);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Container(
        width: 50,
        height: 50,
        color: Style.primaryColor,
        child: ad.photos != null && ad.photos.length > 0
            ? Hero(
                tag: "ad-image-" + ad.id.toString(),
                child: Image.network(
                  ad.photos[0].url,
                  fit: BoxFit.cover,
                ))
            : Icon(
                Icons.no_photography_outlined,
                color: Style.primaryColorDark,
              ),
      ),
      title: Text(ad.title),
      subtitle: Text(
        "Anunciado em " + ad.groups.length.toString() + " grupo" + (ad.groups.length != 1 ? "s" : ""),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.visibility, color: Colors.blue),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AdDetailsScreen(ad))),
            ),
            IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => null))), //TODO Edit ad
            IconButton(
                icon: Icon(Icons.delete, color: Colors.red,),
                onPressed: () async {
                  String message;
                  Color color = Colors.green;
                  try {
                    await Provider.of<AdsProvider>(context, listen: false)
                        .deleteAd(context, ad);
                    message = "Anúncio apagado";
                  } catch (e) {
                    color = Colors.red;
                    message = e.toString();
                  }

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                      backgroundColor: color,
                    ));
                  });
                }),
          ],
        ),
      ],
    );
  }
}
