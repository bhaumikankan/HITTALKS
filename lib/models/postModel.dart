import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostModel{
  String? authorid;
  String? title;
  String? body;
  int? createdAt;
  
  PostModel({this.authorid,this.title,this.body,this.createdAt});

  
  Map<String,dynamic> toMap(){
    return{
      "authorid":authorid,
      "title":title,
      "body":body,
      "createdAt":createdAt
    };
  }
}