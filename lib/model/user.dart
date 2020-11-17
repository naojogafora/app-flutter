class User {
  int id;
  String name, lastName;
  String email;
  int accountStatusId;

  User.fromJson(Map<String, dynamic> json){
    this.id = json["id"];
    this.name = json['name'];
    this.lastName = json['last_name'];
    this.email = json['email'];
    this.accountStatusId = json['account_status_id'] ?? 1;
  }
}