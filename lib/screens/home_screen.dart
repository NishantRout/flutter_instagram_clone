import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomapp/screens/activity_screen.dart';
import 'package:flutter_ecomapp/screens/create_post_screen.dart';
import 'package:flutter_ecomapp/screens/feed_screen.dart';
import 'package:flutter_ecomapp/screens/profile_screen.dart';
import 'package:flutter_ecomapp/screens/search_screen.dart';
import 'package:flutter_ecomapp/models/user_data.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController=PageController();
  }

  Widget build(BuildContext context) {

    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(),
          SearchScreen(),
          CreatePostScreen(),
          ActivityScreen(),
          ProfileScreen(
              currentUserId: currentUserId,
              userId: currentUserId,
          ),
        ],
          onPageChanged: (int index){
          setState(() {
            _currentTab = index;
          });
          }
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTab,
        onTap: (int index){
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn);
        },
        activeColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 28.0,
            )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 28.0,
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera,
                size: 28.0,
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border,
                size: 28.0,
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                size: 28.0,
              )
          ),
        ],
      ),
    );
  }
}
