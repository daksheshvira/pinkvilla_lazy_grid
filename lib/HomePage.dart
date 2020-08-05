import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pinkvillatest2/Nodes.dart';
import 'package:pinkvillatest2/ParentNode.dart';

class HomePage extends StatefulWidget {
  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<HomePage> {
  ParentNode parentNode;
  static int page = 0;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    parentNode = new ParentNode(nodes: new List<Nodes>());
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildList() {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: parentNode.nodes.length + 1,
      // Add one more item for progress indicator
      itemBuilder: (BuildContext context, int index) {
        if (index == parentNode.nodes.length) {
          return _buildProgressIndicator();
        } else {
          String imageUrl = "http://www.pinkvilla.com/" +
              parentNode.nodes[index].node.fieldPhotoImageSection;
          return Container(
            child: CachedNetworkImage(
              fit: BoxFit.scaleDown,
              imageUrl: imageUrl,
            ),
          );
        }
      },
      controller: _sc,
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var response = await http.get(
          "http://www.pinkvilla.com/photo-gallery-feed-page/page/$index",
          headers: {'Accept': 'application/json'});
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        ParentNode tempParentNode = new ParentNode.fromJson(data);
        setState(() {
          isLoading = false;
          parentNode.nodes.addAll(tempParentNode.nodes);
          page++;
        });
      }
    }
  }
}
