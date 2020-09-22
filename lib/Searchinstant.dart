import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/searchservice.dart';

import 'const.dart';

class MySearchPage extends StatefulWidget {
  final Color cardBackgroundColor = Colors.grey;
  @override
  _MySearchPageState createState() => new _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          //print(json.decode(docs.documents[i].data["country"]).cast<Map<String, dynamic>>());
          queryResultSet.add(docs.documents[i].data);
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['nickname'].toLowerCase().contains(value.toLowerCase()) ==
            true) {
          if (element['nickname'].toLowerCase().indexOf(value.toLowerCase()) ==
              0) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        }
      });
    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text('User search'),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10.0),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element);
              }).toList())
        ]));
  }
}

Widget buildResultCard(data) {
  return Card(
      color: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
  child: SizedBox(
      child: Stack(children: <Widget>[
      SingleChildScrollView(
      child:
       Column(children: <Widget>[
          Container(
            child: Center(
              child: Stack(
                children: <Widget>[
                  (data['photoUrl'] != ''
                      ? Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(themeColor),
                              ),
                              width: 100.0,
                              height: 100.0,
                              padding: EdgeInsets.all(40.0),
                            ),
                            imageUrl: data['photoUrl'],
                            width: 90.0,
                            height: 90.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                          clipBehavior: Clip.hardEdge,
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 90.0,
                          color: greyColor,
                        )),
                ],
              ),
            ),
            width: double.infinity,
            margin: EdgeInsets.all(10.0),
          ),
          Column(children: <Widget>[
            Container(
                child: Center(
                    child: Text(
              data['nickname'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
              ),
            ))),
            Container(
                child: Center(
                    child: Text(
                      (data['country'].cast<String,dynamic>()['flag']),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14.0,
              ),
            ))),
            Container(
                child: Center(
                    child: Text(
                      data['aboutMe'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14.0,
                      ),
                    )))
          ])
        ]))
      ])));
}
