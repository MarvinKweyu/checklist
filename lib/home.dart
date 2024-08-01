import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:checklist/data/todo.dart';
import 'dart:developer' as devtools show log;

import 'package:checklist/todo_bloc/todo_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  addTodo(Todo todo) {
    // either way works
    // BlocProvider.of<TodoBloc>(context).add(AddTodo(todo));
    context.read<TodoBloc>().add(AddTodo(todo));
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(
          RemoveTodo(todo),
        );
  }

  changeTodo(int index) {
    context.read<TodoBloc>().add(AlterTodo(index));
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
          )),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          devtools.log('Show Add Page');
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController controller1 = TextEditingController();
                TextEditingController controller2 = TextEditingController();
                return AlertDialog(
                  title: const Text('Add item'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller1,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                          hintText: 'Task Title...',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        onChanged: (value) {
                          // setState(() {
                          //   title = value;
                          // });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: controller2,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                          hintText: 'Task Description...',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        onChanged: (value) {
                          // setState(() {
                          //   description = value;
                          // });
                        },
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextButton(
                          onPressed: () {
                            addTodo(
                              Todo(
                                title: controller1.text,
                                description: controller2.text,
                              ),
                            );
                            controller1.text = '';
                            controller2.text = '';
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            foregroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Icon(
                                CupertinoIcons.check_mark,
                                color: Colors.green,
                              ))),
                    )
                  ],
                );
              });
          // Navigator.pushNamed(context, '/add');
        },
        child: const Icon(CupertinoIcons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.success) {
              return ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, int i) {
                    return Card(
                      color: Theme.of(context).colorScheme.primary,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  removeTodo(state.todos[i]);
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: ListTile(
                              title: Text(
                                state.todos[i].title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(state.todos[i].description,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  )),
                              trailing: Checkbox(
                                  value: state.todos[i].isDone,
                                  activeColor: Colors.white,
                                  onChanged: (value) {
                                    changeTodo(i);
                                  }))),
                    );
                  });
            } else if (state.status == TodoStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == TodoStatus.error) {
              return const Center(
                child: Text('Something happened'),
              );
            }
            return const Center(
              child: Text('Hello World'),
            );
          },
        ),
      ),
    );
  }
}
