import 'package:checklist/features/checklist/presentation/bloc/checklist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:checklist/features/checklist/presentation/pages/home.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Checklist',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            surface: Colors.white,
            onSurface: Colors.black,
            primary: Colors.green,
            onPrimary: Colors.black,
            secondary: Color.fromARGB(255, 191, 165, 117),
            onSecondary: Color.fromARGB(255, 191, 165, 117),
          ),
          useMaterial3: true,
        ),
        home: BlocProvider<ChecklistBloc>(
          create: (context) => ChecklistBloc()..add(ChecklistStarted()),
          child: const Home(),
        ));
  }
}
