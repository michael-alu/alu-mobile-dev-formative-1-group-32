import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formative_assignment_1/screens/main_screen.dart';
import 'package:formative_assignment_1/services/app_state.dart';
import 'package:formative_assignment_1/theme/app_theme.dart';

import 'package:formative_assignment_1/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()..loadData()),
      ],
      child: const StudentApp(),
    ),
  );
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Student Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
