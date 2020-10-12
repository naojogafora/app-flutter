class Group {
  int id;
  String name, description;
  bool private, isModerator = false;
  int adCount, memberCount;

  Group.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.description = json['description'];
    this.private = json['private'] == 0 ? false : true;
    this.isModerator = json['pivot'] != null && json['pivot']['is_moderator'] == 1 ? true : false;
    this.adCount = json['ad_count'];
    this.memberCount = json['member_count'];
  }
}