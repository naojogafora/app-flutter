class JoinGroupResponse {
  String message;
  bool joined;
  JoinGroupResponse.fromJson(Map<String, dynamic> json){
    this.message = json['message'];
    this.joined = json['joined'];
  }
}