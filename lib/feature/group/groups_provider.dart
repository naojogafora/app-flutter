import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/exception/app_exception.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/model/group_join_request.dart';
import 'package:trocado_flutter/response/basic_message_response.dart';
import 'package:trocado_flutter/response/group_join.dart';
import 'package:trocado_flutter/response/group_list.dart';

class GroupsProvider extends ChangeNotifier {
  static const GROUPS_PUBLIC_URL = "group/public_list";
  static const GROUPS_USER_URL = "group/list";
  static const GROUPS_SEARCH_URL = "group/find?query={QUERY}";
  static const GROUPS_READ_URL = "group/{GROUP_ID}/read";
  static const JOIN_URL = "group/{GROUP_ID}/join";
  static const JOIN_CODE_URL = "group/{GROUP_ID}/join_by_invite_code";
  static const LEAVE_URL = "group/{GROUP_ID}/leave";
  static const CREATE_URL = "group/create";
  /* MODERATION ROUTES */
  static const UPDATE_JOIN_REQUEST = "group/{GROUP_ID}/update_join_request";
  static const BAN_URL = "group/{GROUP_ID}/ban";
  static const CONFIGURATION_URL = "group/{GROUP_ID}/configuration";
  static const ADD_MODERATOR_URL = "group/{GROUP_ID}/moderators";
  static const REMOVE_MODERATOR_URL = "group/{GROUP_ID}/moderators/{USER_ID}";

  ApiHelper apiHelper = ApiHelper();
  GroupListResponse _publicGroups;
  GroupListResponse _userGroups;
  List<Group> get publicGroups => _publicGroups?.data;
  List<Group> get userGroups => _userGroups?.data;

  GroupsProvider() {
    try {
      loadPublicGroups();
    } catch (_) {}
  }

  /// Returns true if successfully loaded groups, otherwise throws an exception.
  Future<GroupListResponse> loadPublicGroups({bool forceLoad = false}) async {
    if (_publicGroups != null && !forceLoad) {
      return _publicGroups;
    }

    try {
      var responseJson = await apiHelper.get(null, GROUPS_PUBLIC_URL);
      _publicGroups = _parseGroups(responseJson);
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }

    return _publicGroups;
  }

  Future<GroupListResponse> searchGroups(BuildContext context, String search) async {
    final String url = GROUPS_SEARCH_URL.replaceAll("{QUERY}", search);

    var responseJson = await apiHelper.get(context, url);
    return _parseGroups(responseJson);
  }

  Future<void> loadUserGroups(BuildContext context, {bool forceLoad = false}) async {
    if (_userGroups != null && !forceLoad) {
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
    if (group.private && message != null && message.isNotEmpty) {
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

    if (joinResponse.joined) {
      unawaited(loadUserGroups(context, forceLoad: true));
    }
    return joinResponse;
  }

  /// Join a group by invite code.
  /// Throws an exception if the user is already in the group.
  /// @param Message is an optional param with a message to the admins of the group.
  Future<JoinGroupResponse> joinGroupByInviteCode(
      BuildContext context, Group group, String code) async {
    String joinUrl = JOIN_CODE_URL.replaceAll("{GROUP_ID}", group.id.toString());
    Map<String, String> body = {"invite_code": code};
    JoinGroupResponse joinResponse;
    var responseJson;

    try {
      responseJson = await apiHelper.post(context, joinUrl, body: body);
      joinResponse = JoinGroupResponse.fromJson(responseJson);
    } on AppException catch (e) {
      joinResponse = JoinGroupResponse(e.toString());
    }

    if (joinResponse.joined) {
      unawaited(loadUserGroups(context, forceLoad: true));
    }
    return joinResponse;
  }

  /// Returns true if the user left the group, or throws an exception otherwise.
  Future<bool> leaveGroup(BuildContext context, Group group) async {
    if (group.id == null || !group.isMember) throw Exception("Grupo Inválido");

    String _url = LEAVE_URL.replaceAll("{GROUP_ID}", group.id.toString());
    await apiHelper.post(context, _url);
    _userGroups.data.remove(group);
    notifyListeners();
    return true;
  }

  GroupListResponse _parseGroups(dynamic jsonData) {
    return GroupListResponse.fromJson(jsonData);
  }

  /// Reads the group with all available attributes for a normal user or for a moderator
  Future<Group> readGroupDetails(BuildContext context, int id) async {
    String _url = GROUPS_READ_URL.replaceAll("{GROUP_ID}", id.toString());
    var response = await apiHelper.get(context, _url);
    return Group.fromJson(response);
  }

  Future<BasicMessageResponse> updateJoinRequest(BuildContext context, GroupJoinRequest request,
      {@required bool accept}) async {
    String _url = UPDATE_JOIN_REQUEST.replaceAll("{GROUP_ID}", request.groupId.toString());
    var response = await apiHelper.post(context, _url, body: {
      'id': request.id.toString(),
      'accept': accept ? "1" : "0",
    });

    return BasicMessageResponse.fromJson(response);
  }

  Future<BasicMessageResponse> banGroupMember(BuildContext context, int groupId, int userId) async {
    String _url = BAN_URL.replaceAll("{GROUP_ID}", groupId.toString());
    var response = await apiHelper.post(context, _url, body: {'user_id': userId.toString()});
    return BasicMessageResponse.fromJson(response);
  }

  Future<Group> createGroup(BuildContext context, Group group) async {
    var response = await apiHelper.post(context, CREATE_URL, body: group.toCreateJson());
    Group createdGroup = Group.fromJson(response);

    if (_userGroups?.data != null) {
      _userGroups.data.insert(0, createdGroup);
      notifyListeners();
    }

    return createdGroup;
  }

  Future<Group> readGroupConfiguration(BuildContext context, int groupId) async {
    String _url = CONFIGURATION_URL.replaceAll("{GROUP_ID}", groupId.toString());
    var response = await apiHelper.get(context, _url);
    return Group.fromJson(response);
  }

  Future<Group> saveGroupConfiguration(BuildContext context, Group group) async {
    String _url = CONFIGURATION_URL.replaceAll("{GROUP_ID}", group.id.toString());
    Map<String, String> _body = group.toSaveConfigurationsJson();
    _body.addAll({"_method": "PUT"});
    var response = await apiHelper.post(context, _url, body: _body);
    return Group.fromJson(response);
  }

  Future<BasicMessageResponse> addModerator(BuildContext context, Group group, int userId) async {
    String _url = ADD_MODERATOR_URL.replaceAll("{GROUP_ID}", group.id.toString());
    var response = await apiHelper.post(context, _url, body: {'user_id': userId.toString()});
    unawaited(loadUserGroups(context, forceLoad: true));
    return BasicMessageResponse.fromJson(response);
  }

  Future<BasicMessageResponse> removeModerator(BuildContext context, Group group, int userId) async {
    String _url = REMOVE_MODERATOR_URL.replaceAll("{GROUP_ID}", group.id.toString());
    _url = _url.replaceAll("{USER_ID}", userId.toString());
    var response = await apiHelper.delete(context, _url);
    unawaited(loadUserGroups(context, forceLoad: true));
    return BasicMessageResponse.fromJson(response);
  }
}
