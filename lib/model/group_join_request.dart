import 'package:trocado_flutter/model/user.dart';

class GroupJoinRequest {
  int id;
  int groupId;
  User user;
  String message;

  GroupJoinRequest.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.groupId = json['group_id'];
    this.user = User.fromJson(json['user']);
    this.message = json["message"] ?? "N/A";
  }
}