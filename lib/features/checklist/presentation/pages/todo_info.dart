import 'package:checklist/features/checklist/domain/entities/todo_entity.dart';
import 'package:checklist/features/checklist/presentation/bloc/checklist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

class TodoInfo extends StatefulWidget {
  final String id;
  const TodoInfo({super.key, required this.id});

  @override
  State<TodoInfo> createState() => _TodoInfoState();
}

class _TodoInfoState extends State<TodoInfo> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

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
        ),
        actions: [
          IconButton(
            onPressed: () {
              // update the todo
              devtools.log('delete Todo');
              context.read<ChecklistBloc>().add(
                    RemoveTodo(
                      int.parse(widget.id),
                    ),
                  );
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: BlocBuilder<ChecklistBloc, ChecklistState>(
        builder: (context, state) {
          if (state.status == ChecklistStatus.success) {
            // fetch the todo with the id
            final todo = state.todos
                .firstWhere((todo) => todo.id == int.parse(widget.id));
            titleController.text = todo.title;
            noteController.text = todo.description ?? '';
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                onChanged: () {
                  devtools.log('Form Changed');
                  // Todo: add debounce

                  if (_formKey.currentState!.validate()) {
                    context.read<ChecklistBloc>().add(
                          UpdateTodo(
                            int.parse(widget.id),
                            todo.copyWith(
                              title: titleController.text,
                              description: noteController.text,
                            ),
                          ),
                        );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: todo.isDone,
                            onChanged: (value) {
                              // mark the todo as done

                              devtools.log(value.toString());

                              context.read<ChecklistBloc>().add(
                                    UpdateTodo(
                                      int.parse(widget.id),
                                      todo.copyWith(isDone: value),
                                    ),
                                  );
                            }),
                        Expanded(
                          child: TextFormField(
                            controller: titleController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Title cannot be empty';
                              }
                              if (value.length > 50) {
                                return 'Too long!';
                              }
                              return null;
                            },
                            maxLength: 50,
                            decoration: InputDecoration(
                              hintText: 'Add a title',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: noteController,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: 'Add a note',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
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
