import 'package:trocado_flutter/model/user.dart';
import 'package:trocado_flutter/response/ads_list.dart';

import 'group_join_request.dart';

class Group {
  int id;
  String name, description;
  String inviteCode;
  bool private = false, isModerator = false, isMember = false;
  int adCount, memberCount;
  User owner;
  List<User> moderators = [];

  /// Available only when the user is a moderator of the group
  List<User> members = [];

  /// Available only when the user is a moderator of the group
  List<GroupJoinRequest> groupJoinRequests = [];

  /// Optional field, loaded only when the user sees the full group page.
  AdsListResponse adsRequest;

  Group();

  Group.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.description = json['description'];
    this.inviteCode = json['invite_code'];
    this.private = json['private'] == 0 ? false : true;
    this.isModerator = json['is_moderator'];
    this.adCount = json['ad_count'];
    this.memberCount = json['member_count'];
    this.isMember = json['is_member'];

    if (json['moderators'] != null)
      for (dynamic obj in json['moderators']) moderators.add(User.fromJson(obj));

    if (json['members'] != null)
      for (dynamic obj in json['members']) members.add(User.fromJson(obj));

    if (json['group_join_requests'] != null)
      for (dynamic obj in json['group_join_requests'])
        groupJoinRequests.add(GroupJoinRequest.fromJson(obj));

    if (json['owner'] != null) this.owner = User.fromJson(json['owner']);
  }

  /// JSON with fields required on the Create POST Route of the API
  Map<String, String> toCreateJson() => {
        "name": this.name,
        "description": this.description,
        "private": this.private ? "1" : "0",
      };

  Map<String, String> toSaveConfigurationsJson() {
    Map<String, String> json = {
      "name": this.name,
      "description": this.description,
      "private": this.private ? "1" : "0",
      "owner_id": this.owner.id?.toString(),
      "invite_code": this.inviteCode == null || this.inviteCode.isEmpty ? "" : this.inviteCode,
    };
  }
}
