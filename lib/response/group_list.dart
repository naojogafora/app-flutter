import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/response/paginated_list.dart';

class GroupListResponse {
  PaginatedList paginatedList;
  List<Group> data;

  GroupListResponse.fromJson(Map<String, dynamic> json){
    this.paginatedList = PaginatedList.fromJson(json);

    this.data = [];
    for(dynamic objFields in json["data"]){
      this.data.add(Group.fromJson(objFields));
    }
  }

}