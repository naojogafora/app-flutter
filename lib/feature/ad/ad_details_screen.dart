import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/account/profile_view_screen.dart';
import 'package:trocado_flutter/feature/ad/ad_overlay_gallery.dart';
import 'package:trocado_flutter/feature/ad/ads_provider.dart';
import 'package:trocado_flutter/feature/transactions/my_orders_screen.dart';
import 'package:trocado_flutter/model/ad.dart';
import 'package:trocado_flutter/model/transaction.dart';

class AdDetailsScreen extends StatefulWidget {
  final Ad ad;
  AdDetailsScreen(this.ad);

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  bool showingGallery = false, loading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onTapImageCount() {
    setState(() {
      showingGallery = true;
    });
  }

  void closeGalleryCallback() {
    setState(() {
      showingGallery = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                title:
                    widget.ad.firstPhoto != null ? null : const Icon(Icons.no_photography_outlined),
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
                                      child: Image.network(widget.ad.firstPhoto.url,
                                          fit: BoxFit.cover))),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            widget.ad.title,
                            style: const TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Divider(
                            color: Style.accentColor,
                            height: 16,
                            thickness: 2,
                            indent: 6,
                            endIndent: 6),
                        Text(
                          "Descrição:",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.ad.description, style: const TextStyle(fontSize: 18)),
                        ),
                        const Divider(height: 12, color: Colors.transparent),
                        Text(
                          "Doaçao por: ",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        ListTile(
                          title: Text(
                            widget.ad.user.fullName,
                            style: TextStyle(color: Style.primaryColorDark, fontSize: 18),
                          ),
                          subtitle: Text("Usuário desde " + widget.ad.user.creationDate),
                          leading: Hero(
                            child: CircleAvatar(backgroundImage: widget.ad.user.avatarImage),
                            tag: "user_" + widget.ad.user.id.toString(),
                          ),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileViewScreen(widget.ad.user))),
                        ),
                        //TODO Questions & Answers
                        const Divider(height: 12, color: Colors.transparent),
                        Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                padding: EdgeInsets.all(12),
                                child: loading
                                    ? CircularProgressIndicator(backgroundColor: Style.clearWhite)
                                    : const Text("Eu Quero!",
                                        style: TextStyle(
                                          color: Style.clearWhite,
                                          fontSize: 18,
                                        )),
                                color: Style.accentColor,
                                onPressed: purchase,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          showingGallery ? AdOverlayGallery(widget.ad.photos, closeGalleryCallback) : Container(),
        ],
      ),
    );
  }

  void purchase() {
    if (loading) return;
    setState(() {
      loading = true;
    });

    Provider.of<AdsProvider>(context, listen: false)
        .purchaseAd(context, widget.ad)
        .then((Transaction transaction) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MyOrdersScreen()));
    }).catchError(handleError);
  }

  void handleError(e, st) {
    debugPrintStack(stackTrace: st);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(e.toString()),
      backgroundColor: Colors.red,
    ));
    setState(() {
      loading = false;
    });
  }
}
