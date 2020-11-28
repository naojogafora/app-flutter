import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/model/photo.dart';

class AdOverlayGallery extends StatefulWidget {
  final List<Photo> photos;
  final VoidCallback closeCallback;

  AdOverlayGallery(this.photos, this.closeCallback);

  @override
  _AdOverlayGalleryState createState() => _AdOverlayGalleryState();
}

class _AdOverlayGalleryState extends State<AdOverlayGallery> {
  int currentPhoto;
  List<Image> loadedImages = [];

  @override
  void initState() {
    super.initState();
    currentPhoto = 0;
    widget.photos.forEach((e) => loadedImages.add(Image.network(e.url, fit: BoxFit.fitWidth)));
  }

  void previousPhoto() {
    if (hasPreviousPhoto()) {
      setState(() {
        currentPhoto--;
      });
    }
  }

  void nextPhoto() {
    if (hasNextPhoto()) {
      setState(() {
        currentPhoto++;
      });
    }
  }

  bool hasNextPhoto() => currentPhoto < widget.photos.length - 1;
  bool hasPreviousPhoto() => currentPhoto > 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.closeCallback,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        color: Colors.black54,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.closeCallback,
                  iconSize: 42,
                  color: Style.clearWhite,
                ),
                alignment: Alignment.centerRight,
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(child: loadedImages[currentPhoto], color: Style.primaryColor),
                  onTap: () {},
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.keyboard_arrow_left),
                      onPressed: previousPhoto,
                      iconSize: 56,
                      color: hasPreviousPhoto() ? Style.clearWhite : Colors.white38),
                  Text(
                    (currentPhoto + 1).toString() + "/" + widget.photos.length.toString(),
                    style: const TextStyle(color: Style.clearWhite, fontSize: 16),
                  ),
                  IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right),
                      onPressed: nextPhoto,
                      iconSize: 56,
                      color: hasNextPhoto() ? Style.clearWhite : Colors.white38),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
