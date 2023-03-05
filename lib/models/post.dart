import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  static String keyCollection = 'posts';
  static String keyUid = 'uid';
  static String keyUsername = 'username';
  static String keyPostId = 'post_id';
  static String keyCaption = 'caption';
  static String keyDatePublished = 'date_published';
  static String keyPostUrl = 'post_url';
  static String keyProfImage = 'prof_image';
  static String keyLikes = 'likes';

  final String uid;
  final String username;
  final String postId;
  final String caption;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final List likes;

  Post({
    required this.uid,
    required this.username,
    required this.postId,
    required this.caption,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    this.likes = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      keyUid: uid,
      keyUsername: username,
      keyPostId: postId,
      keyCaption: caption,
      keyDatePublished: datePublished,
      keyPostUrl: postUrl,
      keyProfImage: profImage,
      keyLikes: likes,
    };
  }

  static Post fromSnap(DocumentSnapshot snapshot) {
    var map = snapshot.data() as Map<String, dynamic>;

    return Post(
      uid: map[keyUid],
      username: map[keyUsername],
      postId: map[keyPostId],
      caption: map[keyCaption],
      datePublished: map[keyDatePublished],
      postUrl: map[keyPostUrl],
      profImage: map[keyProfImage],
      likes: map[keyLikes],
    );
  }
}
