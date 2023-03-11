import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/providers/account_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  late TextEditingController _captionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    _captionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context).getAccount!;

    if (_file == null) {
      return Center(
        child: IconButton(
          onPressed: () => _selectImage(context),
          icon: const Icon(Icons.upload),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Post to'),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => _clearImage(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: () => _postImage(
                account.uid, account.username, account.profilePictureUrl!),
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _isLoading ? const LinearProgressIndicator() : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(account.profilePictureUrl!),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  controller: _captionController,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);

                final file = await pickImage(ImageSource.camera);

                setState(() {
                  _file = file;
                });
              },
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);

                final file = await pickImage(ImageSource.gallery);

                setState(() {
                  _file = file;
                });
              },
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _postImage(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });

    final res = await FirestoreMethods()
        .uploadPost(uid, username, profImage, _captionController.text, _file!);

    if (res == 'success' && context.mounted) {
      showSnackBar(context, 'Posted!');
    } else {
      showSnackBar(context, res);
    }

    setState(() {
      _isLoading = false;
    });

    _clearImage();
  }

  void _clearImage() {
    setState(() {
      _captionController.clear();
      _file = null;
    });
  }
}
