import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/model/ad.dart';

class AdDetailsScreen extends StatelessWidget {
  final Ad ad;
  AdDetailsScreen(this.ad);

  void _onTapImageCount() {
    //TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Anúncio"),
            floating: true,
            expandedHeight: ad.firstPhoto != null ? 240 : 0,
            flexibleSpace: ad.firstPhoto != null
                ? Stack(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(child: Hero(tag: "ad-image-" + ad.id.toString(), child: Image.network(ad.firstPhoto.url, fit: BoxFit.cover))),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                color: Colors.white54),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 22,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    ad.photos.length.toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: _onTapImageCount,
                        ),
                      )
                    ],
                    alignment: Alignment.bottomRight,
                  )
                : Container(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.all(8),
                child: Text(ad.title, style: TextStyle(fontSize: 24), textAlign: TextAlign.center,),
              ),
              Divider(color: Style.accentColor, height: 4, thickness: 4, indent: 20, endIndent: 20,)
            ]),
          ),
        ],
      ),
    );
  }
}
