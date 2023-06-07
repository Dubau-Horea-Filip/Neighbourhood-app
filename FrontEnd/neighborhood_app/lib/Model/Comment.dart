class Comment {
  String comment;
  String user_email;
  String post;
  String id;

  Comment(
      {required this.comment,
      required this.user_email,
      required this.post,
      required this.id});

  @override
  String toString() {
    return 'Group{name: $comment, location: $user_email, numberOfCommonFriends: $post}';
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        comment: json['comment'],
        user_email: json['email'],
        post: json['postId'],
        id: json['id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['email'] = user_email;
    data['postId'] = post;
    data['id'] = id;
    return data;
  }
}
