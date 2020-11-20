import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/addresses/address_provider.dart';
import 'package:trocado_flutter/feature/group/groups_provider.dart';
import 'package:trocado_flutter/model/ad.dart';
import 'package:trocado_flutter/model/address.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/model/photo.dart';
import 'package:trocado_flutter/widget/dialog.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';
import 'package:image_picker/image_picker.dart';

import 'ads_provider.dart';

const double IMAGE_SIZE = 65;

class CreateAdScreen extends StatefulWidget {
  final Ad existingAd;

  CreateAdScreen({this.existingAd});

  @override
  _CreateAdScreenState createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  Ad ad;
  List<Widget> _body;
  int _step;
  bool editing, loading = false;
  List<File> newImages = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();

  int totalImageCount() {
    int count = newImages.length;

    if (ad.photos != null) {
      count += ad.photos.length;
    }

    return count;
  }

  List<Widget> imageList() {
    List<Widget> imageList = [];

    if (ad != null && ad.photos != null)
      for (Photo photo in ad.photos) {
        imageList.add(GestureDetector(
          child: Image.network(
            photo.url,
            width: IMAGE_SIZE,
            height: IMAGE_SIZE,
          ),
          onTap: () => showRemoveDialog(() {
            ad.photos.remove(photo);
            Navigator.of(context).pop();
            setState(() {});
          }),
        ));
      }

    if (newImages != null)
      for (File file in newImages) {
        imageList.add(GestureDetector(
          child: Image.file(
            file,
            width: IMAGE_SIZE,
            height: IMAGE_SIZE,
          ),
          onTap: () => showRemoveDialog(() {
            newImages.remove(file);
            Navigator.of(context).pop();
            setState(() {});
          }),
        ));
      }

    return imageList;
  }

  void showRemoveDialog(Function() callback) {
    DefaultDialog.show(context,
        title: "Apagar Imagem",
        message: "Deseja apagar essa imagem do anúncio?",
        okCallback: callback);
  }

  @override
  void initState() {
    _step = 1;

    if (widget.existingAd == null) {
      ad = Ad();
      editing = false;
    } else {
      ad = widget.existingAd;
      editing = true;
    }
    super.initState();

    Provider.of<AddressProvider>(context, listen: false).loadUserAddresses(context);
    Provider.of<GroupsProvider>(context, listen: false).loadUserGroups(context);
  }

  List<Widget> buildCurrentPage(BuildContext context) {
    switch (_step) {
      case 1:
        return _adStep1(context);
        break;
      case 2:
        return _adStep2(context);
        break;
      default:
        return null;
        break;
    }
  }

  void nextPage(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    switch (_step) {
      case 1:
        _step = 2;
        setState(() {});
        break;
      default:
        break;
    }
  }

  void previousPage(BuildContext context) {
    switch (_step) {
      case 1:
        Navigator.of(context).pop();
        break;
      case 2:
        _step = 1;
        _body = _adStep1(context);
        ad.photoFiles = newImages;
        setState(() {});
        break;
      case 3:
        _step = 2;
        _body = _adStep2(context);
        setState(() {});
        break;
      default:
        break;
    }
  }

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(
        source: imageSource, imageQuality: 85, maxHeight: 1000, maxWidth: 1000);

