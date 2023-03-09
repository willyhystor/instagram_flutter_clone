import 'package:cloud_firestore/cloud_firestore.dart';

class PostComment {
  static String keyCollection = 'comments';
  static String keyUid = 'uid';
  static String keyUsername = 'username';
  static String keyPostId = 'post_id';
  static String keyComment = 'comment';
  static String keyDatePublished = 'date_published';
  static String keyProfImage = 'prof_image';
  static String keyLikes = 'likes';

  final String uid;
  final String username;
  final String postId;
  final String comment;
  final DateTime datePublished;
  final String? profImage;
  final List likes;

  PostComment({
    required this.uid,
    required this.username,
    required this.postId,
    required this.comment,
    required this.datePublished,
    this.profImage,
    this.likes = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      keyUid: uid,
      keyUsername: username,
      keyPostId: postId,
      keyComment: comment,
      keyDatePublished: datePublished,
      keyProfImage: profImage,
      keyLikes: likes,
    };
  }

  static PostComment fromSnap(DocumentSnapshot snapshot) {
    var map = snapshot.data() as Map<String, dynamic>;

    return PostComment(
      uid: map[keyUid],
      username: map[keyUsername],
      postId: map[keyPostId],
      comment: map[keyComment],
      datePublished: map[keyDatePublished],
      profImage: map[keyProfImage],
      likes: map[keyLikes],
    );
  }
}
