import 'dart:io';

import 'package:trocado_flutter/model/photo.dart';
import 'package:trocado_flutter/model/user.dart';

import 'address.dart';
import 'group.dart';

class Ad {
  int id;
  bool finished, suspended;
  User user;
  String title, description;
  List<Photo> photos;
  DateTime createdAt, updatedAt;
  List<Address> addresses;
  List<Group> groups;
  List<File> photoFiles;

  get firstPhoto => photos != null && photos.length > 0 ? photos[0] : null;

  Ad(){
    photoFiles = [];
    photos = [];
    addresses = [];
    groups = [];
    finished = false;
    suspended = false;
  }

  Ad.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.finished = json['finished'] == 1;
    this.suspended = json['suspended'] == 1;
    this.user = User.fromJson(json['user']);
    this.title = json['title'];
    this.description = json['description'];
    this.createdAt = DateTime.parse(json['created_at']);
    this.updatedAt = DateTime.parse(json['updated_at']);

    this.groups = [];
    this.photos = [];
    for(dynamic photoArray in json['photos']){
      photos.add(Photo.fromJson(photoArray));
    }
  }

  // Every field must be String: String due to limitations of the POST body type.
  Map<String, String> toJson() {
    Map<String, String> json = {
    'title': this.title,
    'description': this.description,
    'finished': this.finished.toString(),
    'suspended': this.suspended.toString()
    };

    for(int i = 0; i < groups.length; i++) {
      json.addAll({ "group_ids[$i]": groups[i].id.toString() });
    }

    for(int i = 0; i < addresses.length; i++) {
      json.addAll({ "address_ids[$i]": addresses[i].id.toString() });
    }

    return json;
  }

  void addAddress(Address address){
    if(!containsAddress(address))
      addresses.add(address);
  }

  void removeAddress(Address address){
    if(containsAddress(address))
      addresses.removeWhere((element) => element.id == address.id);
  }

  bool containsAddress(Address address){
    return addresses.any((element) => element.id == address.id);
  }

  void addGroup(Group group){
    if(!containsGroup(group))
      groups.add(group);
  }
  void removeGroup(Group group){
    if(containsGroup(group))
      groups.removeWhere((element) => element.id == group.id);
  }

  bool containsGroup(Group group){
    return groups != null && groups.any((element) => element.id == group.id);
  }
}