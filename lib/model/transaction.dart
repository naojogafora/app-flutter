import 'package:trocado_flutter/model/ad.dart';
import 'package:trocado_flutter/model/user.dart';

class Transaction {
  int id;
  int buyerId, advertisementId;
  DateTime createdAt, updatedAt;
  Ad advertisement;
  User buyer;

  User get seller => advertisement.user;
  String get creationDate =>
      createdAt.day.toString() + "/" + createdAt.month.toString() + "/" + createdAt.year.toString();

  Transaction.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.buyerId = json["buyer_id"];
    this.advertisementId = json["advertisement_id"];
    this.createdAt = DateTime.parse(json["created_at"]);
    this.updatedAt = DateTime.parse(json["updated_at"]);
    this.advertisement = Ad.fromJson(json["advertisement"]);
    this.buyer = User.fromJson(json["buyer"]);
  }
}
