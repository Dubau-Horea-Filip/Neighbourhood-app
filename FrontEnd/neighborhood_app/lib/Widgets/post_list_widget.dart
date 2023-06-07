import 'package:flutter/material.dart';
import 'package:neighborhood_app/Widgets/post_widget.dart';
import '../Model/Post.dart';
import '../Model/User.dart';

class PostListWidget extends StatelessWidget {
  final List<Post> posts;
  final User user;

  const PostListWidget({Key? key, required this.posts, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          400, // Set a fixed height or use constraints as per your requirement
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostWidget(
            post: post,
            user: user,
          );
        },
      ),
    );
  }
}



  // Future<List<Comment>> getCommentsOfPost(int postId) async {
  //   const url = 'http://localhost:8080/api/comment/comments';

  //   final uri =
  //       Uri.parse(url).replace(queryParameters: {'postId': postId.toString()});
  //   final response = await http.get(uri);
  //   final body = response.body;
  //   if (body.isNotEmpty && response.statusCode == 200) {
  //     final parsedJson = json.decode(body);
  //     List<Comment> comments = [];
  //     for (var commentJson in parsedJson) {
  //       Comment comment = Comment.fromJson(commentJson);
  //       comments.add(comment);
  //     }
  //     return comments;
  //   }
  //   return [];
  // }


// class EmptyWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // Customize the appearance of the empty widget as desired
//       width: 200,
//       height: 100,
//       color: Colors.grey,
//       child: Center(
//         child: Text(
//           'Empty Widget',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
