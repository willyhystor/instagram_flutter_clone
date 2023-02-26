import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  final _usernameController = TextEditingController();
  Uint8List? _imageFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Expanded(
                //   flex: 2,
                //   child: Container(),
                // ),
                const SizedBox(height: 64),

                // svg image
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                ),
                const SizedBox(height: 64),

                // Profile picture
                Center(
                  child: Stack(
                    children: [
                      _imageFile != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_imageFile!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png'),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () => _selectImage(),
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // text input for username
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'Enter your Username',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24),

                // text input for email
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter your E-mail',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),

                // text input for password
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Enter your Password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 24),

                // text input for bio
                TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'Enter your Bio',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24),

                // button Sign Up
                InkWell(
                  onTap: () => _signUp(),
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 12),
                // Expanded(
                //   flex: 2,
                //   child: Container(),
                // ),

                // transitioning to signing up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Don\'t have an account?'),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Sign Up.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });

    final res = await AuthMethods().signUp(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      imageFile: _imageFile,
    );

    setState(() {
      _isLoading = false;
    });

    log(res);

    if (res != 'success' && context.mounted) {
      showSnackBar(context, res);
    } else {
      //
    }
  }

  void _selectImage() async {
    final image = await pickImage(ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }
}
