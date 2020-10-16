import 'package:trocado_flutter/model/coordinates.dart';

class Address {
  int id;
  String title;
  String street, city, state, zipCode, country;
  TrocadoCoordinates coordinates;

  Address();

  Address.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.title = json['title'];
    this.street = json['street'];
    this.city = json['city'];
    this.state = json['state'];
    this.zipCode = json['zip_code'];
    this.country = json['country'];
    //TODO
    //this.coordinates = TrocadoCoordinates.fromJson(json['coordinates']);
  }

  Map<String, dynamic> toJson() => {
    'title': this.title,
    'street': this.street,
    'city': this.city,
    'state': this.state,
    'zip_code': this.zipCode,
    'country': this.country,
  };
}