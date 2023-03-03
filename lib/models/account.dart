import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  static String keyCollection = 'accounts';
  static String keyUid = 'uid';
  static String keyEmail = 'email';
  static String keyUsername = 'username';
  static String keyBio = 'bio';
  static String keyFollowers = 'followers';
  static String keyFollowing = 'following';
  static String keyProfilePictureUrl = 'profile_picture_url';

  final String uid;
  final String email;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final String? profilePictureUrl;

  Account({
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    this.profilePictureUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      keyUid: uid,
      keyEmail: email,
      keyUsername: username,
      keyBio: bio,
      keyFollowers: followers,
      keyFollowing: following,
      keyProfilePictureUrl: profilePictureUrl,
    };
  }

  static Account fromSnap(DocumentSnapshot snapshot) {
    var map = snapshot.data() as Map<String, dynamic>;

    return Account(
      uid: map[keyUid],
      email: map[keyEmail],
      username: map[keyUsername],
      bio: map[keyBio],
      followers: map[keyFollowers],
      following: map[keyFollowing],
      profilePictureUrl: map[keyProfilePictureUrl],
    );
  }
}
