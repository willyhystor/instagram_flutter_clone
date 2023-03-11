import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () => _navigateTo(0),
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => _navigateTo(1),
            icon: Icon(
              Icons.search,
              color: _currentIndex == 1 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => _navigateTo(2),
            icon: Icon(
              Icons.add_a_photo,
              color: _currentIndex == 2 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => _navigateTo(3),
            icon: Icon(
              Icons.favorite,
              color: _currentIndex == 3 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => _navigateTo(4),
            icon: Icon(
              Icons.person,
              color: _currentIndex == 4 ? primaryColor : secondaryColor,
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _navigateTo,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
      ),
    );
  }

  void _navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });

    _pageController.jumpToPage(index);
  }
}
