import 'package:flutter/material.dart';

class TodoInfo extends StatefulWidget {
  final String id;
  const TodoInfo({super.key, required this.id});

  @override
  State<TodoInfo> createState() => _TodoInfoState();
}

class _TodoInfoState extends State<TodoInfo> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Todo Info'),
      ),
    );
  }
}
