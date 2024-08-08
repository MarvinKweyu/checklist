// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:checklist/features/checklist/domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
  const TodoModel({
    super.id,
    required super.title,
  super.description,
    required super.isDone,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      isDone: map['isDone'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    return TodoModel.fromMap(map);
    // return TodoModel(
    //   title: json['title'],
    //   description: json['description'],
    //   isDone: json['isDone'],
    // );
  }

  @override
  String toString() =>
      'TodoModel(id: $id, title: $title, description: $description, isDone: $isDone)';

  @override
  bool operator ==(covariant TodoModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.description == description &&
        other.isDone == isDone;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ isDone.hashCode;
}
