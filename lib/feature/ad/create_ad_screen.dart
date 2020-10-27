import 'package:flutter/material.dart';
import 'package:trocado_flutter/model/ad.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class CreateAdScreen extends StatefulWidget {
  final Ad existingAd;

  CreateAdScreen({this.existingAd});

  @override
  _CreateAdScreenState createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {

  Ad ad;
  Widget _body;
  int _step;
  bool editing;

  @override
  void initState() {
    _body = _adStep1(context);
    _step = 1;

    if(widget.existingAd == null){
      ad = Ad();
      editing = false;
    } else {
      ad = widget.existingAd;
      editing = true;
    }

    super.initState();
  }

  void nextPage(BuildContext context){
    switch(_step){
      case 1:
        _step = 2;
        _body = _adStep2(context);
        setState(() {});
        break;
      case 2:
        _step = 3;
        _body = _adStep3(context);
        setState(() {});
        break;
      case 3:
        _step = 4;
        _body = _adStep4(context);
        setState(() {});
        break;
      default:
        break;
    }
  }

  void previousPage(BuildContext context){
    switch(_step){
      case 1:
        Navigator.of(context).pop();
        break;
      case 2:
        _step = 1;
        _body = _adStep1(context);
        setState(() {});
        break;
      case 3:
        _step = 2;
        _body = _adStep2(context);
        setState(() {});
        break;
      case 4:
        _step = 3;
        _body = _adStep3(context);
        setState(() {});
        break;
      default:
        break;
    }
  }

  Future<bool> submit() async {
    try {
      //TODO Send to the API
    } catch (e) {
      //TODO Just throws exceptions, if any.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Novo Anúncio"),
      body: _body,
    );
  }

  // Title and Description
  Widget _adStep1(BuildContext context) {
    return Container();
  }

  // Photo Selection
  Widget _adStep2(BuildContext context) {
    return Container();
  }

  // Groups and Addresses selection
  Widget _adStep3(BuildContext context) {
    return Container();
  }

  // Loading and Success message
  Widget _adStep4(BuildContext context) {
    return Center(
        child: FutureBuilder<bool>(
          future: submit(),
          builder: (context, snapshot){
            if(!snapshot.hasData && !snapshot.hasError){
              return CircularProgressIndicator();
            }

            if(snapshot.hasError){
              Future.delayed(Duration(seconds: 3), () {
                // 5s over, navigate to a new page
                previousPage(context);
              });
              //TODO Show error message
              return Icon(Icons.close, color: Colors.red);
            }

            Future.delayed(Duration(seconds: 3), () {
              // 5s over, navigate to a new page
              Navigator.of(context).pop();
            });

            //TODO Show success message
            return Icon(Icons.check_circle, color: Colors.green);
          },
        )
    );
  }
}
