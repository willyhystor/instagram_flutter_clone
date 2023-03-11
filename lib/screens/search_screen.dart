import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/models/account.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _showUsers = false;

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user',
          ),
          onFieldSubmitted: (value) {
            setState(() {
              _showUsers = true;
            });
          },
        ),
      ),
      body: _showUsers ? _showAccountsResult() : _showPostsResult(),
    );
  }

  Widget _showAccountsResult() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection(Account.keyCollection)
          .where(Account.keyUsername,
              isGreaterThanOrEqualTo: _searchController.text)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  snapshot.data!.docs[index]
                      .data()[Account.keyProfilePictureUrl],
                ),
              ),
              title: Text(
                snapshot.data!.docs[index].data()[Account.keyUsername],
              ),
            );
          },
        );
      },
    );
  }

  Widget _showPostsResult() {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection(Post.keyCollection).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GridView.builder(
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            pattern: const [
              QuiltedGridTile(2, 2),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
            ],
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return Image.network(
              snapshot.data!.docs[index].data()[Post.keyPostUrl],
              fit: BoxFit.fill,
            );
          },
        );

        // return MasonryGridView.builder(
        //   gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 3,
        //   ),
        //   mainAxisSpacing: 4,
        //   crossAxisSpacing: 4,
        //   itemCount: snapshot.data!.docs.length,
        //   itemBuilder: (context, index) {
        //     return Image.network(
        //         snapshot.data!.docs[index].data()[Post.keyPostUrl]);
        //   },
        // );
      },
    );
  }
}
