import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/ad/ad_overlay_gallery.dart';
import 'package:trocado_flutter/model/ad.dart';

class AdDetailsScreen extends StatefulWidget {
  final Ad ad;
  AdDetailsScreen(this.ad);

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  bool showingGallery = false;

  void _onTapImageCount() {
    setState(() {
      showingGallery = true;
    });
  }

  void closeGalleryCallback(){
    setState(() {
      showingGallery = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                title: widget.ad.firstPhoto != null ? null : const Icon(Icons.no_photography_outlined),
                expandedHeight: widget.ad.firstPhoto != null ? 240 : 60,
                flexibleSpace: widget.ad.firstPhoto != null
                    ? Stack(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                  child: Hero(
                                      tag: "ad-image-" + widget.ad.id.toString(),
                                      child: Image.network(widget.ad.firstPhoto.url, fit: BoxFit.cover))),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(14))),
                                    color: Colors.white54),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt,
                                      size: 22,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        widget.ad.photos.length.toString(),
                                        style: const TextStyle(fontSize: 20),
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
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      widget.ad.title,
                      style: const TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(
                      color: Style.accentColor, height: 4, thickness: 2, indent: 20, endIndent: 20),
                ]),
              ),
            ],
          ),
          showingGallery ? AdOverlayGallery(widget.ad.photos, closeGalleryCallback) : Container(),
        ],
      ),
    );
  }
}
