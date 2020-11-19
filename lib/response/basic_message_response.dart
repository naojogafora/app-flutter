class BasicMessageResponse {
  String message;
  bool success;

  BasicMessageResponse(this.message, {this.success = false});

  BasicMessageResponse.fromJson(Map<String, dynamic> json){
    this.message = json["message"];
    this.success = json["success"];
  }
}