class Account {
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
      'uid': uid,
      'email': email,
      'username': username,
      'bio': bio,
      'profile_picture_url': profilePictureUrl,
      'followers': followers,
      'following': following,
    };
  }
}
