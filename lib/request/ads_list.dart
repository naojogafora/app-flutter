import 'package:trocado_flutter/model/ad.dart';

class AdsListRequest {
  int currentPage, lastPage, perPage, from, to, total;
  String nextPageURL, prevPageURL, lastPageURL, firstPageURL;
  List<Ad> data;

  AdsListRequest.fromJson(Map<String, dynamic> json){
    this.currentPage = json["current_page"];
    this.lastPage = json["last_page"];
    this.perPage = json["per_page"];
    this.from = json["from"];
    this.to = json["to"];
    this.total = json["total"];
    this.nextPageURL = json["next_page_url"];
    this.prevPageURL = json["prev_page_url"];
    this.lastPageURL = json["last_page_url"];
    this.firstPageURL = json["first_page_url"];

    this.data = [];
    for(dynamic adArray in json["data"]){
      this.data.add(Ad.fromJson(adArray));
    }
  }
}