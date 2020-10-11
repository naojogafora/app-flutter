import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/group.dart';

class GroupsService extends ChangeNotifier {
  static const GROUPS_PUBLIC_URL = "group/public_list";

  ApiHelper apiHelper = ApiHelper();
  List<Group> _groups = [];
  List<Group> get groups => _groups;

  GroupsService(){
    print("Group service created");
    loadPublicGroups();
  }

  set groups(List<Group> groups) {
    _groups = groups;
    notifyListeners();
  }

  /// Returns true if successfully loaded groups, otherwise throws an exception.
  Future<void> loadPublicGroups({bool forceLoad=false}) async {
    if(_groups.isNotEmpty && !forceLoad) {
      return;
    }

    var responseJson = await apiHelper.get(GROUPS_PUBLIC_URL);
    parseGroups(responseJson);
  }

  void parseGroups(dynamic jsonData){
    List<dynamic> jsonGroups = jsonData['data'];
    for (dynamic obj in jsonGroups) {
      try {
        _groups.add(Group.fromJson(obj));
      } catch (e) {}
    }
    notifyListeners();
  }
}