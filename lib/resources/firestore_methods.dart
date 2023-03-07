import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String uid,
    String username,
    String profImage,
    String caption,
    Uint8List file,
  ) async {
    String res = 'Some error occured';

    try {
      final postUrl = await StorageMethods()
          .uploadImage(childName: Post.keyCollection, file: file, isPost: true);

      final postId = const Uuid().v1();

      final post = Post(
        uid: uid,
        username: username,
        postId: postId,
        caption: caption,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profImage,
        // likes: likes,
      );

      _firestore.collection(Post.keyCollection).doc(postId).set(post.toJson());

      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection(Post.keyCollection).doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection(Post.keyCollection).doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
