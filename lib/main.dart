import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ).copyWith(primary: Colors.teal, secondary: Colors.deepPurple.shade300),
        useMaterial3: true,
        // scaffoldBackgroundColor: Colors.amber,
      ),
      home: HomeScreen(),
    );
  }
}
