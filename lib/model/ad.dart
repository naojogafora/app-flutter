import 'package:trocado_flutter/model/photo.dart';
import 'package:trocado_flutter/model/user.dart';

class Ad {
  int id;
  bool finished, suspended;
  User user;
  String title, description;
  List<Photo> photos;
  DateTime createdAt, updatedAt;

  get firstPhoto => photos != null && photos.length > 0 ? photos[0] : null;

  Ad(){
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

    this.photos = [];
    for(dynamic photoArray in json['photos']){
      photos.add(Photo.fromJson(photoArray));
    }
  }
}