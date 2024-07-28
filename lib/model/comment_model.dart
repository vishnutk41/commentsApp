import 'package:flutter/foundation.dart'; // For equatable

@immutable
class Comment {
  final int id;
  final String name;
  final String email;
  final String body;

  const Comment({
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    // Error handling for JSON conversion
    if (json['id'] is! int || json['name'] is! String || json['email'] is! String || json['body'] is! String) {
      throw Exception('Invalid JSON data');
    }

    return Comment(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }

  // Override equality and hashCode for comparison and collections
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.body == body;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode ^ body.hashCode;

  // CopyWith method
  Comment copyWith({
    int? id,
    String? name,
    String? email,
    String? body,
  }) {
    return Comment(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      body: body ?? this.body,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, name: $name, email: $email, body: $body)';
  }
}