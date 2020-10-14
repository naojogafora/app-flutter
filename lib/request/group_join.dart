class JoinGroupRequest {
  String message;
  bool joined;
  JoinGroupRequest.fromJson(Map<String, dynamic> json){
    this.message = json['message'];
    this.joined = json['joined'];
  }
}