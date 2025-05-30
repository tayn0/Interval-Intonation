import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/practice_setup_screen.dart';
import 'screens/practice_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Intonation Trainer',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
      useMaterial3: true,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeScreen(),
      '/practiceSetup': (context) => const PracticeSetupScreen(),
      '/practiceSession': (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return PracticeScreen(
          baseNote: args['string'],
          interval: args['interval'],
          difficulty: args['difficulty'],
          repetitions: args['repetitions'],
        );
      },
    },
  );
}
}