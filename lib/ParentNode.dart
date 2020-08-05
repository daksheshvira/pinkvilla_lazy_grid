import 'package:pinkvillatest2/Nodes.dart';

class ParentNode {
  List<Nodes> nodes = new List<Nodes>();

  ParentNode({this.nodes});

  ParentNode.fromJson(Map<String, dynamic> json) {
    if (json['nodes'] != null) {
      nodes = new List<Nodes>();
      json['nodes'].forEach((v) {
        nodes.add(new Nodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.nodes != null) {
      data['nodes'] = this.nodes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
