class TrocadoCoordinates {
  double lat, lng;

  TrocadoCoordinates({this.lat, this.lng});

  TrocadoCoordinates.fromJson(Map<String, dynamic> json) {
    this.lat = json['lat'];
    this.lng = json['lng'];
  }
}
