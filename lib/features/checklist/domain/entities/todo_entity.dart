import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int? id;
  final String title;
  final String description;
  final bool isDone;

  const TodoEntity({
    this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });
  @override
  List<Object?> get props => [id, title, description, isDone];
}
