import 'package:checklist/features/checklist/presentation/bloc/checklist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoInfo extends StatefulWidget {
  final String id;
  const TodoInfo({super.key, required this.id});

  @override
  State<TodoInfo> createState() => _TodoInfoState();
}

class _TodoInfoState extends State<TodoInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "My Checklist",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )),
      body: BlocBuilder<ChecklistBloc, ChecklistState>(
        builder: (context, state) {
          if (state.status == ChecklistStatus.success) {
            // fetch the todo with the id
            final todo = state.todos
                .firstWhere((todo) => todo.id == int.parse(widget.id));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    todo.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    todo.description ?? '',
                    style: const TextStyle(),
                  ),
                ],
              ),
            );
          } else if (state.status == ChecklistStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const Center(
            child: Text('Todo Info'),
          );
        },
      ),
    );
  }
}
