import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/group.dart';

class GroupsProvider extends ChangeNotifier {
  static const GROUPS_PUBLIC_URL = "group/public_list";
  static const GROUPS_USER_URL = "group/list";

  ApiHelper apiHelper = ApiHelper();
  List<Group> _publicGroups;
  List<Group> _userGroups;
  List<Group> get publicGroups => _publicGroups;
  List<Group> get userGroups => _userGroups;

  GroupsProvider(){
    print("Group service created");
    loadPublicGroups();
  }

  set publicGroups(List<Group> groups) {
    _publicGroups = groups;
    notifyListeners();
  }

  set userGroups(List<Group> groups) {
    _userGroups = groups;
    notifyListeners();
  }

  /// Returns true if successfully loaded groups, otherwise throws an exception.
  Future<void> loadPublicGroups({bool forceLoad=false}) async {
    if(_publicGroups != null && !forceLoad) {
      return;
    }

    try {
      var responseJson = await apiHelper.get(null, GROUPS_PUBLIC_URL);
      _publicGroups = parseGroups(responseJson);
    } on Exception {
      _publicGroups = [];
    }
    notifyListeners();
  }

  Future<void> loadUserGroups(BuildContext context, {bool forceLoad=false}) async {
    if(_userGroups != null && !forceLoad){
      return;
    }

    try {
      var responseJson = await apiHelper.get(context, GROUPS_USER_URL);
      _userGroups = parseGroups(responseJson);
    } on Exception {
      _userGroups = [];
    }
    notifyListeners();
  }

  List<Group> parseGroups(dynamic jsonData){
    List<dynamic> jsonGroups = jsonData['data'];
    List<Group> groups = [];
    for (dynamic obj in jsonGroups) {
      try {
        groups.add(Group.fromJson(obj));
      } catch (e) {}
    }
    return groups;
  }
}