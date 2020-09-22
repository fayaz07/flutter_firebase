import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Searchinstant.dart';
import 'const.dart';
import 'home.dart';

class Settings extends StatelessWidget {
  final Color cardBackgroundColor = Colors.grey;
  double _height, _width, _fixedPadding;
  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;
    final Color cardBackgroundColor = Colors.grey;
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white.withOpacity(0.95),
        body: SafeArea(
          child: Center(
            child: Card(
              color: cardBackgroundColor,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: SizedBox(
                height: _height * 8 / 10,
                width: _width * 8 / 10,
                child: SettingsScreen(),
              ),
            ),
          ),
        ));
  }
}

class SettingsScreen extends StatefulWidget {
  final Color cardBackgroundColor = Colors.grey;
  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  double _height, _width, _fixedPadding;
  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");

  TextEditingController controllerNickname;
  TextEditingController controllerAboutMe;

  SharedPreferences prefs;

  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';
  String searchKey = '';

  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodeNickname = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    nickname = prefs.getString('nickname') ?? '';
    aboutMe = prefs.getString('aboutMe') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';
    searchKey = prefs.getString('searchKey') ?? '';

    controllerNickname = TextEditingController(text: nickname);
    controllerAboutMe = TextEditingController(text: aboutMe);

    // Force refresh input
    setState(() {});
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance.collection('users').document(id).updateData({
            'nickname': nickname,
            'aboutMe': aboutMe,
            'photoUrl': photoUrl,
            'searchKey': searchKey
          }).then((data) async {
            await prefs.setString('photoUrl', photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void onHomePressed() {
    //Navigator.push(
    //   context,
    //MaterialPageRoute(
    //  builder: (context) => HomeScreen(
    //       currentUserId: id,
    //    )));
    Navigator.push(context, MaterialPageRoute(builder: (context) => MySearchPage()));
  }

  void handleUpdateData() {
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });

    Firestore.instance.collection('users').document(id).updateData({
      'nickname': nickname,
      'aboutMe': aboutMe,
      'photoUrl': photoUrl,
      'searchKey': searchKey
    }).then((data) async {
      await prefs.setString('nickname', nickname);
      await prefs.setString('aboutMe', aboutMe);
      await prefs.setString('photoUrl', photoUrl);
      await prefs.setString('searchKey', searchKey);
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ? (photoUrl != ''
                              ? Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                themeColor),
                                      ),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: photoUrl,
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(45.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 200.0,
                                  color: greyColor,
                                ))
                          : Material(
                              child: Image.file(
                                avatarImageFile,
                                width: 90.0,
                                height: 90.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(60.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: getImage,
                        padding: EdgeInsets.all(76.0),
                        splashColor: Colors.transparent,
                        highlightColor: greyColor,
                        iconSize: 50.0,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(30.0),
              ),
              // Input
              Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      'Nickname',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 18.7,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: primaryColor),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'nickname',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w100,
                            fontSize: 18.0),
                        ),
                        controller: controllerNickname,
                        onChanged: (value) {
                          nickname = value;
                          searchKey = value.substring(0, 1).toUpperCase();
                        },
                        focusNode: focusNodeNickname,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // About me
                  Container(
                    child: Text(
                      'About me',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: primaryColor),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Fun, like travel and play PES...',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w100,
                            fontSize: 14.7,),
                        ),
                        controller: controllerAboutMe,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        focusNode: focusNodeAboutMe,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                ],
                // Username

                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              // Button
              Container(
                child: RaisedButton(
                  elevation: 16.0,
                  onPressed: handleUpdateData,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Update',
                      style: TextStyle(
                          color: widget.cardBackgroundColor, fontSize: 18.0),
                    ),
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
              ),
              Container(
                child: FlatButton(
                  onPressed: onHomePressed,
                  child: Text(
                    'HOME',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: primaryColor,
                  highlightColor: Color(0xff8d93a0),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container(),
        ),
      ],
    );
  }
}
