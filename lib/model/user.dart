class User {
  String name, lastName;
  String email;
  int accountStatusId;

  User.fromJson(Map<String, dynamic> json){
    this.name = json['name'];
    this.lastName = json['last_name'];
    this.email = json['email'];
    this.accountStatusId = json['account_status_id'] ?? 1;
  }
}