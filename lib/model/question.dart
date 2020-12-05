class Question {
  int id;
  int userId, advertisementId;
  String question, answer;
  DateTime createdAt, answeredAt;

  String get askDate =>
      createdAt.day.toString() + "/" + createdAt.month.toString() + "/" + createdAt.year.toString();
  String get answerDate =>
      answeredAt.day.toString() + "/" + answeredAt.month.toString() + "/" + answeredAt.year.toString();

  Question();

  Question.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.userId = json['user_id'];
    this.advertisementId = json['advertisement_id'];
    this.question = json['question'];
    this.answer = json['answer'];
    this.createdAt = DateTime.parse(json['created_at']);
    this.answeredAt = json['answered_at'] == null ? null : DateTime.parse(json['answered_at']);
  }
}