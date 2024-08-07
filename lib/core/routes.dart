import 'package:checklist/features/checklist/presentation/pages/home.dart';
import 'package:checklist/features/checklist/presentation/pages/todo_info.dart';
import 'package:go_router/go_router.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: '/info/:id',
      name: 'info',
      builder: (context, state) => TodoInfo(id: state.pathParameters['id']!),
    ),
  ],
);
