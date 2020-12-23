class BlogPost {
  String title;
  String content;
  String imageUrl;
  DateTime createdAt;
  String authorName;
  String authorImageUrl;

  String get creationDate => createdAt == null ? "" : (createdAt.day < 10 ? "0" : "") + createdAt.day.toString() + "/" + (createdAt.month < 10 ? "0" : "") + createdAt.month.toString() + "/" + createdAt.year.toString();

  BlogPost.fromJson(dynamic json){
    this.title = json['title'];
    this.content = json['content'];
    this.authorName = json['metadata']['author']['title'];
    this.authorImageUrl = json['metadata']['author']['thumbnail'];
    this.imageUrl = json['metadata']['image']['url'];
    this.createdAt = DateTime.parse(json['created_at']);
  }
}