    setState(() {
      if (pickedFile != null) {
        newImages.add(File(pickedFile.path));
        setState(() {});
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _body = buildCurrentPage(context);

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: trocadoAppBar("Detalhes do Anúncio"),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _formKey,
                  child: ListView(
                    children: _body,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Title and Description
  List<Widget> _adStep1(BuildContext context) {
    return [
      TextFormField(
        validator: (value) => value.isEmpty || value.length < 3 || value.length > 150
            ? "Deve ter de 3 a 150 caracteres"
            : null,
        decoration: InputDecoration(
            hintText: "Ex: Mesa de Madeira...", labelText: "Título", icon: Icon(Icons.short_text)),
        initialValue: ad.title,
        onSaved: (val) => ad.title = val,
      ),
      TextFormField(
        validator: (value) => value.isEmpty || value.length < 20 || value.length > 500
            ? "Deve ter de 20 a 500 caracteres"
            : null,
        decoration: InputDecoration(
            hintText: "Fale sobre seu item...",
            labelText: "Descrição",
            icon: Icon(Icons.description)),
        initialValue: ad.description,
        onSaved: (val) => ad.description = val,
        maxLines: 3,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text("Fotos (Até 5 imagens)"),
      ),
      totalImageCount() < 5
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => getImage(ImageSource.gallery),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("Galeria"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 6,
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => getImage(ImageSource.camera),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("Câmera"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: imageList(),
      ),
      RaisedButton(
        child: Text("Continuar"),
        onPressed: () => nextPage(context),
        padding: EdgeInsets.all(14),
        color: Style.accentColor,
        textColor: Style.clearWhite,
      ),
    ];
  }

  // Groups and Addresses selection
  List<Widget> _adStep2(BuildContext context) {
    AddressProvider addressProvider = Provider.of<AddressProvider>(context, listen: false);
    GroupsProvider groupsProvider = Provider.of<GroupsProvider>(context, listen: false);

    return [
      Text("Endereços de Retirada do Item (visível apenas para o Receptor)"),
      Container(
        height: 180,
        child: ListView.builder(
          itemCount: addressProvider.userAddresses.length,
          itemBuilder: (context, i) {
            Address address = addressProvider.userAddresses[i];
            return CheckboxListTile(
              value: ad.addresses.contains(address),
              onChanged: (bool checked) {
                if (checked) {
                  ad.addAddress(address);
                } else {
                  ad.removeAddress(address);
                }
                setState(() {});
              },
              title: Text(address.title),
              subtitle: Text(address.street),
            );
          },
        ),
      ),
      Text("Grupos Disponíveis"),
      Container(
        height: 180,
        child: ListView.builder(
          itemCount: groupsProvider.userGroups.length,
          itemBuilder: (context, i) {
            Group group = groupsProvider.userGroups[i];
            return CheckboxListTile(
              value: ad.containsGroup(group),
              onChanged: (bool checked) {
                if (checked) {
                  ad.addGroup(group);
                } else {
                  ad.removeGroup(group);
                }
                setState(() {});
              },
              title: Text(group.name),
            );
          },
        ),
      ),
      Divider(),
      RaisedButton(
        child: loading ? CircularProgressIndicator() : const Text("Publicar Anúncio"),
        onPressed: () => _publish(context),
        padding: EdgeInsets.all(14),
        color: Colors.green,
        textColor: Style.clearWhite,
      ),
      RaisedButton(
        child: Text("Voltar"),
        onPressed: () => previousPage(context),
        color: Colors.orange[100],
      ),
    ];
  }

  // Loading and Success message
  Future _publish(BuildContext context) async {
    if (loading) return;
    setState(() {
      loading = true;
    });

    if(ad.addresses.length == 0){
      showErrorSnack("Selecione pelo menos um endereço");
      return;
    } else if(ad.groups.length == 0){
      showErrorSnack("Selecione pelo menos um grupo");
      return;
    }

    ad.photoFiles = newImages;
    Provider.of<AdsProvider>(context, listen: false).createAd(context, ad).then((bool result) {
      showSuccessSnack("Anúncio publicado!");
      Future.delayed(Duration(seconds: 2), () {
        // 5s over, navigate to a new page
        Navigator.of(context).pop();
      });
    }).catchError((e) {
      showErrorSnack(e.toString());
    });
  }

  Future<bool> onWillPop() async {
    previousPage(context);
    return false;
  }

  void showErrorSnack(String message) {
    setState(() {
      loading = false;
    });
    print(message);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void showSuccessSnack(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }
}
