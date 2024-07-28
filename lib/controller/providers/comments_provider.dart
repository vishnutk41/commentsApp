import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../model/comment_model.dart';

class CommentsProvider with ChangeNotifier {
  List<Comment> _comments = [];
  bool _loading = false;
  bool _maskEmail = false;

  List<Comment> get comments => _comments;
  bool get loading => _loading;

  CommentsProvider() {
    fetchComments();
    fetchMaskEmailConfig();
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

  Future<void> fetchMaskEmailConfig() async {
    await Future.delayed(Duration(seconds: 1));
    _maskEmail = true; 

    notifyListeners();
  }

  String _maskEmailFunction(String email) {
    final parts = email.split('@');
    if (parts[0].length > 3) {
      return '${parts[0].substring(0, 3)}****@${parts[1]}';
    } else {
      return email;
    }
  }

  List<Comment> get maskedComments => _comments.map((comment) {
    if (_maskEmail) {
      return comment.copyWith(email: _maskEmailFunction(comment.email));
    }
    return comment;
  }).toList();
}