class JoinGroupResponse {
  String message;
  bool joined;

  JoinGroupResponse(this.message) {
    joined = false;
  }

  JoinGroupResponse.fromJson(Map<String, dynamic> json) {
    this.message = json['message'];
    this.joined = json['joined'];
  }
}
