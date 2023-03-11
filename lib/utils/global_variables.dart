import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';
import 'package:instagram_flutter/screens/search_screen.dart';

const webScreenSize = 600;

final homeScreenItems = <Widget>[
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('Notif'),
  const Text('Profile'),
];
