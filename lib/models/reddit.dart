import 'dart:convert';

import 'package:flutter/material.dart';

class Reddit{
  final String id;
  final String name;
  final String avatarUrl;
  final String bio;
  final int members;

  const Reddit({
      required this.id,
      required this.name,
      required this.avatarUrl,
      required this.bio,
      required this.members,
  });


  // //static method là method có thể gọi thẳng từ lớp mà kh cần tạo obj
  static Reddit fromJSON(dynamic snap) {
    return Reddit(    //chuyển thành object User và return
      id: snap['id'],
      name: snap['name'],
      avatarUrl: snap['avatarUrl'],
      bio: snap['bio'],
      members: snap['members'],
    );
  }

  static Future<List<Reddit>> getReddits(BuildContext context) async{
    String data = await DefaultAssetBundle.of(context).loadString("assets/reddit.json");
    var tagObjsJson = jsonDecode(data)['reddit'] as List;
    List<Reddit> reddits = tagObjsJson.map((tagJson) => Reddit.fromJSON(tagJson)).toList();
    return reddits;
  }
    
}