import 'package:trocado_flutter/response/ads_list.dart';

class Group {
  int id;
  String name, description;
  bool private = false, isModerator = false, isMember = false;
  int adCount, memberCount;

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
  }
}