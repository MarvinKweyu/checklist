import 'package:checklist/core/routes.dart';
import 'package:checklist/features/checklist/presentation/bloc/checklist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

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
    return MultiBlocProvider(
        providers: [
          BlocProvider<ChecklistBloc>(
            create: (context) => ChecklistBloc()..add(ChecklistStarted()),
          )
        ],
        child: MaterialApp.router(
          title: 'Checklist',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              surface: Colors.white,
              onSurface: Colors.black,
              primary: Colors.green,
              onPrimary: Colors.black,
              secondary: Color(0xFF81C784), // A softer green
              onSecondary: Color(0xFF2E7D32),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: const ColorScheme.dark(
              surface: Color(0xFF303030),
              onSurface: Colors.white,
              primary: Color(0xFF388E3C),
              onPrimary: Colors.white,
              secondary: Color(0xFF66BB6A),
              onSecondary: Color(0xFF004D40),
            ),
            useMaterial3: true,
          ),
          routerConfig: routes,
        ));
  }
}
