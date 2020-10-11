import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/group.dart';

class GroupsService {
  ApiHelper apiHelper = ApiHelper();
  static const GROUPS_PUBLIC_URL = "group/public_list";
  List<Group> groups = [];

  Future<dynamic> publicGroups() async {
    var responseJson = await apiHelper.get(GROUPS_PUBLIC_URL);
    return responseJson;
  }
}