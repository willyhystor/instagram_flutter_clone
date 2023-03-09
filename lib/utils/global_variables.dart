import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';

const webScreenSize = 600;

final homeScreenItems = <Widget>[
  const FeedScreen(),
  const Text('Search'),
  const AddPostScreen(),
  const Text('Notif'),
  const Text('Profile'),
];
