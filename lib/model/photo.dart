class Photo {
  int id, order, advertisementId;
  String url;

  Photo.fromJson(Map<String, dynamic> json){
    this.id = json["id"];
    this.advertisementId = json["advertisement_id"];
    this.order = json["order"];
    this.url = json["url"];
  }
}