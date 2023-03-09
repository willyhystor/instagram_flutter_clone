import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/account.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/post_comment.dart';
import 'package:instagram_flutter/providers/account_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/comment_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Map postSnap;

  const PostCard({
    super.key,
    required this.postSnap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLikeAnimating = false;
  int postCommentLength = 0;

  @override
  void initState() {
    super.initState();

    _getComments();
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context).getAccount;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Top Bar
          Container(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      NetworkImage(widget.postSnap[Post.keyProfImage]),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.postSnap[Post.keyUsername],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _option(context),
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),

          // Image
          GestureDetector(
            onDoubleTap: () => _onDoubleTapPost(account!),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.postSnap[Post.keyPostUrl],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: _isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        _isLikeAnimating = !_isLikeAnimating;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LIKE COMMENT SECTION
          Row(
            children: [
              LikeAnimation(
                isAnimating:
                    widget.postSnap[Post.keyLikes].contains(account!.uid),
                smalllike: true,
                duration: const Duration(milliseconds: 400),
                child: IconButton(
                  onPressed: () => _onTapLikeIcon(account),
                  icon: widget.postSnap[Post.keyLikes].contains(account.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: () => _toCommentCard(),
                icon: const Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ),
              ),
            ],
          ),

          // Captoions and comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.postSnap[Post.keyLikes].length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.postSnap[Post.keyUsername],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${widget.postSnap[Post.keyCaption]}',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $postCommentLength comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                        widget.postSnap[Post.keyDatePublished].toDate()),
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _option(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shrinkWrap: true,
            children: [
              'Delete',
            ].map((e) {
              return InkWell(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text(e),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _onDoubleTapPost(Account account) async {
    if (!widget.postSnap[Post.keyLikes].contains(account.uid)) {
      await FirestoreMethods().likePost(
        widget.postSnap[Post.keyPostId],
        account.uid,
        widget.postSnap[Post.keyLikes],
      );
    }

    setState(() {
      _isLikeAnimating = true;
    });
  }

  void _onTapLikeIcon(Account account) async {
    await FirestoreMethods().likePost(
      widget.postSnap[Post.keyPostId],
      account.uid,
      widget.postSnap[Post.keyLikes],
    );
  }

  void _toCommentCard() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentScreen(
          postSnap: widget.postSnap,
        ),
      ),
    );

    _getComments();
  }

  void _getComments() async {
    try {
      QuerySnapshot postCommentSnap = await FirebaseFirestore.instance
          .collection(Post.keyCollection)
          .doc(widget.postSnap[Post.keyPostId])
          .collection(PostComment.keyCollection)
          .get();

      setState(() {
        postCommentLength = postCommentSnap.docs.length;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
