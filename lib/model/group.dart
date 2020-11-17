import 'package:trocado_flutter/model/user.dart';
import 'package:trocado_flutter/response/ads_list.dart';

import 'group_join_request.dart';

class Group {
  int id;
  String name, description;
  bool private = false, isModerator = false, isMember = false;
  int adCount, memberCount;
  List<User> moderators = [];
  /// Available only when the user is a moderator of the group
  List<User> members = [];
  /// Available only when the user is a moderator of the group
  List<GroupJoinRequest> groupJoinRequests = [];
  /// Optional field, loaded only when the user sees the full group page.
  AdsListResponse adsRequest;

  Group.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.description = json['description'];
    this.private = json['private'] == 0 ? false : true;
    this.isModerator = json['is_moderator'];
    this.adCount = json['ad_count'];
    this.memberCount = json['member_count'];
    this.isMember = json['is_member'];

    if(json['moderators'] != null)
      for(dynamic obj in json['moderators'])
        moderators.add(User.fromJson(obj));

    if(json['members'] != null)
      for(dynamic obj in json['members'])
        members.add(User.fromJson(obj));

    if(json['group_join_requests'] != null)
      for(dynamic obj in json['group_join_requests'])
        groupJoinRequests.add(GroupJoinRequest.fromJson(obj));
  }
}