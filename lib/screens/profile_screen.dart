import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomapp/models/user_data.dart';
import 'package:flutter_ecomapp/models/user_model.dart';
import 'package:flutter_ecomapp/screens/edit_profile_screen.dart';
import 'package:flutter_ecomapp/services/database_service.dart';
import 'package:flutter_ecomapp/utilities/constants.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {

  final String currentUserId;
  final String userId;

  ProfileScreen({this.currentUserId,this.userId});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;

  void initState(){
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
  }

  _setupIsFollowing() async{
    bool _isFollowingUser = await DatabaseService.isFollowingUser(
        currentUserId: widget.currentUserId,
        userId: widget.userId,
    );
    setState(() {
      isFollowing = _isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    setState(() {
      followerCount = userFollowerCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    setState(() {
      followingCount = userFollowingCount;
    });
  }

  _followOrUnfollow(){
    if(isFollowing){
      _unfollowUser();
    }
    else{
      _followUser();
    }
  }

  _unfollowUser(){
    DatabaseService.unfollowUser(
        currentUserId: widget.currentUserId,
        userId: widget.userId,
    );
    setState(() {
      isFollowing = false;
      followerCount--;
    });
  }
  _followUser(){
    DatabaseService.followUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      isFollowing =true;
      followerCount++;
    });
  }

  _displayButton(User user){
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 220.0,
        height: 25.0,
        child: FlatButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(
              builder: (_)=> EditProfileScreen(
                user: user,
              )
          )
          ),
          color: Color(0xffde5145),
          textColor: Colors.white,
          child: Text(
            'Edit Profile',
            style: TextStyle(fontSize: 15.0),
          ),
        ),
      ),
    )
        :Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 220.0,
        height: 25.0,
        child: FlatButton(
          onPressed: _followOrUnfollow,
          color: isFollowing? Colors.grey[200] : Color(0xffde5145),
          textColor: isFollowing? Colors.black : Colors.white,
          child: Text(
            isFollowing
                ?'Unfollow'
                :'Follow',
            style: TextStyle(fontSize: 15.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);

          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 30.0, 15.0, 0.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 46.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: user.profileImageUrl.isEmpty
                          ? AssetImage('images/userProfile.jpg')
                          : CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('12',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    'posts',
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(followerCount.toString(),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    'followers',
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(followingCount.toString(),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    'following',
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ],
                          ),
                          _displayButton(user),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(user.name,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Container(
                      height: 60.0,
                      child: Text(user.bio,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),),
                    ),
                    Divider(),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
