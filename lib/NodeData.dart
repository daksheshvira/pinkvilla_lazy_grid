import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pinkvillatest2/ParentNode.dart';

class NodeData {
  ParentNode parentNode;
  int statusCode;
  String errorMessage;
  int total;
  int nItems;

  NodeData.fromResponse(http.Response response) {
    this.statusCode = response.statusCode;
    var data = jsonDecode(response.body);
    parentNode = new ParentNode.fromJson(data);
    nItems = parentNode.nodes.length;
  }

  NodeData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}
