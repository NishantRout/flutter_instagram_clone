import 'package:flutter/material.dart';
import 'package:flutter_ecomapp/services/auth_service.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffde5145),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Instagram',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Billabong',
              fontSize: 35.0,
            ),
          ),
        ),
      ),
      body: Center(
        child: FlatButton(
          onPressed: ()=> AuthService.logout(),
          child: Text('LOGOUT'),
        ),
      ),
    );
  }
}
