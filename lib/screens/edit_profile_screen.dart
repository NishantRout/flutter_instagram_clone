import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomapp/models/user_model.dart';
import 'package:flutter_ecomapp/services/database_service.dart';
import 'package:flutter_ecomapp/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  EditProfileScreen({this.user});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final _formKey = GlobalKey<FormState>();
  File  _profileImage;
  String _name = '';
  String _bio = '' ;
  String _profileImageUrl = null;
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  _handleImageFromGallery() async{

      try {
        var imageFile = await ImagePicker.pickImage(
            source: ImageSource.gallery);

        if (imageFile != null) {
          setState(() {
            _profileImage = imageFile;
            _profileImageUrl = 'abc';
          });
        }
        else{
          print(imageFile);
        }
      }
      catch (e) {
        print(e);
      }

  }

  _displayProfileImage(){
    //No new profile Image
    if(_profileImage == null){
      //No existing profile image
      if(widget.user.profileImageUrl.isEmpty){
        //Display placeholder
        return AssetImage('images/userProfile.jpg');
      }
      else{
        //User profile image exists
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    }
    else{
      //New profile image
      return FileImage(_profileImage);
    }
  }

  _submit() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      //Update user in database

      if(_profileImageUrl == null){
        _profileImageUrl = widget.user.profileImageUrl;
      }
      else{
        _profileImageUrl = await StorageService.uploadUserProfileImage(
            widget.user.profileImageUrl,
            _profileImage);
      }
      User user = User(
        id: widget.user.id,
        name: _name,
        profileImageUrl: _profileImageUrl,
        bio: _bio,
      );
      //Database update
      DatabaseService.updateUser(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
            "Edit Profile",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),),
      ),
      body: GestureDetector(
        //tap anywhere on the screen to minimise the keyboard
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading ? LinearProgressIndicator(
              backgroundColor: Color(0xffff8d83),
              valueColor: AlwaysStoppedAnimation(Color(0xffde5145),
              ),
            )
            :SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.white,
                      backgroundImage: _displayProfileImage(),
                    ),
                    FlatButton(
                      onPressed: _handleImageFromGallery,
                      child: Text(
                        'Change Profile Image',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: _name,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(Icons.person, size: 30.0,),
                        labelText: 'Name',
                      ),
                      validator: (input)=> input.trim().length < 1
                          ? 'Please enter a valid name'
                          : null,
                      onSaved: (input)=>_name = input,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(Icons.book, size: 30.0,),
                        labelText: 'Bio',
                      ),
                      validator: (input)=> input.trim().length > 150
                          ? 'Please enter a bio less than 150 characters'
                          : null,
                      onSaved: (input)=> _bio = input,
                    ),
                    Container(
                      margin: EdgeInsets.all(40.0),
                      height: 40.0,
                      width: 250.0,
                      child: FlatButton(
                        onPressed: _submit,
                        color: Color(0xffde5145),
                        textColor: Colors.white,
                        child: Text('Save Profile',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),),
                      ),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      );
  }
}
