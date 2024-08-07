import 'package:checklist/features/checklist/domain/entities/todo_entity.dart';
import 'package:checklist/features/checklist/presentation/bloc/checklist_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:developer' as devtools show log;

import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  addTodo(TodoEntity todo) {
    // either way works
    // BlocProvider.of<ChecklistBloc>(context).add(AddTodo(todo));
    context.read<ChecklistBloc>().add(AddTodo(todo));
  }

  removeTodo(TodoEntity todo) {
    context.read<ChecklistBloc>().add(
          RemoveTodo(todo),
        );
  }

  changeTodo(int id, TodoEntity todo) {
    // mark this todo as done
    context.read<ChecklistBloc>().add(UpdateTodo(id, todo));
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
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
          )),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Add an item',
                  ),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: controller1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title for your task';
                            }
                            if (value.length > 50) {
                              return 'Too long!';
                            }
                            return null;
                          },
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          decoration: InputDecoration(
                            hintText: 'Your task...',
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
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              addTodo(
                                TodoEntity(
                                  title: controller1.text,
                                  description: controller2.text,
                                  isDone: false,
                                ),
                              );
                              controller1.text = '';
                              controller2.text = '';
                              Navigator.pop(context);
                            }
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
        },
        child: const Icon(CupertinoIcons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<ChecklistBloc, ChecklistState>(
          builder: (context, state) {
            if (state.status == ChecklistStatus.success) {
              return ListView.builder(
                  itemCount: state.incompleteTodos.length,
                  itemBuilder: (context, int i) {
                    TodoEntity singleItem = state.incompleteTodos[i];
                    return GestureDetector(
                      onTap: () {
                        context.go('/info/${singleItem.id}');
                      },
                      child: Card(
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
                                    removeTodo(singleItem);
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
                                  singleItem.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(singleItem.description ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    )),
                                trailing: Checkbox(
                                    value: singleItem.isDone,
                                    activeColor: Colors.white,
                                    onChanged: (value) {
                                      changeTodo(
                                        singleItem.id!,
                                        singleItem.copyWith(isDone: true),
                                      );
                                    }))),
                      ),
                    );
                  });
            } else if (state.status == ChecklistStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center(
              child: Text('Something happened'),
            );
          },
        ),
      ),
    );
  }
}
