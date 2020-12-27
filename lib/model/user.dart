import 'package:flutter/material.dart';

class User {
  int id;
  String name, lastName;
  String email;
  String profilePhotoUrl;
  int accountStatusId;

  /// Present only in requests through groups, with Pivot column
  bool isModerator;
  DateTime createdAt;

  int donationCount, purchaseCount, groupCount;

  String get fullName => name + " " + lastName;
  String get creationDate =>
      createdAt.day.toString() + "/" + createdAt.month.toString() + "/" + createdAt.year.toString();

  User.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.name = json['name'];
    this.lastName = json['last_name'] ?? "";
    this.email = json['email'] ?? "";
    this.profilePhotoUrl = json['profile_photo_url'];
    this.accountStatusId = json['account_status_id'] ?? 1;
    this.isModerator = json['is_moderator'] != null ? json['is_moderator'] : (json['pivot'] != null && json['pivot']['is_moderator'] != null ? json['pivot']['is_moderator'] == 1 : false);
    this.createdAt = DateTime.tryParse(json['created_at']) ?? DateTime.now();
    this.donationCount = json['donation_count'];
    this.purchaseCount = json['purchase_count'];
    this.groupCount = json['group_count'];
  }

  /// Returns a JSON only with fields for the account update
  Map<String, String> toJson() => {
        'id': this.id.toString(),
        'name': this.name,
        'last_name': this.lastName,
      };

  bool get hasAvatar => profilePhotoUrl != null && profilePhotoUrl.isNotEmpty;

  ImageProvider get avatarImage => hasAvatar
      ? NetworkImage(
          profilePhotoUrl,
          scale: 1,
        )
      : profileImagePlaceholder;

  static const ImageProvider profileImagePlaceholder = AssetImage("assets/profile-placeholder.png");

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != this.runtimeType) {
      return false;
    }

    User otherUser = other;
    return this.id == otherUser.id || this.email == otherUser.email;
  }
}
