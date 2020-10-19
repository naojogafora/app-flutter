import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/exception/app_exception.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/response/group_join.dart';
import 'package:trocado_flutter/response/group_list.dart';

class GroupsProvider extends ChangeNotifier {
  static const GROUPS_PUBLIC_URL = "group/public_list";
  static const GROUPS_USER_URL = "group/list";
  static const JOIN_URL = "group/{GROUP_ID}/join";
  static const LEAVE_URL = "group/{GROUP_ID}/leave";

  ApiHelper apiHelper = ApiHelper();
  GroupListResponse _publicGroups;
  GroupListResponse _userGroups;
  List<Group> get publicGroups => _publicGroups?.data;
  List<Group> get userGroups => _userGroups?.data;

  GroupsProvider(){
    try {
      loadPublicGroups();
    } catch (e){}
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

    JoinGroupResponse joinResponse;
    var responseJson;

    try {
      responseJson = await apiHelper.post(context, joinUrl, body: body);
      joinResponse = JoinGroupResponse.fromJson(responseJson);
    } on AppException catch (e) {
      joinResponse = JoinGroupResponse(e.toString());
    }

    if(joinResponse.joined){
      loadUserGroups(context, forceLoad: true);
    }
    return joinResponse;
  }

  /// Returns true if the user left the group, or throws an exception otherwise.
  Future<bool> leaveGroup(BuildContext context, Group group) async {
    if(group.id == null || !group.isMember) throw new Exception("Grupo Inválido");

    String url = LEAVE_URL.replaceAll("{GROUP_ID}", group.id.toString());
    await apiHelper.post(context, url);
    _userGroups.data.remove(group);
    notifyListeners();
    return true;
  }

  GroupListResponse _parseGroups(dynamic jsonData){
    return GroupListResponse.fromJson(jsonData);
  }
}
