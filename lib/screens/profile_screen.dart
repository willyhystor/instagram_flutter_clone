import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/account.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Map<String, dynamic> _accountData;
  late List<Map<String, dynamic>> _postsData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(_accountData[Account.keyUsername] ?? ''),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                          _accountData[Account.keyProfilePictureUrl]),
                      radius: 40,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatColumn(_postsData.length, 'posts'),
                              _buildStatColumn(
                                  _accountData[Account.keyFollowers]?.length ??
                                      0,
                                  'followers'),
                              _buildStatColumn(
                                  _accountData[Account.keyFollowing]?.length ??
                                      0,
                                  'following'),
                            ],
                          ),
                          _buttons(),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _accountData[Account.keyUsername],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(_accountData[Account.keyBio]),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection(Post.keyCollection)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 2,
                      ),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Image(
                            image: NetworkImage(
                              snapshot.data!.docs[index]
                                  .data()[Post.keyPostUrl],
                            ),
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  void getUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final accountSnap = await FirebaseFirestore.instance
          .collection(Account.keyCollection)
          .doc(widget.uid)
          .get();

      setState(() {
        _accountData = accountSnap.data()!;
      });

      final postSnap = await FirebaseFirestore.instance
          .collection(Post.keyCollection)
          .where(Post.keyUid, isEqualTo: widget.uid)
          .get();

      setState(() {
        _postsData = postSnap.docs.map((e) => e.data()).toList();
      });
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buttons() {
    if (FirebaseAuth.instance.currentUser?.uid == widget.uid) {
      // Is my own profile
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FollowButton(
            function: () {},
            backgroundColor: mobileBackgroundColor,
            borderColor: Colors.grey,
            text: 'Edit Profile',
            textColor: primaryColor,
          ),
        ],
      );
    } else if (_accountData[Account.keyFollowers]
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      // is following
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FollowButton(
            function: () {},
            backgroundColor: mobileBackgroundColor,
            borderColor: Colors.grey,
            text: 'Unfollow',
            textColor: primaryColor,
          ),
        ],
      );
    } else if (!_accountData[Account.keyFollowers]
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      // is not following
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FollowButton(
            function: () {},
            backgroundColor: blueColor,
            borderColor: blueColor,
            text: 'Follow',
            textColor: primaryColor,
          ),
        ],
      );
    }

    return Container();
  }
}
