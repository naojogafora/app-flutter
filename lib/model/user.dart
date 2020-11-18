import 'package:flutter/material.dart';

class User {
  int id;
  String name, lastName;
  String email;
  int accountStatusId;
  /// Present only in requests through groups, with Pivot column
  bool isModerator;
  DateTime createdAt;

  String get fullName => name + " " + lastName;
  String get creationDate => createdAt.day.toString() + "/" + createdAt.month.toString() + "/" + createdAt.year.toString();

  Widget avatarImage({@required double radius}) => Icon(Icons.person, size: radius);

  User.fromJson(Map<String, dynamic> json){
    this.id = json["id"];
    this.name = json['name'];
    this.lastName = json['last_name'] ?? "";
    this.email = json['email'] ?? "";
    this.accountStatusId = json['account_status_id'] ?? 1;
    this.isModerator = json['is_moderator'] ?? false;
    this.createdAt = DateTime.tryParse(json['created_at']) ?? DateTime.now();
  }
}