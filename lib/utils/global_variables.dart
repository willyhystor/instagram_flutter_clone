import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';

const webScreenSize = 600;

final homeScreenItems = <Widget>[
  FeedScreen(),
  Text('Search'),
  AddPostScreen(),
  Text('Notif'),
  Text('Profile'),
];