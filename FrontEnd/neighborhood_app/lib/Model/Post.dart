import 'dart:ffi';

class Post {
  String email;
  String post_content; 
  String group;  // the name
  String postId;

  Post({
    required this.email,
    required this.post_content,
    required this.group,
    required this.postId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        email: json['email'],
        post_content: json['post'],
        group: json['group'],
       postId: json['id'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['post'] = post_content;
    data['group'] = group;
    data['id'] = postId;
    return data;
  }
}
