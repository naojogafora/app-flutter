class TransactionMessage {
  int id, transactionId, userId;
  String message;
  DateTime createdAt;

  String get creationDate =>
      createdAt.day.toString() + "/" + createdAt.month.toString() + "/" + createdAt.year.toString();

  TransactionMessage.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.transactionId = json["transaction_id"];
    this.userId = json["user_id"];
    this.message = json["message"];
    this.createdAt = DateTime.parse(json["created_at"]);
  }
}
