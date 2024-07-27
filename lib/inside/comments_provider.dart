 import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'comment_model.dart';

class CommentsProvider with ChangeNotifier {
  List<Comment> _comments = [];
  bool _loading = false;

  List<Comment> get comments => _comments;
  bool get loading => _loading;

  CommentsProvider() {
    fetchComments();
  }

  Future<void> fetchComments() async {
    _loading = true;
    notifyListeners();

    try {
      final response = await Dio().get('https://jsonplaceholder.typicode.com/comments');
      final List<dynamic> data = response.data;
      _comments = data.map((json) => Comment.fromJson(json)).toList();
    } catch (e) {
      print(e);
    }

    _loading = false;
    notifyListeners();
  }
}