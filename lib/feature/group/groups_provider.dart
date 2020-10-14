import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/group.dart';

class GroupsProvider extends ChangeNotifier {
  static const GROUPS_PUBLIC_URL = "group/public_list";
  static const GROUPS_USER_URL = "group/list";
  static const JOIN_URL = "group/{GROUP_ID}/join";

  ApiHelper apiHelper = ApiHelper();
  List<Group> _publicGroups;
  List<Group> _userGroups;
  List<Group> get publicGroups => _publicGroups;
  List<Group> get userGroups => _userGroups;

  GroupsProvider(){
    try {
      loadPublicGroups();
    } catch (e){}
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
      _publicGroups = _parseGroups(responseJson);
    } catch (e) {
      if(!forceLoad)
        _publicGroups = [];
      throw e;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadUserGroups(BuildContext context, {bool forceLoad=false}) async {
    if(_userGroups != null && !forceLoad){
      return;
    }

    try {
      var responseJson = await apiHelper.get(context, GROUPS_USER_URL);
      _userGroups = _parseGroups(responseJson);
    } finally {
      notifyListeners();
    }
  }

  /// Join a group.
  /// Throws an exception if the user is already in the group.
  /// @param Message is an optional param with a message to the admins of the group.
  Future<JoinGroupResponse> joinGroup(BuildContext context, Group group, {String message}) async {
    String joinUrl = JOIN_URL.replaceAll("{GROUP_ID}", group.id.toString());

    Map<String, String> body;
    if(group.private && message != null && message.isNotEmpty){
      body = {"message": message};
    }

    var responseJson = await apiHelper.post(context, joinUrl, body: body);
    return JoinGroupResponse.fromJson(responseJson);
  }

  List<Group> _parseGroups(dynamic jsonData){
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

class JoinGroupResponse {
  String message;
  bool joined;
  JoinGroupResponse.fromJson(Map<String, dynamic> json){
    this.message = json['message'];
    this.joined = json['joined'];
  }
}