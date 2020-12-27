import 'package:trocado_flutter/model/ad.dart';
import 'package:trocado_flutter/response/paginated_list.dart';

class AdsListResponse {
  PaginatedList paginatedList;
  List<Ad> data;

  AdsListResponse(){
    this.data = [];
  }

  AdsListResponse.fromJson(Map<String, dynamic> json) {
    this.paginatedList = PaginatedList.fromJson(json);

    this.data = [];
    for (dynamic adArray in json["data"]) {
      this.data.add(Ad.fromJson(adArray));
    }
  }
}
